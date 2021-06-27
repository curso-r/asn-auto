library(AzureStor)

# conexao com o storage ---------------------------------------------------
storage_account_name = "asnrocksstorage"
region = "centralus"
key = Sys.getenv('STORAGE_ACCOUNT_KEY')
blob_con = blob_endpoint(
  endpoint = glue::glue("https://{storage_account_name}.blob.core.windows.net/"),
  key = key
)

# criacao/conexao com o blob container ------------------------------------
list_storage_containers(blob_con)
container_client = create_blob_container(blob_con, name = "data")
list_storage_containers(blob_con)

list_blobs(container_client)

# upload de arquivos no blob container ------------------------------------
storage_write_csv(mtcars, container_client, file = "mtcars.csv")

download.file("https://avatars.githubusercontent.com/u/1925102", "prof_athos.png", method = "curl")
storage_upload(container_client,  "prof_athos.png", "prof_athos.png",)

# download de um arquivo do blob container --------------------------------
storage_download(container_client, "prof_athos.png", "prof_athos_downloaded.png", overwrite = TRUE)

ls("package:AzureStor")

