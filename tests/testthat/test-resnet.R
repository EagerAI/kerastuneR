context("build(hp) - ResNet")

source("utils.R")

test_succeeds("Can run hyper_class", {

  library(dplyr)
  library(kerastuneR)
  
  cifar <- dataset_cifar10()
  
  hypermodel = HyperResNet(input_shape = list(300L, 300L, 3L), classes = 10L)
  hypermodel2 = HyperXception(input_shape = list(300L, 300L, 3L), classes = 10L)
  
  
  tuner = Hyperband(
    hypermodel = hypermodel,
    objective = 'val_accuracy',
    max_epochs = 1,
    directory = 'my_dir',
    project_name='helloworld')
  
  
  train_data = cifar$train$x[1:30,1:32,1:32,1:3]
  test_data = cifar$train$y[1:30,1] %>% as.matrix()
  rm(cifar)
  
  os = switch(Sys.info()[['sysname']],
              Windows= {paste("win")},
              Linux  = {paste("lin")},
              Darwin = {paste("mac")})
  if (os %in% 'win') {
    #tuner %>%  fit_tuner(x = tf$image$resize(train_data, size = shape(300, 300)), y = test_data, epochs = 1)
    print('Done')
  } else {
    #tuner %>%  fit_tuner(x = tf$image$resize(train_data, size = shape(300, 300)), y = test_data, epochs = 1,
    #                     validation_split=0.2)
    print('Done')
  }
})
