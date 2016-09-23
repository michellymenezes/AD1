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
library(stringr)

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
data$year = as.numeric( substrYear(data$title))

decades = c(1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010)

moviegenre$decade = NA
data$decade = NA


moviesdates = moviegenre[!duplicated(moviegenre[,c('movieId')]),]
n = -90
for (i in 1:11){
  moviesdates$decade[moviesdates$year-2000 >= n] = decades[i]
  moviegenre$decade[moviegenre$year-2000 >= n] = decades[i]
  data$decade[data$year-2000 >= n] = decades[i]
  
  
  n = n + 10
}
moviesdates = na.omit(moviesdates)
moviegenre = na.omit(moviegenre)
data = na.omit(data)



geral.df <- data.frame()
for(i in decades){
  b = bootstrap(subset(moviesdates, decade==i) , median(rating))
  median.geral = CI.percentile(b, probs = c(.025, .975))
  geral.df <- data.frame(rbind(geral.df, data.frame(median.geral)))
}
geral.df$decade = decades


adventure = subset(moviegenre, moviegenre$genre == "Adventure")
adventure$decade = NA
n = -90
for (i in 1:11){
  adventure$decade[adventure$year-2000 >= n] = decades[i]
  n = n + 10
}
adventure = na.omit(adventure)


adventure.df <- data.frame()
vector <- c()
for(i in decades){
  if(nrow(subset(adventure, decade == i)) >= 30){
    b = bootstrap(subset(adventure, decade==i) , median(rating))
    median.adventure = CI.percentile(b, probs = c(.025, .975))
    adventure.df <- data.frame(rbind(adventure.df, data.frame(median.adventure)))
    vector <- c(vector, i)
  }
}
adventure.df$decade = vector

##########################################
shinyServer(function(input, output) {
  output$plot0 <- renderPlotly({
    
    p = ggplot( moviesdates, aes(year , rating)) + 
      scale_x_continuous(breaks = pretty(geral.df$decade, n = 10)) +
      geom_point(position = position_jitter(width = .1), alpha = .4)
    
    (gg <- ggplotly(p))
  })
    
  #############################################

    output$plot1 <- renderPlot({
     q = geral.df %>% 
      ggplot(aes(x = decade, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 5) +
      scale_x_continuous(breaks = pretty(geral.df$decade, n = 10)) +
      labs(x="Ano do filme", y="Mediana")

    print(q)
    
  })

##########################
    output$plot2 <- renderPlotly({

      r = ggplot( adventure, aes(year , rating)) +
        scale_x_continuous(breaks = pretty(adventure$decade, n = 10)) +
        geom_point(position = position_jitter(width = .1), alpha = .4)

      (gg <- ggplotly(r))
    })
########################
    output$plot3 <- renderPlot({

      s = adventure.df %>%
        ggplot(aes(x = decade, ymin = X2.5., ymax = X97.5.)) +
        geom_errorbar(width = 5) +
        scale_x_continuous(breaks = pretty(adventure.df$decade, n = 10)) +
        labs(x="Ano do filme", y="Mediana")

      print(s)
    })
#######################################    
  output$plot4 <- renderPlotly({
    
    genreN = subset(moviegenre, moviegenre$genre == input$selectGenre0)
    genreN$decade = NA
    n = -90
    for (i in 1:11){
      genreN$decade[genreN$year-2000 >= n] = decades[i]
      n = n + 10
    }
    genreN = na.omit(genreN)
    
    p4 <- ggplot( genreN, aes(year , rating)) +
      scale_x_continuous(breaks = pretty(genreN$decade, n = 10)) +
      geom_point(position = position_jitter(width = .1), alpha = .4)
    (gg <- ggplotly(p4))
  })
  #####################################
  output$plot5 <- renderPlot({
    
    genreUp = input$selectGenre0
    
    genreN.df <- data.frame()
    vectorN <- c()
    for(i in decades){
      if(nrow(subset(genreN, decade == i)) >= 30){
        b = bootstrap(subset(genreN, decade==i) , median(rating))
        median.genreN = CI.percentile(b, probs = c(.025, .975))
        genreN.df <- data.frame(rbind(genreN.df, data.frame(median.genreN)))
        vectorN <- c(vectorN, i)
      }
    }
    genreN.df$decade = vectorN
    
    outputN = genreN.df %>%
      ggplot(aes(x = decade, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 5) +
      scale_x_continuous(breaks = pretty(genreN.df$decade, n = 10)) +
      labs(x="Ano do filme", y="Mediana")
    
    print(outputN)
  })
  
  ###########################################
  combGenres <- subset(data, str_count(data$genres, "[|]") > 0)
  
  output$plot6 <- renderPlot({
    
    combG = subset(combGenres, grepl(input$selectGenre1, combGenres$genres))
    #combG2 = subset(combG, grepl(input$selectGenre2, combG$genres))
    
    combG.df <- data.frame()
    vectorCombG <- c()
    for(i in genres){
      if(nrow(subset(combG, grepl(i, combG$genres))) >= 30){
        b = bootstrap(subset(combG, grepl(i, combG$genres)) , median(rating))
        median.combG = CI.percentile(b, probs = c(.025, .975))
        combG.df <- data.frame(rbind(combG.df, data.frame(median.combG)))
        vectorCombG <- c(vectorCombG, i)
      }
    }
    combG.df$Gender = vectorCombG
    
    outputGenderN = combG.df %>%
      ggplot(aes(x = Gender, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 0.5) +
      labs(x="Gênero", y="Mediana")
    
    print(outputGenderN)
  })
  
  
})