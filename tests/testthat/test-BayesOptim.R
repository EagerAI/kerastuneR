context("build(hp) - Bayesian Optimization")

source("utils.R")

test_succeeds("Can run Bayesian Optimization as oracle", {
  
  library(keras)
  library(tensorflow)
  library(dplyr)
  library(tfdatasets)
  library(kerastuneR)
  library(reticulate)
  library(purrr)
  
  conv_build_model = function(hp) {
    'Builds a convolutional model.'
    inputs = tf$keras$Input(shape=c(28L, 28L, 1L))
    
    x = inputs
    
    for (i in 1:hp$Int('conv_layers', 1L, 3L, default=3L)) {
      x = tf$keras$layers$Conv2D(filters = hp$Int(paste('filters_', i, sep = ''), 4L, 32L, step=4L, default=8L),
                                 kernel_size = hp$Int(paste('kernel_size_', i, sep = ''), 3L, 5L),
                                 activation ='relu',
                                 padding='same')(x)
      if (hp$Choice(paste('pooling', i, sep = ''), c('max', 'avg')) == 'max') {
        x = tf$keras$layers$MaxPooling2D()(x)
      } else {
        x = tf$keras$layers$AveragePooling2D()(x)
      }
      x = tf$keras$layers$BatchNormalization()(x) 
      x =  tf$keras$layers$ReLU()(x)
      
    }
    if (hp$Choice('global_pooling', c('max', 'avg')) == 'max') {
      x =  tf$keras$layers$GlobalMaxPooling2D()(x)
    } else {
      x = tf$keras$layers$GlobalAveragePooling2D()(x)
    }
    
    outputs = tf$keras$layers$Dense(10L, activation='softmax')(x)
    model = tf$keras$Model(inputs, outputs)
    optimizer = hp$Choice('optimizer', c('adam', 'sgd'))
    model %>% compile(optimizer, loss='sparse_categorical_crossentropy', metrics='accuracy')
    return(model)
  }
  
  MyTuner = reticulate::PyClass(
    'Tuner',
    inherit = kerastuneR::Tuner_class(),
    list(
      run_trial = function(self, trial, train_ds){
        hp = trial$hyperparameters
        train_ds = train_ds$batch(hp$Int('batch_size', 32L, 128L, step=32L, default=64L))
        model = self$hypermodel$build(trial$hyperparameters)
        lr = hp$Float('learning_rate', 1e-4, 1e-2, sampling='log', default=1e-3)
        optimizer = tf$keras$optimizers$Adam(lr)
        epoch_loss_metric = tf$keras$metrics$Mean()
        
        
        run_train_step = function(data){
          images = data[[1]]
          labels = data[[2]]
          
          
          with (tf$GradientTape() %as% tape,{
            logits = model(images)
            loss = tf$keras$losses$sparse_categorical_crossentropy(labels, logits)
            if(length(model$losses) > 0){
              loss = loss + tf$math$add_n(model$losses)
            }
            gradients = tape$gradient(loss, model$trainable_variables)
          })
          optimizer$apply_gradients(transpose(list(gradients, model$trainable_variables)))
          epoch_loss_metric$update_state(loss)
          loss
        }
        
        for (epoch in 1:1) {
          print(paste('Epoch',epoch))
          self$on_epoch_begin(trial, model, epoch, logs= list())
          intializer = make_iterator_one_shot(train_ds)
          
          for (batch in 1:length(iterate(train_ds))) {
            
            init_next = iter_next(intializer)
            
            self$on_batch_begin(trial, model, batch, logs=list())
            batch_loss = as.numeric(run_train_step(init_next))
            self$on_batch_end(trial, model, batch, logs=list('loss' = batch_loss))
            
            if (batch %% 100L == 0L){
              loss = epoch_loss_metric$result()$numpy()
              print(paste('Batch',batch,  'Average loss', loss))
            }
          }
          
          epoch_loss = epoch_loss_metric$result()$numpy()
          self$on_epoch_end(trial, model, epoch, logs=list('loss'= epoch_loss))
          epoch_loss_metric$reset_states()
        }
      }
    )
  )
  
  
  tuner = MyTuner(
    oracle=BayesianOptimization(
      objective=Objective(name='loss', direction = 'min'),
      max_trials=1),
    hypermodel=conv_build_model,
    directory=file.path(tempdir(), 'bayes_oracle'),
    project_name='mnist_custom_training2')
  
  mnist_data = dataset_fashion_mnist()
  c(mnist_train, mnist_test) %<-%  mnist_data
  rm(mnist_data)
  
  mnist_train$x = tf$cast(mnist_train$x, 'float32') / 255
  
  mnist_train$x = keras::k_reshape(mnist_train$x,shape = c(6e4,28,28,1))
  mnist_train$y = tf$dtypes$cast(mnist_train$y, 'float32') 
  
  if (!Sys.info()[1] %in% 'Windows') {
    mnist_train = tensor_slices_dataset(mnist_train) %>% dataset_shuffle(1e3)
    tuner %>% fit_tuner(train_ds = mnist_train)
  }
})


test_succeeds("Can run Bayesian Optimization as tuner", {
  library(keras)
  library(dplyr)
  library(kerastuneR)
  
  mnist_data = dataset_fashion_mnist()
  c(mnist_train, mnist_test) %<-%  mnist_data
  rm(mnist_data)
  
  mnist_train$x = tf$dtypes$cast(mnist_train$x, 'float32') / 255.
  mnist_test$x = tf$dtypes$cast(mnist_test$x, 'float32') / 255.
  
  mnist_train$x = keras::k_reshape(mnist_train$x,shape = c(6e4,28,28))
  mnist_test$x = keras::k_reshape(mnist_test$x,shape = c(1e4,28,28))
  
  
  hp = HyperParameters()
  hp$Choice('learning_rate',values =c(1e-1, 1e-3))
  hp$Int('num_layers', 2L, 20L)
  
  testthat::expect_match(capture.output(hp),'kerastuner.engine.hyperparameters.HyperParameters')
  
  
  mnist_model = function(hp) {
    
    model = keras_model_sequential() %>% 
      layer_flatten(input_shape = c(28,28))
    for (i in 1:(hp$get('num_layers')) ) {
      model %>% layer_dense(32, activation='relu') %>% 
        layer_dense(units = 10, activation='softmax')
    } %>% 
      compile(
        optimizer = tf$keras$optimizers$Adam(hp$get('learning_rate')),
        loss = 'sparse_categorical_crossentropy',
        metrics = 'accuracy') 
    return(model)
    
  }
  
  
  tuner = BayesianOptimization(
    seed = 42,
    hypermodel =  mnist_model,
    max_trials=5,
    num_initial_points = 2,
    hyperparameters=hp,
    tune_new_entries=T,
    objective='val_accuracy',
    directory=file.path(tempdir(), 'bayes_tuner'),
    project_name = 'mnist_')
  
  testthat::expect_match(capture.output(tuner),'kerastuner.tuners.bayesian.BayesianOptimization')
  
  tuner %>% fit_tuner(x = mnist_train$x, 
                      y = mnist_train$y, 
                      batch_size = 6000, 
                      epochs = 5, 
                      validation_data = list(mnist_test$x, mnist_test$y))
  unlink('my_dir6', recursive = T)
  
  testthat::expect_match(capture.output(tuner$get_best_hyperparameters()[[1]]), 'kerastuner.engine.hyperparameters.HyperParameters')
})
