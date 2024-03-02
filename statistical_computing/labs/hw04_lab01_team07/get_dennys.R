# Get Dennys restaraunt pages
library(tidyverse)
library(rvest)

# Read base URL for all the states
page = read_html("http://www2.stat.duke.edu/~cr173/data/dennys/locations.dennys.com/index.html")
URLs = page %>% html_elements(".Directory-listLink") %>%
  html_attr("href") %>%
  paste0("http://www2.stat.duke.edu/~cr173/data/dennys/locations.dennys.com/", .)

# Get URL for DC
rm_DC = str_remove(URLs,".html")
DC_placeholder = (1:length(URLs))[str_detect(rm_DC,"DC")]
URL_without_DC = URLs[-DC_placeholder]
DC_url=read_html(URLs[DC_placeholder]) %>%
  html_elements(".Teaser-titleLink") %>%
  html_attr("href") %>%
  paste0("http://www2.stat.duke.edu/~cr173/data/dennys/locations.dennys.com/DC/", .)

# Get URL for all other states
get_url=function(url){
  final_url=c()
  for (i in url){
    test = i %>%
      str_replace(".html", "")
    if (str_detect(test,"[:digit:]$")){
      final_url=c(final_url,i)
    }
    else {
      new_url=read_html(i) %>%
        html_elements(".Directory-listLink") %>%
        html_attr("href")
      for (j in new_url){
        test2 = j %>%
          str_replace(".html","")
        if (str_detect(test2,"[:digit:]$")){
          final_url=c(final_url,paste0("http://www2.stat.duke.edu/~cr173/data/dennys/locations.dennys.com/",j))
        }
        else{
          new_new_url=read_html(paste0("http://www2.stat.duke.edu/~cr173/data/dennys/locations.dennys.com/",j)) %>%
            html_elements(".Teaser-titleLink") %>%
            html_attr("href") %>%
            paste0(paste0(test,"/"), .)
          final_url=c(final_url,new_new_url)
        }
      }
    }
  }
  return(final_url)
}

URL_states=get_url(URL_without_DC)


# Join URLs
Final_URL=c(URL_states,DC_url)


# Create Directory
dir.create("data/dennys", recursive = TRUE, showWarnings = FALSE)

# Download Files
for (i in Final_URL){
  download.file(
    url = i,
    destfile = file.path("data/dennys", basename(i)),
    quiet = TRUE
  )
}

