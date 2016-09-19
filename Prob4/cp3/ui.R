# ui.R

# Para filmes com um determinado gênero, como eles evoluem ao longo do tempo 
# com relação a notas em avaliações?

# Para filmes com mais de um gênero, se fixarmos um gênero, quais gêneros combinados
# com o fixado rendem melhores avaliações?


library(shiny)
library(plotly)


shinyUI(fluidPage(
  titlePanel("Checkpoint 3"),
  
  sidebarLayout(
    sidebarPanel(width = 3,
                 helpText()),
    
    mainPanel(width = 9,
              h2("Filmes"),
              plotlyOutput("plot")
            )
    
  )
))