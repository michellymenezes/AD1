library(shiny)
library(plotly)

data <- read.table("data/ano-atual.csv", sep = ",", header = T, stringsAsFactors=FALSE)
data <- subset(data, txtDescricao == "Emissão Bilhete Aéreo")
data <- subset(data, vlrDocumento > 0)
data <- subset(data,!grepl("BSB", data$txtTrecho))

shinyUI(fluidPage(
  titlePanel("Checkpoint 3"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Selecione um intervalo de data que deseja examinar.
               Você também pode escolher um filtro para visualizar por um parlamentar ou partido político específico."),
      br(),
          
      dateRangeInput("dates", 
        "Intervalo de data",
        start = "2016-01-01", 
        end = "2016-05-31"),
      
      br(),
      
      radioButtons("radio2", label = h4("Tipo de passageiro"), 
                  choices = list("Parlamentar" = 1, "Terceiro" = 2, "Parlamentar e Terceiro" = 3), selected = 3),

      radioButtons("radio", label = h4("Agrupamento"),
                   choices = list("Nenhum" = 1, "Por parlamentar" = 2,
                                  "Por partido" = 3),selected = 1),
      conditionalPanel(
        condition = "input.radio == 2",
        selectInput("select1", label = h4("Nome do parlamentar"), 
                    choices = unique(data$txNomeParlamentar))),
      conditionalPanel(
        condition = "input.radio == 3",
        selectInput("select2", label = h4("Nome do Partido"), 
                    choices = unique(data$sgPartido)))),
    
    
    mainPanel(plotlyOutput("plot"))
  )
))