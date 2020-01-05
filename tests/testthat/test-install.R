context("install_kerastuner")

library(keras)
library(tensorflow)
library(dplyr)
library(kerastuneR)

os = switch(Sys.info()[['sysname']],
            Windows= {paste("win")},
            Linux  = {paste("lin")},
            Darwin = {paste("mac")})

if(os %in% 'lin' | os %in% 'mac') {
  expect_vector(kerastuneR::install_kerastuner(python_path = '/usr/bin/python3.5'))
} else {
  testthat::expect_warning(kerastuneR::install_kerastuner())
}

