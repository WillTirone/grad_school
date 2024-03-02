library(shiny)
library(tidyverse)
library(DT)
library(shinythemes)

# The following line will load all of your R code from the qmd
# this will make your get_nyt_articles function available to your
# shiny app.
source(
  knitr::purl("midterm2.qmd", output=tempfile(), quiet=TRUE)
)

shinyApp(
  ui = fluidPage(
    shinythemes::themeSelector(),
    titlePanel("NYTimes API"),
    sidebarLayout(
      sidebarPanel(
        numericInput("Y", "Year", min=1851, max=2022, value = 2012),
        numericInput("M", "Month", min=1, max=12, value = 10),
        numericInput("D", "Day", min=1, max=31, value = 6),
        textInput("key", "API Key", value = "7AHIplo8KhJz9CnzarEN6FwqCxGqBB3m"),
        actionButton("api_button", "Make API Call!")
        ),
      mainPanel(
        img(src = "nyt.png", 
            height = 200, width = 400),
        uiOutput("links"),
        textOutput("error_msg")
      )
    )
  ),
  
  server = function(input, output, session) {
    
    
    state = reactiveValues(
      observers = list()
    )

    
    # pull in the data when the button is clicked 
    nyt_data = eventReactive(input$api_button, {
      get_nyt_articles(input$Y,input$M,input$D,input$key) 
    })


    # majority of app is here, triggers when API button is clicked 
    # creates links, and populates modal dialogs 
    observeEvent(input$api_button, {
      
      data = nyt_data() #|> 
        #dplyr::select(title, byline, lead_par, url, img_link)
      num_articles = dim(data)[1]
      output$error_msg = 
        renderText({
          validate(
            need(num_articles != 0, 
               "Sorry, there are no articles that day!"))})
      
      req(state$observers)
      
      # Destroy existing observers
      purrr::walk(state$observers, ~ .x$destroy())
      

      
      # mapping to create links based on titles
      ui_elems = purrr::map(
        seq_len(num_articles), 
        function(i) {
          fluidRow(
            actionLink(
              paste0("link",i),
              data[i,] |> dplyr::select(title) |> as.character() 
              )
            )
          }
        )
      
      output$links = renderUI(fluidPage(ui_elems))
      
      purrr::map(
      seq_len(num_articles), 
      function(i) {
        label=paste0("link",i)
          observeEvent(input[[label]], {
            showModal(
              modalDialog(
                size = 'l',
                h3({nyt_data()[i,'title'] |>  as.character()}),
                h4({nyt_data()[i,'author'] |>  as.character()}),
                h5({nyt_data()[i,'lead_paragraph'] |>  as.character()}),
                renderUI({tags$a(href=nyt_data()[i,'web_url'], "Link to Article")}),
                renderUI(tags$img(src = nyt_data()[i,'img_url']))
            )
          )
        })
      }
    )
      
    # Reset and create new observers for each of our links
    state$observers = purrr::map(
      seq_len(num_articles), 
      function(i) {
        label = paste0("link",i)
        observeEvent(input[[label]], ignoreInit = TRUE, {
          cat("You clicked link ", i,"!\n",sep="")
        })
      }
    )
      
    })
  }
)