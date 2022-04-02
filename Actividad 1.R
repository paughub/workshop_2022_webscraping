exp(20)
log(20,base = 2)


valor_suma  = 2+2
valor_suma2 <- 2+5

valor_suma == valor_suma2

# Librerias --
# Son paquetes de funciones que dispone la comunidad para el uso gratuito de estas
# Ejemplos de estas son tidyverse, rvest, RSleneium

# install.packages('tidyverse')
# install.packages('rvest')
# install.packages('RSelenium')
# install.packages('dplyr')

# library(dplyr)
# library(rvest)
# library(RSelenium)

# Actividad 1 =========================

library(dplyr)
library(rvest)

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




