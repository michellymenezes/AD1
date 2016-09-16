# server.R

library(shiny)
library(plotly)
library(readr)
library(dplyr)


shinyServer(function(input, output) {
  output$plot <- renderPlotly({
    
  })
  
})