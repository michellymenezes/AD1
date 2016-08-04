# server.R

data <- read.table("data/ano-atual.csv", sep = ",", header = T, stringsAsFactors=FALSE)

shinyServer(function(input, output) {

  output$plot <- renderPlot({

  })
  
})