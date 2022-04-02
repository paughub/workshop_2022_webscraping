# Librerias ----

library(tidyverse)       # Conjunto de paquetes de DS
library(data.table)      # Procesamiento de datos de forma parapelizada (eficiente para grandes volumenes de datos)
library(rvest)           # Libreria para hacer web scraping de forma estatica
library(emayili)         # Función para enviar correos electronicos
library(RSelenium)       # Libreria para hacer web scraping de forma dinamica
if(require("openxlsx") == FALSE){install.packages("openxlsx");library("openxlsx")}else{library("openxlsx")}

# ================================================
# Pagina web ----

N_Paginas <- pagina %>% 
  html_nodes(xpath = "//li[@class = 'andes-pagination__button']") %>% 
  html_attr('tabindex') %>% 
  as.numeric() %>% 
  max()

datos <- map_dfr(1:N_Paginas, .f = function(x){
  
  pagina <- read_html(paste0("https://www.mercadolibre.cl/ofertas?cat=MLC1051&page=",x))
  
  P_Descuento <- pagina %>% 
    html_nodes(xpath = "//span[@class = 'promotion-item__price']") %>% 
    html_text2()
  
  P_S_Descuento <- pagina %>% 
    html_nodes(xpath = "//span[@class = 'promotion-item__oldprice']") %>% 
    html_text2()
  
  # Descuento <- pagina %>% 
  #   html_nodes(xpath = "//span[@class = 'promotion-item__discount']") %>% 
  #   html_text2()
  
  N_Producto <- pagina %>% 
    html_nodes(xpath = "//p[@class = 'promotion-item__title']") %>% 
    html_text2()
  
  URL <- pagina %>% 
    html_nodes(xpath = "//a[@class = 'promotion-item__link-container']") %>% 
    html_attr('href')
  
  tibble(Nombre = N_Producto,
         Precio_real = P_S_Descuento,
         Precio_oferta = P_Descuento,
         URL)
  
  Sys.sleep(runif(1,1,3))
})


openxlsx::write.xlsx(datos, file = "Ofertas mercado libre.xlsx")


# Enviamos el correo electronico


# Configuramos el servidor 
smtp <- server(host = "smtp.gmail.com",         # Nombre del servidor, en este caso Google
               port = 465,                      # Número del puerto, 587 = TSL
               username = "dimunozu@gmail.com", # Usuario
               password = "***") # Contraseña


email <- envelope(from = "dimunozu@gmail.com",
                  to = c("rnparra@uc.cl","fpeede@uc.cl","cfpaez@uc.cl"), 
                  cc = "dimunoz1@uc.cl",
                  subject = "Nota evaluación 2 - regresión logística") %>%  
  html("<p>Hola</p>
<p>Este es mi primer correo electronico enviado desde R. Es super practico cuando debes enviarle las notas a 220 alumnos en el diplomado, Alexis, me merezco un aumento.</p>
<p>Saludos cordiales.</p>")
attachment(path = "C:\\Users\\diego\\Desktop\\Clase de web scraping\\Clase de web scraping\\Ofertas mercado libre.xlsx")

smtp(email, verbose = TRUE)


# ================

install.packages("rvest")
remotes::install_github("dmi3kno/polite")

library(polite)
library(rvest)

session <- bow("https://www.cheese.com/by_type", force = TRUE)
result <- scrape(session, query=list(t="semi-soft", per_page=100)) %>%
  html_node("#main-body") %>% 
  html_nodes("h3") %>% 
  html_text()
head(result)
#> [1] "3-Cheese Italian Blend"  "Abbaye de Citeaux"      
#> [3] "Abbaye du Mont des Cats" "Adelost"                
#> [5] "ADL Brick Cheese"        "Ailsa Craig"


