context("build(hp) - ResNet")
library(keras)
library(dplyr)
library(kerastuneR)

cifar <- dataset_cifar10()

hypermodel = kerastuneR::HyperResNet(input_shape = list(300L, 300L, 3L), classes = 10L)

tuner = kerastuneR::Hyperband(
  hypermodel = hypermodel,
  objective = 'accuracy',
  loss = 'sparse_categorical_crossentropy',
  max_epochs = 1,
  directory = 'my_dir',
  project_name='helloworld')

train_data = cifar$train$x[1:30,1:32,1:32,1:3]
test_data = cifar$train$y[1:30,1] %>% as.matrix()
rm(cifar)
tuner %>%  fit_tuner(x = tf$image$resize(train_data, size = shape(300, 300)),
                     y = test_data, epochs = 1)

