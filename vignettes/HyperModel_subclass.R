## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, eval = F)

## -----------------------------------------------------------------------------
#  HyperModel <- reticulate::PyClass(
#    'HyperModel',
#  
#    inherit = kerastuneR::HyperModel,
#  
#    list(
#  
#      `__init__` = function(self, num_classes) {
#  
#        self$num_classes = num_classes
#        NULL
#      },
#  
#      build = function(self,hp) {
#        model = keras_model_sequential()
#        model %>% layer_dense(units = hp$Int('units',
#                                             min_value=32,
#                                             max_value=512,
#                                             step=32),
#                              activation='relu') %>%
#          layer_dense(as.integer(self$num_classes), activation='softmax') %>%
#          compile(
#            optimizer= tf$keras$optimizers$Adam(
#              hp$Choice('learning_rate',
#                        values=c(1e-2, 1e-3, 1e-4))),
#            loss='categorical_crossentropy',
#            metrics='accuracy')
#      }
#    )
#  )

## -----------------------------------------------------------------------------
#  
#  # generate some data
#  
#  x_data <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
#  y_data <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
#  
#  x_data2 <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
#  y_data2 <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
#  
#  # subclass
#  
#  HyperModel <- reticulate::PyClass(
#    'HyperModel',
#  
#    inherit = kerastuneR::HyperModel_class(),
#  
#    list(
#  
#      `__init__` = function(self, num_classes) {
#  
#        self$num_classes = num_classes
#        NULL
#      },
#  
#      build = function(self,hp) {
#        model = keras_model_sequential()
#        model %>% layer_dense(units = hp$Int('units',
#                                             min_value = 32,
#                                             max_value = 512,
#                                             step=32),
#                              input_shape = ncol(x_data),
#                              activation = 'relu') %>%
#          layer_dense(as.integer(self$num_classes), activation = 'softmax') %>%
#          compile(
#            optimizer= tf$keras$optimizers$Adam(
#              hp$Choice('learning_rate',
#                        values=c(1e-2, 1e-3, 1e-4))),
#            loss='categorical_crossentropy',
#            metrics='accuracy')
#      }
#    )
#  )
#  
#  # Random Search
#  
#  hypermodel = MyHyperModel(num_classes = 10)
#  
#  tuner = RandomSearch(
#      hypermodel,
#      objective='val_accuracy',
#      max_trials=10,
#      directory='my_dir',
#      project_name='helloworld')
#  
#  # Run
#  
#  tuner %>% fit_tuner(x_data,y_data,
#                      epochs = 5,
#                      validation_data = list(x_data2, y_data2))
#  

