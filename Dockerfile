FROM rocker/tidyverse:latest

RUN apt update
RUN apt install libxml2-dev openssl libssl-dev libcurl4-openssl-dev libsodium-dev -y

COPY . .

RUN R -e 'install.packages("renv")'
RUN R -e 'renv::restore()'

EXPOSE 8080

CMD ["Rscript", "R/run_api.R"]
