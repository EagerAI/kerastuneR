context("build(hp) - Hyperclass")

source("utils.R")

test_succeeds("Can run hyper_class", {
  library(keras)
  library(tensorflow)
  library(dplyr)
  library(kerastuneR)
  
  x_data <- matrix(data = runif(250,0,1),nrow = 50,ncol = 5)
  y_data <- ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
  
  x_data2 <- matrix(data = runif(250,0,1),nrow = 50,ncol = 5)
  y_data2 <- ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
  
  
  HyperModel <- reticulate::PyClass(
    'HyperModel',
    inherit = kerastuneR::HyperModel_class(),
    list(
      
      `__init__` = function(self, num_classes) {
        
        self$num_classes = num_classes
        NULL
      },
      build = function(self,hp) {
        model = keras_model_sequential() 
        model %>% layer_dense(units = hp$Int('units',
                                             min_value = 32L,
                                             max_value = 512L,
                                             step = 32L),
                              input_shape = ncol(x_data),
                              activation = 'relu') %>% 
          layer_dense(as.integer(self$num_classes), activation = 'softmax') %>% 
          compile(
            optimizer = tf$keras$optimizers$Adam(
              hp$Choice('learning_rate',
                        values = c(1e-2, 1e-3, 1e-4))),
            loss = 'sparse_categorical_crossentropy',
            metrics = 'accuracy')
      }
    )
  )
  
  hypermodel = HyperModel(num_classes=10L)
  
  testthat::expect_match(capture.output(hypermodel),'HyperModel')
  
  tuner = RandomSearch(hypermodel = hypermodel,
                       objective = 'val_accuracy',
                       max_trials = 2,
                       executions_per_trial = 1)
  
  testthat::expect_match(tuner %>% capture.output(), 'keras_tuner.tuners.randomsearch.RandomSearch')
  
  search_summary(tuner)
})


