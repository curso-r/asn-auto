#' Get Existing Model
#'
#' List all models and downloads last one, assumes order by name import
#' dowloaded model
#'
#' @param model_path
#'
#' @return
#' @export
#'
#' @examples
get_existing_model <- function (model_path) {
  model_name <- list.files(model_path, full.names = TRUE)
  model_name <- model_name[length(model_name)]
  list(
    model = readRDS(model_name),
    last_model_name = model_name
  )
}

#' Update Model
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
update_model <- function (model_path, container_url, key) {
  # Instanciated a container client
  container_client = AzureStor::blob_endpoint(
    endpoint = container_url,
    key = key
  ) %>%
    AzureStor::blob_container("data")

  # Sort all models
  models_list <- AzureStor::list_blobs(container_client, model_path)
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

