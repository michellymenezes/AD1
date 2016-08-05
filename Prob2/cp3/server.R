# server.R

library(shiny)
library(dplyr, warn.conflicts = F)
library(readr)
library(ggplot2)
library(plotly)
library(scales)
library(data.table)

data <- read.table("data/ano-atual.csv", sep = ",", header = T, stringsAsFactors=FALSE)
data <- subset(data, txtDescricao == "Emissão Bilhete Aéreo")
data <- subset(data, vlrDocumento > 0)
data <- subset(data,!grepl("BSB", data$txtTrecho))


data$datEmissao <- substr(data$datEmissao,1,10)
data$datEmissao <- as.Date(data$datEmissao)

data$txtPassageiro[data$txtPassageiro != data$txNomeParlamentar] <- "Terceiro"
data$txtPassageiro[data$txtPassageiro == data$txNomeParlamentar] <- "Parlamentar"

#data$txtTrecho[!grepl("BSB", data$txtTrecho)] <- FALSE
#data$txtTrecho[grepl("BSB", data$txtTrecho)] <- TRUE

setnames(data, old=c("vlrDocumento","datEmissao", "txtPassageiro"), new=c("Valor", "Data", "Tipo"))

shinyServer(function(input, output) {
  output$plot <- renderPlotly({
    setData <- subset(data, Data >= input$dates[1] & Data <= input$dates[2])

    if(input$radio2 == 1){
      setData <- subset(data, Data >= input$dates[1] & Data <= input$dates[2])
      setData <- subset(setData, Tipo == "Parlamentar")
      
      if(input$radio==2){
        if(nrow(subset(data, grepl(input$select1, setData$txNomeParlamentar))) > 0){
          setData <- subset(setData, grepl(input$select1, setData$txNomeParlamentar))
        }
      }
      else if(input$radio==3){
        if(nrow(subset(data, grepl(input$select2, setData$sgPartido))) > 0){
          setData <- subset(setData, grepl(input$select2, setData$sgPartido))
        }
      }
    }
    
    else if (input$radio2 == 2){
      setData <- subset(data, Data >= input$dates[1] & Data <= input$dates[2])
      setData <- subset(setData, Tipo != "Parlamentar")
      
      if(input$radio==2){
        if(nrow(subset(data, grepl(input$select1, setData$txNomeParlamentar))) > 0){
          setData <- subset(setData, grepl(input$select1, setData$txNomeParlamentar))
        }
      }
      else if(input$radio==3){
        if(nrow(subset(data, grepl(input$select2, setData$sgPartido))) > 0){
          setData <- subset(setData, grepl(input$select2, setData$sgPartido))
        }
      }
    }
    
    else if (input$radio2 == 3){
      setData <- subset(data, Data >= input$dates[1] & Data <= input$dates[2])
      if(input$radio==2){
        if(nrow(subset(data, grepl(input$select1, setData$txNomeParlamentar))) > 0){
          setData <- subset(setData, grepl(input$select1, setData$txNomeParlamentar))
        }
      }
      else if(input$radio==3){
        if(nrow(subset(data, grepl(input$select2, setData$sgPartido))) > 0){
          setData <- subset(setData, grepl(input$select2, setData$sgPartido))
        }
      }
    }
    
    if(nrow(setData)==0){
      setData <- data
    }
    
    
  
    p = ggplot( setData, aes(Data, Valor, color= Tipo, text = paste("Nome:", txNomeParlamentar,"<br>Trecho:", txtTrecho, "<br>Partido:", sgPartido))) + 
      geom_point(position = position_jitter(width = .1), alpha = .4) +
      scale_color_manual(values = c("Parlamentar" = 'orange', "Terceiro" = 'darkturquoise')) +
      labs(colour="Tipo passageiro", title="Bilhetes emitidos além de BSB",
      y="Valor", x="Data de emissão do bilhete") +
      guides(fill=guide_legend(title = "Passageiro é um terceiro beneficiado")) +
      scale_x_date()

   (gg <- ggplotly(p))
    
  })
  
})