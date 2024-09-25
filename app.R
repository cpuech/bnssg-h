### BNSSG BASIC SHINY APP TEMPLATE ###

## Packages
library(tidyverse) #data manipulation
library(ggiraph) #interactive plots
library(DT) #tables
library(leaflet) #mapping
library(here) #project directory working
library(shiny) #create shiny app

# load dummy data for map and R dataset mtcars
dummy_map_data <- tibble(variable = c("Option 1", "Option 2", "Option 3"),
                         lat = c(51.54224, 51.52900, 51.45457),
                         long = c(-2.411816, -2.499227, -2.433032))

data("mtcars")

   
# App layout (ie. user interface)
ui <- navbarPage(
  
  ## Formatting ----
  
  # Add logo to tab banner at the top with link to BNSSG HT website
  title = div(
    tags$a(img(src = "ht_logo.png")
           , href = "https://bnssghealthiertogether.org.uk/"
           , target = "_blank" 
           ),
    style = "position: relative; top: -20px;"
    ),
  
  #title for web browser tab
  windowTitle = "BNSSG Shiny Template", 
  
  # Add css styles and web browser tab icon
  header = tags$head(includeCSS("www/styles.css") # CSS styles
                     , tags$link(rel = "shortcut icon", 
                                 href = "ht_logo_cut.png") #Icon for browser tab
                     ),
  
  ## Home tab ----
  
  tabPanel("Home",
           icon = icon("home"), 
           h1("R Shiny Template with BNSSG Theme"), 
           h2("A subtitle"),
           p("Some text.")
  ),

  
  ## TAB 1 ----
  
  tabPanel("Tab 1",
           icon = icon("map"), 
           
           # custom set up
           fluidRow(
             column(4, #size of column (out of 12)
                    
                    p("This is a tab with a map."),
                    
                    selectInput("myinputname", 
                                label = "Example drop-down",
                                choices = c("Option 1", "Option 2", "Option 3"))
                    
             ),
             
             column(8, #size of column (out of 12)
                    
                    leafletOutput("mymap", height = 600)
             )
             
           )
           
    ),
  
  
  ## TAB 2 ----
  
  tabPanel("Tab 2",
           icon = icon("table"),
           
           fluidRow(
             column(12,
                    p("This is a tab with a table."))
             
           ),
           
           fluidRow(             
           column(12,
                  DTOutput('mytable'))
           
           )
           
           )
  
) #navbarPage


# Server logic
server <- function(input, output) {

  # create a reactive datasets based on inputs selected
  mapdat <- reactive({

      dummy_map_data %>%
        filter(variable == input$myinputname)

  })
  
  # create a map
  output$mymap <- renderLeaflet({
    
    leaflet() %>%
      
      addProviderTiles(provider =  providers$CartoDB.Voyager) %>% 
      
      addMarkers(data = mapdat(),
                 lat = ~lat, 
                 lng = ~long,
      )
    
  })
  
  # create a table
  output$mytable <- renderDT({mtcars})
  
}

# Run the application 
shinyApp(ui = ui, server = server)
