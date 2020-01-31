context('hp space')
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


tuner = RandomSearch(
  hypermodel =  mnist_model,
  max_trials=5,
  hyperparameters=hp,
  tune_new_entries=T,
  objective='val_accuracy',
  directory='my_dir4',
  project_name = 'mnist_')

testthat::expect_match(capture.output(tuner),'kerastuner.tuners.randomsearch.RandomSearch')

