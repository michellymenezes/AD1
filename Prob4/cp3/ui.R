# ui.R

library(shiny)
library(plotly)


shinyUI(fluidPage(
  titlePanel("Checkpoint 3"),
  
  sidebarLayout(
    sidebarPanel(width = 3,
                 helpText()),
    
    mainPanel(width = 9,
              h2("Filmes"),
              plotlyOutput("plot"))
    
  )
))