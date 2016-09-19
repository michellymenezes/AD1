# server.R

# Para filmes com um determinado gênero, como eles evoluem ao longo do tempo 
# com relação a notas em avaliações?

# Para filmes com mais de um gênero, se fixarmos um gênero, quais gêneros combinados
# com o fixado rendem melhores avaliações?


library(shiny)
library(plotly)
library(readr)
library(dplyr, warn.conflicts = F)
library(Hmisc)
library(resample)


data <- read.csv("data/ratings-por-filme.csv")

l2w_genres = function(line){
  resposta = rep(line, times = 1)
  g = data.frame(genre = unlist(strsplit(as.character(line$genres), '[|]')))
  g$title = line$title
  g$year = as.numeric(substrYear(line$title))
  return(full_join(as.data.frame(line), g))
}

substrYear <- function(titulo){
  return(substr(as.character( titulo), nchar(as.character(titulo))-4, nchar(as.character(titulo)) - 1))
}

moviegenre = data %>%
  #select(title, genres) %>%
  rowwise() %>%
  do(l2w_genres(.))

genres = unique(moviegenre$genre)
moviegenre$year = as.numeric( substrYear(moviegenre$title))

moviesdates = moviegenre[!duplicated(moviegenre[,c('movieId')]),]
moviesdates$decade = NA

decades = c(1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010)

n = -90
for (i in 1:11){
  moviesdates$decade[moviesdates$year-2000 >= n] = decades[i]
  ano = ano + 10
  n = n + 10
}

moviesdates = na.omit(moviesdates)



shinyServer(function(input, output) {
  output$plot0 <- renderPlot({
    
    p = ggplot( moviesdates, aes(decade , rating)) + 
      geom_point(position = position_jitter(width = .1), alpha = .4)
    
    print(p)
  })
    
  
  
    output$plot1 <- renderPlot({
    df <- data.frame()
    
    for(i in decades){
      b = bootstrap(subset(moviesdates, decade==i) , median(rating))
      median.jp = CI.percentile(b, probs = c(.025, .975))
      df <- data.frame(rbind(df, data.frame(median.jp)))
    }
    
    
    df$decade = decades
    
    q = df %>% 
      ggplot(aes(x = decade, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 5) +
      scale_x_continuous(breaks = pretty(df$decade, n = 10)) +
      labs(x="Ano do filme", y="Mediana")
      
    
    print(q)
    
  })
  
})