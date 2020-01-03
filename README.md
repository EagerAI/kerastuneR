## R interface to Keras Tuner

Keras Tuner is a hypertuning framework made for humans. 
It aims at making the life of AI practitioners, hypertuner algorithm creators and model designers as simple as possible by providing them with a clean and easy to use API for hypertuning. Keras Tuner makes moving from a base model to a hypertuned one quick and easy by only requiring you to change a few lines of code.

<img src="images/kerastuneR.png" width=200 align=right style="margin-left: 15px;" alt="Keras Tuner"/>


[![Travis-CI Build Status](https://travis-ci.com/henry090/kerastuneR.svg?branch=master)](https://travis-ci.com/henry090/kerastuneR) 
[![Build status](https://ci.appveyor.com/api/projects/status/u24fa1vvuyms3xpk/branch/master?svg=true)](https://ci.appveyor.com/project/henry090/kerastuner-trmkf/branch/master)
[![Codecov test coverage](https://codecov.io/gh/henry090/kerastuneR/branch/master/graph/badge.svg)](https://codecov.io/gh/henry090/kerastuneR?branch=master)

A hyperparameter tuner for [Keras](https://keras.io/), specifically for ```tf$keras``` with *TensorFlow 2.0*.

Full documentation and tutorials available on the [Keras Tuner website](https://henry090.github.io/kerastuneR/).

## Installation

Currently, the package is available on github:

```
devtools::install_github('henry090/kerastuneR')
```

Later, you need to install the python module kerastuner:

```
kerastuneR::install_kerastuner(python_path = 'paste_python_path')
```

## Usage: the basics

Here's how to perform hyperparameter tuning for a single-layer dense neural network using random search.

First, we define a model-building function. It takes an argument ```hp``` from which you can sample hyperparameters, such as ```hp$Int('units', min_value = 32, max_value = 512, step = 32)``` (an integer from a certain range).

Sample data:

```
x_data <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
y_data <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()

x_data2 <- matrix(data = runif(500,0,1),nrow = 50,ncol = 5)
y_data2 <-  ifelse(runif(50,0,1) > 0.6, 1L,0L) %>% as.matrix()
```

This function returns a compiled model.

```
library(keras)
library(kerastuneR)
library(dplyr)

build_model = function(hp) {
  
  model = keras_model_sequential()
  model %>% layer_dense(units = hp$Int('units',
                                      min_value = 32,
                                      max_value = 512,
                                      step = 32),
                                      input_shape = ncol(x_data)
                                      activation = 'relu') %>% 
  layer_dense(units = 1, activation = 'sigmoid') %>% 
  compile(
    optimizer = tf$keras$optimizers$Adam(
      hp$Choice('learning_rate',
                values = c(1e-2, 1e-3, 1e-4))),
    loss = 'binary_crossentropy',
    metrics = 'accuracy') 
  return(model)
}
```


Next, instantiate a tuner. You should specify the model-building function, the name of the objective to optimize (whether to minimize or maximize is automatically inferred for built-in metrics), the total number of trials ```(max_trials)``` to test, and the number of models that should be built and fit for each trial ```(executions_per_trial)```.

Available tuners are ```RandomSearch``` and ```Hyperband```.

> Note: the purpose of having multiple executions per trial is to reduce results variance and therefore be able to more accurately assess the performance of a model. If you want to get results faster, you could set executions_per_trial=1 (single round of training for each model configuration).

```
tuner = RandomSearch(
    build_model,
    objective = 'val_accuracy',
    max_trials = 5,
    executions_per_trial = 3,
    directory = 'my_dir',
    project_name = 'helloworld')
```

You can print a summary of the search space:

```
tuner %>% search_summary()
```

Then, start the search for the best hyperparameter configuration. The call to search has the same signature as ```model %>% fit()```. But here instead of ```fit()``` we call ```fit_tuner()```.

```
tuner %>% fit_tuner(x_data,y_data,
                    epochs = 5, 
                    validation_data = list(x_data2,y_data2))
```
Documentation, advanced model building, and tutorials can be found on https://henry090.github.io/kerastuneR/


