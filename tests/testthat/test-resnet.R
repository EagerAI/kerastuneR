context("build(hp) - ResNet")
library(keras)
library(dplyr)
library(kerastuneR)

cifar <- dataset_cifar10()

hypermodel = kerastuneR::HyperResNet(input_shape = list(300L, 300L, 3L), classes = 10L)

testthat::expect_match(hypermodel %>% capture.output(),'kerastuner.applications.resnet.HyperResNet')

tuner = kerastuneR::Hyperband(
  hypermodel = hypermodel,
  objective = 'accuracy',
  loss = 'sparse_categorical_crossentropy',
  max_epochs = 1,
  directory = 'my_dir',
  project_name='helloworld')

testthat::expect_match(tuner %>% capture.output(),'kerastuner.tuners.hyperband.Hyperband')

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
  print('Done')
}
