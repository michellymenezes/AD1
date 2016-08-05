# server.R

library(shiny)
library(dplyr, warn.conflicts = F)
library(readr)
library(ggplot2)
library(plotly)
library(scales)
library(data.table)
theme_set(theme_bw())

data <- read.table("data/ano-atual.csv", sep = ",", header = T, stringsAsFactors=FALSE)
data <- subset(data, txtDescricao == "Emissão Bilhete Aéreo")
data <- subset(data, vlrDocumento > 0)
data <- subset(data,!grepl("BSB", data$txtTrecho))


data$datEmissao <- substr(data$datEmissao,1,10)
data$datEmissao <- as.Date(data$datEmissao)

data$txtPassageiro[data$txtPassageiro != data$txNomeParlamentar] <- FALSE
data$txtPassageiro[data$txtPassageiro == data$txNomeParlamentar] <- TRUE

#data$txtTrecho[!grepl("BSB", data$txtTrecho)] <- FALSE
#data$txtTrecho[grepl("BSB", data$txtTrecho)] <- TRUE

setnames(data, old=c("vlrDocumento","datEmissao"), new=c("Valor", "Data"))

shinyServer(function(input, output) {
  output$plot <- renderPlotly({
    setData <- subset(data, Data >= input$dates[1] & Data <= input$dates[2])
      if(input$radio==2){
        setData <- subset(data, Data >= input$dates[1] & Data <= input$dates[2])
        if(nrow(subset(data, grepl(input$dpt_name, setData$txNomeParlamentar))) > 0){
          setData <- subset(setData, grepl(input$dpt_name, setData$txNomeParlamentar))
        }
      }
      else if(input$radio==3){
        setData <- subset(data, Data >= input$dates[1] & Data <= input$dates[2])
        if(nrow(subset(data, grepl(input$par_name, setData$sgPartido))) > 0){
          setData <- subset(setData, grepl(input$par_name, setData$sgPartido))
        }
      }
      else if(input$radio==1){
        setData <- subset(data, Data >= input$dates[1] & Data <= input$dates[2])
        
      }
  
    p = ggplot( setData, aes(Data, Valor, color= txtPassageiro, text = paste("Nome:", txNomeParlamentar,"<br>Trecho:", txtTrecho, "<br>Partido:", sgPartido))) + 
      geom_point(alpha = .4) +
      ylab("Valor do bilhete emitido") + 
      xlab("Data de emissão do bilhete") + scale_x_date()

   (gg <- ggplotly(p))
    
  })
  
})