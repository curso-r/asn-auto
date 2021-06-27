key = Sys.getenv('STORAGE_ACCOUNT_KEY')
container_url = 'https://asnrocks.blob.core.windows.net/auto'

start_time = Sys.time()

data_path = 'data/'
data_file = 'auto.xlsx'

model_path = 'models/'
model_name = glue::glue('auto_model_{strftime(start_time, "%Y-%m-%d--%H-%M-%S")}.rds')

#' Read Input Data
#'
#' Downloads specified data file from specified container,
#' import this data to a data.frame an returns it.
#' Data file must be Excel file, container URL and key
#' must be from Azure Blob Storage.
read_input_data <- function(data_path, data_file, container_url, key) {
  # Instanciated a container client
  AzureStor::list_storage_containers()
  container_client = ContainerClient.from_container_url(
    container_url=container_url,
    credential=key)
}


    # Create a handle to the blob (the file)
    blob_client = container_client.get_blob_client(blob=data_path
                                                   + data_file)
    # Download blob to local disk
    with open(data_path + data_file, 'wb') as my_file:
      blob_data = blob_client.download_blob()
    blob_data.readinto(my_file)
    # close used handles
    blob_client.close()
    container_client.close()
    # Read file to pandas DataFrame
    dataframe = pd.read_excel(data_path + data_file)
    return dataframe



