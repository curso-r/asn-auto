library(plumber)

p <- plumb("R/endpoints.R")

p$run(port = as.integer(Sys.getenv("PORT", unset = 8080)), host = "0.0.0.0")
