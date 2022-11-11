# Exercício de pacote de R

# O projeto asn-auto (https://github.com/curso-r/asn-auto) possui funções
# que seria interessante serem empacotadas. A estrutura atual é a seguinte:

# train.R
# -- read_input_data()
# -- save_model()
# -- run_train()
# score.R
# -- get_existing_model()
# -- update_model()
# -- get_score()

# A sua missão é criar um pacote com essas 6 funções para depois podermos
# instalar e usar usando remotes::install_github("usuario/asnAuto").

# Instruções:

# 1) crie um projeto-pacote com usethis::create_package("asnAuto")
# 2) inicialize o usethis::use_git()
# 3) crie o repositorio do github com usethis::use_github()
# 4) crie um readme com usethis::use_readme_md()
# 4) teste se está dando para enviar arquivo para o github (dando git add -> git commit -> git push).
# 5) Altere o arquivo DESCRIPTION dando melhores nome e descrição.
# 6) crie o arquivo train.R e copie/cole as funções nele.
# 7) crie o arquivo score.R e copie/cole as funções nele.
# 8) aperte CTRL+SHIFT+D para gerar as documentações.
# 9) aperte CTRL+SHIFT+B para buildar o pacote.
# 10) escreva no console 'asnAuto::' para ver se a lista de funções
#     aparece.
# 11) rode devtools::check() para ver se tá tudo OK.
# 12) Se for possível compreender, conserte eventuais problemas listados.
# 13) commite tudo e dê push para o github.
# 14) rode remotes::install_github("usuario/asnAuto") para ver se
#     o pacote foi instalado. (Teste com library(asnAuto)).
# 15) EXTRA: crie teste com usethis::use_testthat() e usethis::use_test("train")
# 16) EXTRA: crie o site do pacote com usethis::use_pkgdown() e
#     pkgdown::build_site(). Após, jogue tudo no github e ligue o Github Pages.
# 17) EXTRA: use usethis::use_vignette("introducao") para criar uma "vignette"
#     com um tutorial de como usar as funções do pacote. Rode
#     pkgdown::build_site() e jogue tudo no github novamente.
# 18) EXTRA: crie uma função nova do zero e coloque o devido cabeçalho de
#     documentação.
