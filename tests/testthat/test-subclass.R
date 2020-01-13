context("build(hp) - Subclass")

library(keras)
library(tensorflow)
library(dplyr)
library(kerastuneR)

x_data <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
y_data <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()

x_data2 <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
y_data2 <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()

MyHyperModel <- reticulate::PyClass(
  "HyperModel",
  
  inherit = kerastuneR::HyperModel_class(),
  
  list(
    
    `__init__` = function(self, num_classes) {
      
      self$num_classes = num_classes
      NULL
    },
    
    build = function(self,hp) {
      model = keras_model_sequential() 
      model %>% layer_dense(units = hp$Int('units',
                                           min_value=32L,
                                           max_value=512L,
                                           step=32L),
                            activation='relu') %>% 
        layer_dense(as.integer(self$num_classes), activation='softmax') %>% 
        compile(
          optimizer= tf$keras$optimizers$Adam(
            hp$Choice('learning_rate',
                      values=c(1e-2, 1e-3, 1e-4))),
          loss='categorical_crossentropy',
          metrics='accuracy')
    }
  )
)

hypermodel = MyHyperModel(num_classes=10)

tuner = RandomSearch(
  hypermodel,
  objective = 'val_accuracy',
  max_trials = 2,
  executions_per_trial = 3,
  directory = 'my_dir22',
  project_name = 'helloworld2')

tuner %>% fit_tuner(x_data, y_data, epochs=2,
                    validation_data=list(x_data2, y_data2))







