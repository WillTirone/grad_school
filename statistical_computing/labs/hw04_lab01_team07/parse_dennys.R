library(rvest)
library(tidyverse)

stopifnot(dir.exists("data/"))

d = tibble(
  files = dir("data/dennys")
)
files=d[[1]]
result = matrix(NA,length(files),6)

for (i in seq_along(files)){
  file=read_html(paste0("data/dennys/",files[i]))
  state=file %>%
    html_elements("[itemprop=addressRegion]")%>% 
    html_text()
  city=file %>% 
    html_elements("[class=c-address-city]") %>%
    html_text()
  latitude=file %>% 
    html_elements("[itemprop=latitude]")%>% 
    html_attr("content")
  longitude=file %>% 
    html_elements("[itemprop=longitude]")%>% 
    html_attr("content")
  streetadd=file %>%
    html_elements("[itemprop=streetAddress]") %>%
    html_attr("content")
  phone=file %>%
    html_elements("[itemprop=telephone]") %>%
    html_text()
  result[i,1]=state
  result[i,2]=city
  result[i,4]=latitude[1]
  result[i,3]=longitude[1]
  result[i,5]=streetadd
  result[i,6]=phone
}

colnames(result) = c("State","City","Longitude","Latitude","Street Address","Phone Number")
options(digits=17)
result=tibble(as.data.frame(result)) %>%
  mutate(Longitude=as.numeric(Longitude),Latitude=as.numeric(Latitude))

saveRDS(result, "data/dennys.rds")
