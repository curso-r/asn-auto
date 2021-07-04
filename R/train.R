library(magrittr)
teste <- "OK!"

#' Read Input Data
#'
#' Downloads specified data file from specified container,
#' import this data to a data.frame an returns it.
#' Data file must be Excel file, container URL and key
#' must be from Azure Blob Storage.
#'
#' @param data_path (string) path to data
#' @param data_file (string) a file name with .xlsx extension
#' @param container_url (string) azure container url
#' @param key (string) Auth key from Azure Blob Storage
#'
#' @return a data.frame
read_input_data <- function(
  data_path = 'data',
  data_file = 'auto.xlsx',
  container_url = 'https://asnrocksstorage.blob.core.windows.net/',
  key = Sys.getenv('STORAGE_ACCOUNT_KEY')
) {
  # Instanciated a container client
  container_client = AzureStor::blob_endpoint(
    endpoint = container_url,
    key = key
  ) %>%
    AzureStor::blob_container("data")

  # Download blob to local disk
  output_path = file.path(data_path, data_file)
  AzureStor::storage_download(
    container = container_client,
    src = data_file,
    dest = output_path,
    overwrite = TRUE
  )

  # Read file to data.frame
  readxl::read_excel(output_path)
}

#' Save Model
#'
#' First, serialize model object to pickle and save to disk, then uploads it to
#' cloud.
#'
#' @param model
#' @param model_path
#' @param model_name
#' @param container_url
#' @param key
#'
#' @return
#' @export
#'
#' @examples
save_model <- function(
  model,
  model_path = 'models/',
  model_name = glue::glue('auto_model_{strftime(start_time, "%Y-%m-%d--%H-%M-%S")}.rds'),
  container_url = 'https://asnrocksstorage.blob.core.windows.net/',
  key = Sys.getenv('STORAGE_ACCOUNT_KEY')
) {
  # Save model to disk
  if(!dir.exists(model_path)) dir.create(model_path)
  file_path <- file.path(model_path, model_name)
  saveRDS(model, file_path)

  # Instanciated a container client
  container_client = AzureStor::blob_endpoint(
    endpoint = container_url,
    key = key
  ) %>%
    AzureStor::blob_container("data")

  # First checks if a file with same names already exists
  if(!AzureStor::blob_exists(container_client, file_path))
    AzureStor::storage_upload(container_client,  file_path, file_path)

  print('Upload completed!')
}


#' Run Train
#'
#' Run the complete model training flow Downloads and imports data from cloud,
#' run all transformation pipeline, fit model and save it to cloud.
#'
#' @param data_path
#' @param data_file
#' @param model_path
#' @param model_name
#' @param container_url
#' @param key
#'
#' @return
#' @export
#'
#' @examples
run_train <- function(
  data_path,
  data_file,
  model_path,
  model_name,
  container_url,
  key,
  seed = 1992
) {
  # download and import input data
  auto_df = read_input_data(data_path, data_file, container_url, key)

  # split train and test subsets
  set.seed(seed)
  auto_initial_split <- rsample::initial_split(auto_df, prop = 0.25)
  auto_train <- rsample::training(auto_initial_split)

  # dataprep
  auto_recipe <- recipes::recipe(mpg ~ ., auto_train) %>%
    recipes::step_rm(name) %>%
    recipes::step_mutate(
      cylinder_displacement = cylinders*displacement,
      specific_torque = horsepower/cylinder_displacement,
      fake_torque = weight/acceleration,
      origin = as.factor(origin)
    ) %>%
    recipes::step_log(recipes::all_numeric_predictors()) %>%
    recipes::step_normalize(recipes::all_numeric_predictors()) %>%
    recipes::step_novel(recipes::all_nominal_predictors()) %>%
    recipes::step_dummy(recipes::all_nominal_predictors())

  # train model
  auto_model <- parsnip::linear_reg(penalty = tune(), mixture = 1) %>% # LASSO
    parsnip::set_engine("glmnet")

  # workflow
  auto_wf <- workflows::workflow() %>%
    workflows::add_model(auto_model) %>%
    workflows::add_recipe(auto_recipe)

  # resamples
  auto_resamples <- rsample::vfold_cv(auto_train, v = 5)

  # grid search
  grid <- expand.grid(
    penalty = c(0.0167, 0.0001, 0.001, 0.01, 0.1, 0.2, 0.5, 0.8, 1)
  )

  auto_tune_grid <- auto_wf %>%
    tune::tune_grid(
      resamples = auto_resamples,
      grid = grid,
      metrics = yardstick::metric_set(yardstick::rmse)
    )

  auto_best_model <- tune::select_best(auto_tune_grid, metric = "rmse")
  auto_wf <- auto_wf %>% tune::finalize_workflow(auto_best_model)

  # fit for all train set
  auto_last_fit <- auto_wf %>% tune::last_fit(auto_initial_split, metrics = yardstick::metric_set(yardstick::rmse))

  auto_metrics <- collect_metrics(auto_last_fit)
  message("Raíz do Erro Quadrático Médio: ", auto_metrics$.estimate)

  # fit for all dataset
  auto_fit <- auto_wf %>% parsnip::fit(auto_df)

  # save model
  save_model(auto_fit, model_path, model_name, container_url, key)
}


