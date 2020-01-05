context("build(hp)")

library(keras)
library(tensorflow)
library(dplyr)
library(kerastuneR)

x_data <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
y_data <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()

x_data2 <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
y_data2 <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()


build_model = function(hp) {
  
  model = keras_model_sequential()
  model %>% layer_dense(units=hp$Int('units',
                                     min_value = 32,
                                     max_value = 512,
                                     step = 32),
                        input_shape = ncol(x_data),
                        activation = 'relu') %>% 
    layer_dense(units = 1, activation ='softmax') %>% 
    compile(
      optimizer = tf$keras$optimizers$Adam(
        hp$Choice('learning_rate',
                  values=c(1e-2, 1e-3, 1e-4))),
      loss = 'binary_crossentropy',
      metrics = 'accuracy') 
  return(model)
}

build_model2 = function(hp) {
  
  model = keras_model_sequential()
  for (i in (hp$Int('num_layers', 2, 20)) ) {
    model %>% layer_dense(units=hp$Int(paste('units_',i,sep = ''),
                                       min_value = 32,
                                       max_value = 512,
                                       step = 32),input_shape = ncol(x_data),
                          activation = 'relu') %>% 
      layer_dense(units = 1L, activation='softmax')
  } %>% 
    compile(
      optimizer = tf$keras$optimizers$Adam(
        hp$Choice('learning_rate',
                  values=c(1e-2, 1e-3, 1e-4))),
      loss = 'binary_crossentropy',
      metrics = 'accuracy') 
  return(model)
  
}

tuner2 = RandomSearch(hypermodel = build_model2,
                                  objective = 'val_accuracy',
                                  max_trials = 2,
                                  executions_per_trial = 1,
                                  directory = 'my_dir3',
                                  project_name = 'helloworld')

testthat::expect_match(tuner2 %>% capture.output(), 'kerastuner.tuners.randomsearch.RandomSearch')

search_summary(tuner2)

tuner2 %>% fit_tuner(x_data, y_data, epochs = 5, validation_data = list(x_data2,y_data2))

res = tuner2 %>% get_best_models(1) %>% .[[1]] %>% capture.output() %>% .[1]

testthat::expect_output(print(res),regexp ='Model')

expect_warning(kerastuneR::results_summary())

