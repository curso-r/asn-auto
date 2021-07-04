source("score.R")
source("train.R")


#* Scora um carro
#*
#* @param cylinders  dsfdsfds
#* @param displacement dfsdfsd
#* @param horsepower fddsfsd
#* @param weight sdfsd
#* @param acceleration dsfsdf
#* @param year sdfdf
#* @param origin sdfsdf
#* @post /score
scora_um <- function(
  cylinders,
  displacement,
  horsepower,
  weight,
  acceleration,
  year,
  origin,
  force_model_update = FALSE
) {
  browser()

  model_path <- "models"
  force_model_update <- as.logical(force_model_update)
  # checa se já tem modelo para utilizar
  if(length(list.files(model_path)) > 0 & !force_model_update) {
    model = get_existing_model(model_path)
  } else {
    model = update_model(model_path = model_path,
                      container_url = 'https://asnrocksstorage.blob.core.windows.net/',
                      key = Sys.getenv('STORAGE_ACCOUNT_KEY'))
  }

  input_dict = list(
    cylinders = cylinders,
    displacement = displacement,
    horsepower = horsepower,
    weight = weight,
    acceleration = acceleration,
    year = year,
    origin = origin
  )

  input_dict$name <- ""

  score = get_score(input_dict, model$model)
  score$.pred
}


#* @get /train
train <- function() {
  run_train(
    data_path = 'data',
    data_file = 'auto.xlsx',
    model_path = 'models/',
    model_name = glue::glue('auto_model_{strftime(Sys.time(), "%Y-%m-%d--%H-%M-%S")}.rds'),
    key = Sys.getenv('STORAGE_ACCOUNT_KEY'),
    container_url = 'https://asnrocksstorage.blob.core.windows.net/'
  )
}

#* @get /env
config <- function() {
  as.list(Sys.getenv())
}

#* @get /
config <- function() {
  200
}

