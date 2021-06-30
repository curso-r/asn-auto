library(magrittr)
library(glmnet)

key = Sys.getenv('STORAGE_ACCOUNT_KEY')
container_url = 'https://asnrocksstorage.blob.core.windows.net/'

source("R/score.R")
source("R/train.R")

# teste do train ----------------------------------------------------------
# benchmarking
microbenchmark::microbenchmark({
  run_train(
    data_path = 'data',
    data_file = 'auto.xlsx',
    model_path = 'models/',
    model_name = glue::glue('auto_model_{strftime(Sys.time(), "%Y-%m-%d--%H-%M-%S")}.rds'),
    key = Sys.getenv('STORAGE_ACCOUNT_KEY'),
    container_url = 'https://asnrocksstorage.blob.core.windows.net/'
  )
}, times = 2)



# teste do score ----------------------------------------------------------
input_dict = list(
  'cylinders' = 8,
  'displacement' = 320,
  'horsepower' = 150,
  'weight' = 3449,
  'acceleration' = 11.0,
  'year' = 70,
  'origin' = 1,
  'name' = NA
)

model = get_model(model_path = "models", container_url, key)
score = get_score(input_dict, model$model)
score
