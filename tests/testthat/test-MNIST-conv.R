context("build(hp) - MNIST")

source("utils.R")

test_succeeds("Can run hyper_class", {
  library(dplyr)
  library(tfdatasets)
  library(kerastuneR)
  
  conv_build_model <- function(hp) {
    inputs <- tf$keras$Input(shape = list(28L, 28L, 1L))
    x <- inputs
    
    for (i in 1:hp$Int('conv_layers', 1L, 3L, default = 3L)) {
      x <- tf$keras$layers$Conv2D(
        filters = hp$Int(paste('filters_', i, sep = ''), 4L, 32L, step = 4L, default = 8L),
        kernel_size = hp$Int(paste('kernel_size_', i, sep = ''), 3L, 5L),
        activation = 'relu',
        padding = 'same'
      )(x)
      
      pool_type <- hp$Choice(paste('pooling', i, sep = ''), c('max', 'avg'))
      if (pool_type == 'max') {
        x <- tf$keras$layers$MaxPooling2D(pool_size = c(2L, 2))(x) # Adding pool_size argument
      } else {
        x <- tf$keras$layers$AveragePooling2D(pool_size = c(2L, 2))(x) # Adding pool_size argument
      }
      
      x <- tf$keras$layers$BatchNormalization()(x)
      x <- tf$keras$layers$ReLU()(x)
    }
    
    global_pooling_type <- hp$Choice('global_pooling', c('max', 'avg'))
    if (global_pooling_type == 'max') {
      x <- tf$keras$layers$GlobalMaxPool2D()(x)
    } else {
      x <- tf$keras$layers$GlobalAveragePooling2D()(x)
    }
    
    outputs <- tf$keras$layers$Dense(10L, activation = 'softmax')(x)
    model <- tf$keras$Model(inputs, outputs)
    
    optimizer <- hp$Choice('optimizer', c('adam', 'sgd'))
    model %>% compile(optimizer, loss = 'sparse_categorical_crossentropy', metrics = 'accuracy')
    
    return(model)
  }
  
  
  testthat::expect_length(class(Hyperband(
    hypermodel = conv_build_model,
    objective='val_accuracy',
    max_epochs = 1,
    factor = 2,
    hyperband_iterations = 1,
    directory = 'results_dir',
    project_name = 'mnist')),5)
  
  
  
  main = function() {
    tuner = Hyperband(
      hypermodel = conv_build_model,
      objective = 'val_accuracy',
      max_epochs = 1,
      factor = 2,
      hyperband_iterations = 1,
      directory = 'model_dir2',
      project_name = 'mnist_c')
    
    mnist_data = dataset_fashion_mnist()
    c(mnist_train, mnist_test) %<-%  mnist_data
    rm(mnist_data)
    
    mnist_train$x = tf$reshape(mnist_train$x,shape = c(6e4L,28L,28L,1L))
    mnist_test$x = tf$reshape(mnist_test$x,shape = c(1e4L,28L,28L,1L))
    
    mnist_train =  tensor_slices_dataset(list(tf$dtypes$cast(mnist_train$x, 'float32') / 255., mnist_train$y)) %>% 
      dataset_shuffle(1e3) %>% dataset_batch(1e2) %>% dataset_repeat()
    
    mnist_test = tensor_slices_dataset(list(tf$dtypes$cast(mnist_test$x, 'float32') / 255., mnist_test$y)) %>%
      dataset_batch(1e2)
    
    
    tuner %>% fit_tuner(x = mnist_train,
                        steps_per_epoch=600,
                        validation_data=mnist_test,
                        validation_steps=100,
                        epochs=1
    )
  }
})

