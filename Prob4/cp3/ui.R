# ui.R

library(shiny)
library(plotly)
library(shinythemes)

shinyUI(fluidPage(
  
  titlePanel("Problema 4 - Checkpoint 3"),
  theme = shinytheme("flatly"),

    navlistPanel(tabPanel("Apresentação",
                          h3("Apresentação"),
                          "Está é uma análise relacionada a filmes, juntamente com seus gêneros e avaliações de usuários. Cada filme foi avaliado por diversos usuários com notas que variam de 0.5 a 5. Além disso cada filme possui gêneros de classificação e ano de lançamento.",
                          br(), br(),
                          "O objetivo desse checkpoint é utilizar a técnica Bootstrap para o processo de reamostragem e, a partir desta, intepretar valores como variância e intervalo de confiança. Utilizamos reamostragem para inferir e tentar realizar afirmações sobre uma população a partir de uma amostra da mesma.",
                          br(), br(),
                          "Para esta análise, utilizamos o tempo dividido em décadas e os valores associados as avaliações são resultados de reamostragem das médias dos mesmos.",
                          br(), br(),
                          "Observação: esta é uma visualização com uma quantidade razoável de processamento. É muito provável que os gráficos demorem a carregar inicialmente ou logo após alterar um valor de entrada."
                          ),
                 
                 "Gêrenos ao longo de anos",

                 tabPanel("Uma análise",
                          h3("Uma análise"),
                          h4("Se resolvermos escolher um gênero para analisar como suas médias variam ao longo dos anos, qual o comportamente resultante?"),
                          br(),
                          "Para esta análise, vamos  escolher o gênero Adventure. A plotagem ao longo dos anos relacioda a este gênero pode ser observada no gráfico logo abaixo.",
                          fluidRow(plotlyOutput(outputId = "plot2")),
                          br(),
                          "Logo abaixo temos a representação do intervalo com confiança de 97.5%. A faixa tomada por cada intervalo é referente ao valor que a média de avaliações relacionadas ao gênero Adventure pode assumir para filmes lançados em cada década. Para que o processo de amostragem funcione corretamente precisamos de um número mínimo de elementos em cada amostra, então décadas com quantodades de filmes menores que 30 são desconsideradas e não incluídas na análise.",
                          br(), br(),
                          fluidRow(plotOutput(outputId = "plot3")),
                          br(),
                          "Observando os intervalos acima, podemos inferir que filmes da década de 50 possuem uma maior média de avaliação do que filmes da década de 90. E por que conseguimos interpretar desta forma? Porque não há interseção entre os intervalos de ambos e a faixa de valores dos filmes de 50's está acima dos de 90's. Isso significa que, para qualquer valor de média que os filmes dos anos 50 podem assumir, ele será sempre maior até mesmo do que o maior valor de média que filmes dos anos 90 podem assumir.",
                          br(), br(),
                          "Por outro lado não podemos afimar quando fazemos a mesma comparação para filmes de 2000 e 2010. Observando o gráfico, o máximo que podemos inferir é que existe a possibilidade de que filmes lançados em 2010 possuam uma maior média de avaliações que aqueles lançados em 2000. Isso acontece porque há inteserção de valores nos intervalos. Por mais que filmes de 2010 possam atingir maiores médias, não significa que irá ocorrer. Se filmes do anos 2000 atingirem sua possibilidade maior de média e os de 2010 de menor média, o cenário fica favorável a inferir que filmes lançados em 2000 possuem uma melhor média em avaliações que aqueles da década de 2010.",
                          br(), br(),
                          h4("Visto que temos os intervalos gerados para as médias de avaliações a cada década, será que a popularidade se comporta de maneira semelhante?"),
                          br(), br(),
                          "A popularidade de um filme é referente a quantidade de avaliações que o mesmo obteve. Aqui estaremos observando o quão popular filmes de um determinado gênero são em cada década.",
                          fluidRow(plotOutput(outputId = "plot0"))
                          ),
                 
                 tabPanel("Sua vez", h3("Sua vez"),
                          br(),
                          "Baseando-se na abordagem feita para a análise anterior, escolha um gênero, observe o gráfico gerado e tente fazer inferências a partir da análise dos intervalos gerados.",
                          selectInput("selectGenre0", label = h4("Escolha um gênero:"), 
                                      choices = list("Adventure", "Animation", "Children", "Comedy", "Fantasy", "Romance", "Drama", "Action", "Crime", "Thriller",
                                                     "Horror", "Mystery", "Sci-Fi", "War", "Musical", "Documentary", "IMAX", "Western", "Film-Noir"), 
                                      selected = "Adventure"),
                          fluidRow(plotlyOutput(outputId = "plot4")),
                          fluidRow(plotOutput(outputId = "plot5"))
                          ),
                 
                 "Gênero + Gêneros",
                 
                 tabPanel("Uma análise",
                          h3("Uma análise"),
                          h4("Se agora selecionamos um gênero, qual outro gênero combinado a ele possui melhores médias em avaliação?"),
                          br(),
                          "Desejamos escolher filmes que possuem uma combinação de gêneros em sua classificação e verificar o quão boas são essas combinações com base na média de avaliações de cada uma.
                          Assim como na anterior, ara esta análise escolhemos o gênero Adventure. Abaixo podemos observar os intervalos gerados e divididos por gênero.",
                          fluidRow(plotOutput(outputId = "plot7"))),
                 
                 tabPanel("Sua vez", h3("Sua vez"),
                          selectInput("selectGenre1", label = h4("Escolha um gênero:"), 
                                      choices = list("Adventure", "Animation", "Children", "Comedy", "Fantasy", "Romance", "Drama", "Action", "Crime", "Thriller",
                                                     "Horror", "Mystery", "Sci-Fi", "War", "Musical", "Documentary", "IMAX", "Western", "Film-Noir"), 
                                      selected = "Adventure"),
                           fluidRow(plotOutput(outputId = "plot6"))
                          
                          )
    )
))
