#' Call this function as an addin to insert "HyperModel class" at the cursor position.
#' @export
HyperModel <- function() {  
  rstudioapi::insertText("HyperModel <- reticulate::PyClass(
  'HyperModel',
  
  inherit = kerastuneR::HyperModel,
  
  list(
    
    `__init__` = function(self, num_classes) {
      
      self$num_classes = num_classes
      NULL
    },
    
    build = function(self,hp) {
      model = keras_model_sequential() 
      model %>% layer_dense(units = hp$Int('units',
                                           min_value=32,
                                           max_value=512,
                                           step=32),
                            activation='relu') %>% 
        layer_dense(as.integer(self$num_classes), activation='softmax') %>% 
        compile(
          optimizer= tf$keras$optimizers$Adam(
            hp$Choice('learning_rate',
                      values=c(1e-2, 1e-3, 1e-4))),
          loss='categorical_crossentropy',
          metrics='accuracy')
    }
  )"
) 

  
}

