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
  origin
) {
  if(input_dict == "") return(400)

  model = get_model(model_path = "models",
                    container_url = 'https://asnrocksstorage.blob.core.windows.net/',
                    key = Sys.getenv('STORAGE_ACCOUNT_KEY'))

  input_dict <- as.data.frame(input_dict)
  input_dict$name <- ""

  score = get_score(input_dict, model$model)
  score
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
