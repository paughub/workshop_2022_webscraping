# Librerias --
# Son paquetes de funciones que dispone la comunidad para el uso gratuito de estas
# Ejemplos de estas son tidyverse, rvest, RSleneium

# install.packages('tidyverse')
# install.packages('RSelenium')
# install.packages('dplyr')
# install.packages('rvest')
# install.packages('stringr')
# install.packages('purrr')

# library(dplyr)
# library(rvest)
# library(RSelenium)
# library(stringr)


# Actividad 1 =========================

library(dplyr)
library(rvest)
library(stringr)
library(purrr)

# 1) Encuentre el número de páginas de productos en oferta
# Windows: control + shift + M
# Mac: Comando + shift + M



pagina <- read_html('https://www.mercadolibre.cl/ofertas?promotion_type=deal_of_the_day&container_id=MLC779365-1#origin=qcat&filter_applied=promotion_type&filter_position=2')


N_Paginas <- pagina %>% 
  html_element(xpath = '//ul[@class = "andes-pagination"]') %>% 
  html_children() %>% 
  html_text2() %>% 
  as.numeric() %>% 
  max(na.rm = TRUE) %>% 
  suppressWarnings()


Nombre <- pagina %>% 
  html_elements(xpath = '//p[@class = "promotion-item__title"]') %>% 
  html_text2()


pagina %>% 
  html_elements(., xpath = '//span[@class = "promotion-item__oldprice"]') %>% 
  html_text2(.) %>% 
  str_remove_all(., '\\$ ') %>% 
  str_remove_all(.,'\\.') %>% 
  as.numeric(.)


newprice <- pagina %>% 
  html_elements(xpath = '//span[@class = "promotion-item__price"]') %>% 
  html_text2() %>% 
  str_remove_all('\\$ ') %>% 
  str_remove_all('\\.') %>% 
  as.numeric()


pagina %>% 
  html_elements(xpath = '//span[@class = "promotion-item__shipping"]') %>% 
  html_text2()



pagina %>% 
  html_element(xpath = '//ol[@class = "items_container"]/li[3]//span[@class = "promotion-item__shipping"]') %>% 
  html_text2() %>% 
  if_else(is.na(.),'Sin envio gratis',.) %>% 
  if_else(identical(character(0),.),'Sin envio gratis',.)
  
x = 25
paste0('hola soy diego y tengo x años')
paste0('hola soy diego y tengo ',x,' años')

1:length(Nombre) %>% 
  map_chr(.f = function(x){
    pagina %>% 
      html_element(xpath = paste0('//ol[@class = "items_container"]/li[',x,']//span[@class = "promotion-item__shipping"]')) %>% 
      html_text2() %>% 
      if_else(is.na(.),'Sin envio gratis',.) %>% 
      if_else(identical(character(0),.),'Sin envio gratis',.)
  })

