context("install_kerastuner")
library(kerastuneR)

os = switch(Sys.info()[['sysname']],
            Windows= {paste("win")},
            Linux  = {paste("lin")},
            Darwin = {paste("mac")})

testthat::expect_warning(kerastuneR::install_kerastuner())

testthat::expect_vector(kerastuneR::install_kerastuner(python_path = Sys.which('python')))
