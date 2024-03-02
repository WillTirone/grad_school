library(tidyverse)
library(rvest)
require(kableExtra)

stopifnot(dir.exists("data/"))
files = dir("data/lq")

#create a dataframe to save information
lq = data.frame()
#use for loop to extract information from html
for(i in files){
  loc = readr::read_file(paste0("data/lq/",i))%>%
    read_html()%>%html_elements("[class=address-info]>a")%>%
    html_attr("href")%>%.[1]%>%str_extract(.,'(?<=\\=)([0-9.-]{3,}),([0-9.-]{3,})+')%>%
    str_split(',')
  lattitude = loc[[1]][1]
  longtitude = loc[[1]][2]
  Phone = readr::read_file(paste0("data/lq/",i))%>%
    read_html()%>%html_elements("[class=address-info]>a")%>%
    html_attr("href")%>%.[2]%>%str_replace("(?s)tel:","")
  
  Address = readr::read_file(paste0("data/lq/",i))%>%
    read_html()%>% html_nodes(".hidden-xs.property-address")%>%html_text()%>%
    str_replace_all(., "[\r\n]" ,"")%>%
    str_replace_all("\\s{2,}", "")
  
  
  Name = readr::read_file(paste0("data/lq/",i))%>%
    read_html()%>% html_nodes(".hidden-xs.property-name")%>%html_text()%>%
    str_replace_all(., "[\r\n]" ,"")%>%
    str_replace_all("\\s{2,}", "")
  
  lq = rbind(lq,list(Name,Address,Phone,lattitude,longtitude))
}

#change column name
colnames(lq) = c('HotelName','Address','Phone','lattitude','longtitude')

saveRDS(lq, "data/lq.rds")
