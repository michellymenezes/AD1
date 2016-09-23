# ui.R

# Para filmes com um determinado gênero, como eles evoluem ao longo do tempo 
# com relação a notas em avaliações?

# Para filmes com mais de um gênero, se fixarmos um gênero, quais gêneros combinados
# com o fixado rendem melhores avaliações?


library(shiny)
library(plotly)


shinyUI(fluidPage(
  
  titlePanel("Checkpoint 3"),
  

    navlistPanel(tabPanel("Apresentação",
                          h3("Apresentação"),
                          "Está é uma análise relacionada a filmes, juntamente com seus gêneros e avaliações de usuários."),
                 "Gêrenos ao longo de anos",
                 tabPanel("Geral",
                          h3("Geral"),
                          h4("Como filmes evoluem ao longo do tempo com relação a notas em avaliações?"),
                          fluidRow(plotlyOutput(outputId = "plot0")),
                          fluidRow(plotOutput(outputId = "plot1"))
                          ),
                 tabPanel("Uma análise",
                          h3("Uma análise"),
                          h4("Se resolvermos escolher um gênero para analisar a mesma evolução, qual o comportamente resultante? Existe diferença para a abordagem com todos s gêneros?"),
                          fluidRow(plotlyOutput(outputId = "plot2")),
                          fluidRow(plotOutput(outputId = "plot3"))
                          ),
                 tabPanel("Sua vez",
                          selectInput("selectGenre0", label = h3("Escolha um gênero:"), 
                                      choices = list("Adventure", "Animation", "Children", "Comedy", "Fantasy", "Romance", "Drama", "Action", "Crime", "Thriller",
                                                     "Horror", "Mystery", "Sci-Fi", "War", "Musical", "Documentary", "IMAX", "Western", "Film-Noir"), 
                                      selected = "Adventure"),
                          fluidRow(plotlyOutput(outputId = "plot4")),
                          fluidRow(plotOutput(outputId = "plot5"))
                          ),
                 "Gênero + Gêneros",
                 tabPanel("Geral"),
                 tabPanel("Uma análise"),
                 tabPanel("Sua vez")
    )
))
