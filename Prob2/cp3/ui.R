library(shiny)
library(plotly)

data <- read.table("data/ano-atual.csv", sep = ",", header = T, stringsAsFactors=FALSE)
data <- subset(data, txtDescricao == "Emissão Bilhete Aéreo")
data <- subset(data, vlrDocumento > 0)
data <- subset(data,!grepl("BSB", data$txtTrecho))

shinyUI(fluidPage(
  titlePanel("Checkpoint 3"),
  
  sidebarLayout(
    sidebarPanel(width = 3,
      helpText("Selecione um intervalo de data que deseja examinar.
               Você também pode escolher um filtro para visualizar por um parlamentar, partido político ou tipo de passageiro específico. Se não houver nenhum dado a ser mostrado na data selecionada, o gráfico completo será exibido. Caso o intervalo de data especificado não possua os dados dos demais filtros que escolheu para mostrar, serão exibidos todos os bilhetes existentes para o mesmo intervalo."),
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
    
    
    mainPanel(width = 9,
              h2("Bilhetes Aéreos"),
              br(),
              p("No gráfico abaixo se encontram bilhetes aéreos emitidos por parlamentares em 2016, sendo estes pagos com dinheiro público. No gráfico, especificamente, estão aqueles em que Brasília não está inclusa no trecho do bilhete. Os eixos x e y representam a data da emissão e valor, respectivamente"),
              p("Nem sempre os parlamentares são passageiros para bilhetes emitidos, em outras palavras, eles podem fazer a compra de um bilhete aéreo para uma terceira pessoa. É possível observar que alguns valores são extremamente altos comparados aos demais."),
              p("Há muitos aspectos que podem ser observados. Você pode explorar o gráfico selecionando apenas os dados que lhe interessam. Cada ponto representa um bilhete, é possível obter mais detalhes sobre eles ao passar o mouse sobre. Ao selecionar uma área do gráfico, você poderá observar em detalhes a parte desejada."),
              br(),
              plotlyOutput("plot"))
  )
))