
skip_if_no_kerastuneR <- function(required_version = NULL) {
  if (!reticulate::py_module_available("kerastuner"))
    skip("Keras Tuner not available for testing")
}

skip_if_no_tf_version <- function(required_version) {
  if (!reticulate::py_module_available("tensorflow"))
    skip("TensorFlow is not available.")
  
  if (tensorflow::tf_version() < required_version)
    skip(paste0("Needs TF version >= ", required_version))
}

test_succeeds <- function(desc, expr) {
  test_that(desc, {
    skip_if_no_kerastuneR()
    skip_if_no_tf_version("2.0")
    expect_error(force(expr), NA)
  })
}


