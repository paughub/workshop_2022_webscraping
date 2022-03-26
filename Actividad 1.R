# Actividad 1

# Librerias ----

library(tidyverse)       # Conjunto de paquetes de DS
library(data.table)      # Procesamiento de datos de forma parapelizada (eficiente para grandes volumenes de datos)
library(rvest)           # Libreria para hacer web scraping de forma estatica
library(emayili)         # Función para enviar correos electronicos
library(RSelenium)       # Libreria para hacer web scraping de forma dinamica
if(require("openxlsx") == FALSE){install.packages("openxlsx");library("openxlsx")}else{library("openxlsx")}

# ================================================
# Pagina web ----

pagina <- read_html(paste0("https://www.mercadolibre.cl/ofertas?promotion_type=deal_of_the_day"))

N_Paginas <- pagina %>% 
  html_nodes(xpath = '//li[contains(@class, "pagination__button")]') %>% 
  html_text2() %>% 
  as.numeric() %>% 
  suppressWarnings() %>% 
  max(na.rm = TRUE)

datos <- map_df(1:N_Paginas, .f = function(x){
  
  pagina <- read_html(paste0("https://www.mercadolibre.cl/ofertas?promotion_type=deal_of_the_day&page=",x))
  
  N_Paginas <- pagina %>% 
    html_nodes(xpath = '//li[contains(@class, "pagination__button")]') %>% 
    html_text2() %>% 
    as.numeric() %>% 
    suppressWarnings() %>% 
    max(na.rm = TRUE)
  
  N_Producto <- pagina %>% 
    html_nodes(xpath = "//p[@class = 'promotion-item__title']") %>% 
    html_text2()
  
  P_S_Descuento <- pagina %>% 
    html_nodes(xpath = "//span[@class = 'promotion-item__oldprice']") %>% 
    html_text2()
  
  P_Descuento <- pagina %>% 
    html_nodes(xpath = "//span[@class = 'promotion-item__price']") %>% 
    html_text2()
  
  Envio <- 1:length(N_Producto) %>% 
    map_chr(.f = function(x){
    pagina %>% 
      html_elements(xpath = paste0('//ol[@class="items_container"]/li[',x,']//span[@class = "promotion-item__shipping"]')) %>% 
      html_text2() %>% 
      ifelse(identical(character(0),.),NA,.)
  })
  
  Envio_FULL <- 1:length(N_Producto) %>% 
    map_chr(.f = function(x){
      pagina %>% 
        html_elements(xpath = paste0('//ol[@class="items_container"]/li[',x,']//svg')) %>% 
        html_text2() %>% 
        identical(character(0),.) %>% 
        ifelse(.,NA,'Envio FULL')
    })
  
  Vendedor <- 1:length(N_Producto) %>% 
    map_chr(.f = function(x){
      pagina %>% 
        html_nodes(xpath = paste0('//ol[@class="items_container"]/li[',x,']/a/div/div/span[@class ="promotion-item__seller"]')) %>% 
        html_text2() %>% 
        str_remove_all("por ") %>% 
        ifelse(identical(character(0),.),NA,.)
    })
  
  URL <- pagina %>% 
    html_nodes(xpath = "//a[@class = 'promotion-item__link-container']") %>% 
    html_attr('href')
  
  Sys.sleep(runif(1,1,3))
  
  tibble(Nombre = N_Producto,
         Precio_real = P_S_Descuento,
         Precio_oferta = P_Descuento,
         Envio = Envio,
         Envio_FULL = Envio_FULL,
         Vendedor = Vendedor,
         URL = URL)
})
