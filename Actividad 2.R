# RSelenium
library(tidyverse)
library(RSelenium)

system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE) # Se finalizan los procesos Java

driver <- RSelenium::rsDriver(browser = "chrome", 
                              chromever = "100.0.4896.60")
remote_driver <- driver[["client"]]


remote_driver$navigate('https://www.segurosripley.cl/')



remote_driver$findElement('xpath','//input[@placeholder = "AABB99"]')$sendKeysToElement(list('ABCD12'))
