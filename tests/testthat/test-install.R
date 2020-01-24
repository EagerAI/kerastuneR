context("install_kerastuner")
library(kerastuneR)

os = switch(Sys.info()[['sysname']],
            Windows= {paste("win")},
            Linux  = {paste("lin")},
            Darwin = {paste("mac")})

kerastuneR::install_kerastuner()
