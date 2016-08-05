# server.R

library(shiny)
library(dplyr, warn.conflicts = F)
library(readr)
library(ggplot2)
library(plotly)
library(scales)
theme_set(theme_bw())

data <- read.table("data/ano-atual.csv", sep = ",", header = T, stringsAsFactors=FALSE)
data <- subset(data, txtDescricao == "Emissão Bilhete Aéreo")
data <- subset(data, vlrDocumento > 0)
data <- subset(data, data$txtPassageiro != data$txNomeParlamentar)


data$datEmissao <- substr(data$datEmissao,1,10)
data$datEmissao <- as.Date(data$datEmissao)

#data$txtPassageiro[data$txtPassageiro != data$txNomeParlamentar] <- FALSE
#data$txtPassageiro[data$txtPassageiro == data$txNomeParlamentar] <- TRUE

data$txtTrecho[!grepl("BSB", data$txtTrecho)] <- FALSE
data$txtTrecho[grepl("BSB", data$txtTrecho)] <- TRUE

shinyServer(function(input, output) {
  output$plot <- renderPlotly({
    
    setData <- subset(data, datEmissao >= input$dates[1] & datEmissao <= input$dates[2])
      
    p = ggplot( setData,
                   aes(datEmissao, vlrDocumento)) + 
      geom_point(alpha = .4) +
      ylab("Valor do bilhete emitido") + 
      xlab("Data de emissão do bilhete") + scale_x_date()

   (gg <- ggplotly(p))
    
  })
  
})