context("build(hp)")

source("utils.R")

test_succeeds("Can run build(hp) and plot_tuner()", {
  library(keras)
  library(tensorflow)
  library(dplyr)
  library(kerastuneR)
  library(testthat)
  
  num_samples <- 1000
  input_dim <- 20
  output_dim <- 1
  X_train <- matrix(runif(num_samples * input_dim, 0, 1), nrow = num_samples, ncol = input_dim)
  y_train <- matrix(runif(num_samples * output_dim, 0, 1), nrow = num_samples, ncol = output_dim)
  
  
  
  build_model <- function(hp) {
    model <- keras_model_sequential()
    
    for (i in 1:(hp$Int('num_layers', min_value = 1, max_value = 5))) {
      if (i == 1) {
        model %>% 
          layer_dense(units = hp$Int(paste('units_', i, sep = ''), min_value = 32, max_value = 512, step = 32),
                      input_shape = c(input_dim),
                      activation = 'relu')
      } else {
        model %>% 
          layer_dense(units = hp$Int(paste('units_', i, sep = ''), min_value = 32, max_value = 512, step = 32),
                      activation = 'relu')
      }
    }
    
    model %>% 
      layer_dense(units = output_dim, activation = 'linear') %>% 
      compile(
        optimizer = optimizer_adam(learning_rate = hp$Choice('learning_rate', values = c(1e-2, 1e-3, 1e-4))),
        loss = 'mean_squared_error',
        metrics = c('mse')
      )
    
    return(model)
  }
  
  
  
  tuner2 = RandomSearch(build_model,objective='val_mse',max_trials=5,
                        max_retries_per_trial = 5,
                        project_name='hello'
  )
  
  search_summary(tuner2)
  
  if (!Sys.info()[1] %in% 'Windows_') {
    
    
      tuner2 %>% fit_tuner(X_train, y_train,
                         validation_split=0.2,
                         epochs=10)  
    
      res = tuner2 %>% get_best_models(1) %>% .[[1]] %>% capture.output() %>% .[1]
      
      testthat::expect_output(print(res),regexp ='Model')
      
      tuner2 %>% results_summary(12)
      
      extract_model = tuner2 %>% get_best_models(1) %>% .[[1]]
    
      tuner2 %>% plot_tuner()
      
      # Get the best hyperparameters and build the best model
      best_hps = tuner2$get_best_hyperparameters(num_trials=1L)[[1]]
      best_model = tuner2$hypermodel$build(best_hps)
      
      # Train the best model
      best_model %>% fit(X_train, y_train, epochs=50, validation_split=0.2)
    
  }
})

