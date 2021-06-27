library(magrittr)

key = Sys.getenv('STORAGE_ACCOUNT_KEY')
container_url = 'https://asnrocksstorage.blob.core.windows.net/'

#' Get Model
#'
#' List all models and downloads last one, assumes order by name import
#' dowloaded model
#'
#' @param model_path
#' @param container_url
#' @param key
#'
#' @return
#' @export
#'
#' @examples
get_model <- function (model_path, container_url, key) {
  # Instanciated a container client
  container_client = AzureStor::blob_endpoint(
    endpoint = container_url,
    key = key
  ) %>%
    AzureStor::blob_container("data")

  # Sort all models
  models_list <- list_blobs(container_client, model_path)
  last_model_name <- max(models_list$name)

  # Download blob to local disk
  model <- AzureStor::storage_load_rds(container_client,  last_model_name)

  list(
    model = model,
    last_model_name = last_model_name
  )
}

#' Get Score
#'
#' Receiva all features in a dic, Predicts score and return it
#'
#' @param params_dict
#' @param model_package
#'
#' @return
#' @export
#'
#' @examples
get_score <- function(params_dict, model_package) {
  # from list to data.frame

  workflows:::predict.workflow(model_package, new_data = as.data.frame(params_dict))
}

# Predict score
score = model.predict(pd.DataFrame.from_dict({1:params_dict},
                                             orient='index'))

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

model = get_model(model_path, container_url, key)
score = get_score(input_dict, model$model)
