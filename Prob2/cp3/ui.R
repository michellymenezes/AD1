library(shiny)
library(plotly)

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

      radioButtons("radio", label = h4("Filtro"),
                   choices = list("Nenhum" = 1, "Por parlamentar" = 2,
                                  "Por partido" = 3),selected = 1),
      conditionalPanel(
        condition = "input.radio == 2",
        textInput("dpt_name", "Nome do parlamentar", "CÁSSIO CUNHA LIMA")),
      conditionalPanel(
        condition = "input.radio == 3",
        textInput("par_name", "Nome do partido", "PT"))),
    
    
    mainPanel(plotlyOutput("plot"))
  )
))