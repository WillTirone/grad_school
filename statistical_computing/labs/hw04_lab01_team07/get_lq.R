# Get LQ hotel pages
library(tidyverse)
library(rvest)

# Read base URL for all the states
page = read_html("http://www2.stat.duke.edu/~cr173/data/lq/www.wyndhamhotels.com/laquinta/locations.html")
#Read all hotels' url
URLs = page %>% html_elements(".property a:nth-child(1)") %>%
  html_attr("href")%>%
  paste0("http://www2.stat.duke.edu/~cr173/data/lq/www.wyndhamhotels.com/laquinta/", .)

#use state name to filter 
state = paste(state.name,collapse =  '|')%>%
  tolower()%>%str_replace_all(' ','-')
#split out states name and detect
Loc =page %>% html_elements(".property a:nth-child(1)") %>%
  html_attr("href")%>%str_split('/')
Loc = Loc[str_detect(URLs, regex(state, ignore_case = TRUE))]
#create a new list to name html
location = c()
for(i in 1:length(Loc)){
  location = rbind(location,paste0(Loc[[i]][1],Loc[[i]][2]))
}

#filter hotel in the U.S.
URLs_US = tibble(URLs)%>%
  filter(
    str_detect(URLs, regex(state, ignore_case = TRUE))
  )

Data = cbind(location,URLs_US)
# Download
dir.create("data/lq", recursive = TRUE, showWarnings = FALSE)


# Download Files
for(i in 1:nrow(Data)){
  download.file(
    url = Data$URLs[i],
    destfile = file.path("data/lq", paste0(Data$location[i],'-',basename(Data$URLs[i] ))),
    quiet = TRUE
  )
  if(i%%50==0){
    print(paste0('finish',i,'download'))
  }
}

