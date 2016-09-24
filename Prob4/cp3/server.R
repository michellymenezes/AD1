# server.R

library(shiny)
library(plotly)
library(readr)
library(dplyr, warn.conflicts = F)
library(Hmisc)
library(resample)
library(stringr)

data <- read.csv("data/complete_data.csv")

# l2w_genres = function(line){
#   resposta = rep(line, times = 1)
#   g = data.frame(genre = unlist(strsplit(as.character(line$genres), '[|]')))
#   g$title = line$title
#   g$year = as.numeric(substrYear(line$title))
#   return(full_join(as.data.frame(line), g))
# }

# substrYear <- function(titulo){
#   return(substr(as.character( titulo), nchar(as.character(titulo))-4, nchar(as.character(titulo)) - 1))
# }

# moviegenre = data %>%
#   #select(title, genres) %>%
#   rowwise() %>%
#   do(l2w_genres(.))

moviegenre = read.csv("data/movie_genres.csv")

genres = unique(moviegenre$genre)

decades = c(1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010)

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
    b = bootstrap(subset(adventure, decade==i) , mean(rating))
    median.adventure = CI.percentile(b, probs = c(.025, .975))
    adventure.df <- data.frame(rbind(adventure.df, data.frame(median.adventure)))
    vector <- c(vector, i)
  }
}
adventure.df$decade = vector

popAdventure.df <- data.frame()
popVector <- c()
for(i in decades){
  if(nrow(subset(adventure, decade == i)) >= 30){
    b = bootstrap(subset(adventure, decade==i) , mean(popularity))
    median.adventure = CI.percentile(b, probs = c(.025, .975))
    popAdventure.df <- data.frame(rbind(popAdventure.df, data.frame(median.adventure)))
    popVector <- c(popVector, i)
  }
}
popAdventure.df$decade = popVector

##########################################
shinyServer(function(input, output) {

    output$plot2 <- renderPlotly({

      r = ggplot( adventure, aes(year , rating, text = paste("Título:", title,"<br>Gênero: Adventure"))) +
        scale_x_continuous(breaks = pretty(adventure$decade, n = 10)) +
        geom_point(position = position_jitter(width = .1), alpha = .4, color="dodgerblue4") +
        labs(title="Média de avaliações para filmes 'Adventure' ao longo dos anos", x= "Ano", y="Média de avaliação")

      (gg <- ggplotly(r))
    })
########################
    output$plot3 <- renderPlot({

      s = adventure.df %>%
        ggplot(aes(x = decade, ymin = X2.5., ymax = X97.5.)) +
        geom_errorbar(width = 5) +
        scale_x_continuous(breaks = pretty(adventure.df$decade, n = 10)) +
        labs(title="Intervalos de confiança para avaliação ao longo das décadas", x="Década do filme", y="Média")

      print(s)
    })
    
    ########################
    output$plot0 <- renderPlot({
      
      pop = popAdventure.df %>%
        ggplot(aes(x = decade, ymin = X2.5., ymax = X97.5.)) +
        geom_errorbar(width = 5) +
        scale_x_continuous(breaks = pretty(popAdventure.df$decade, n = 10)) +
        labs(title="Intervalos de confiança para popularidade ao longo das décadas", x="Década do filme", y="Popularidade")
      
      print(pop)
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
    
    p4 <- ggplot( genreN, aes(year , rating, text = paste("Título:", title,"<br>Gênero: ", input$selectGenre0))) +
      scale_x_continuous(breaks = pretty(genreN$decade, n = 10)) +
      geom_point(position = position_jitter(width = .1), alpha = .4, color="dodgerblue4") +
      labs(title="Média de avaliações para filmes ao longo dos anos", x= "Ano", y="Média de avaliação")
    
    (gg <- ggplotly(p4))
  })
  #####################################
  output$plot5 <- renderPlot({
    
    genreN = subset(moviegenre, moviegenre$genre == input$selectGenre0)
    genreN$decade = NA
    n = -90
    for (i in 1:11){
      genreN$decade[genreN$year-2000 >= n] = decades[i]
      n = n + 10
    }
    genreN = na.omit(genreN)

    genreN.df <- data.frame()
    vectorN <- c()
    for(i in decades){
      if(nrow(subset(genreN, decade == i)) >= 30){
        b = bootstrap(subset(genreN, decade==i) , mean(rating))
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
      labs(title="Intervalos de confiança para avaliação ao longo das décadas", x="Década do filme", y="Média")
    
    print(outputN)
  })
  
  #############################################
  
  output$plot8 <- renderPlot({
    
    genrePopN = subset(moviegenre, moviegenre$genre == input$selectGenre0)
    genrePopN$decade = NA
    n = -90
    for (i in 1:11){
      genrePopN$decade[genrePopN$year-2000 >= n] = decades[i]
      n = n + 10
    }
    genrePopN = na.omit(genrePopN)
    
    genrePopN.df <- data.frame()
    vectorN <- c()
    for(i in decades){
      if(nrow(subset(genrePopN, decade == i)) >= 30){
        b = bootstrap(subset(genrePopN, decade==i) , mean(popularity))
        median.genreN = CI.percentile(b, probs = c(.025, .975))
        genrePopN.df <- data.frame(rbind(genrePopN.df, data.frame(median.genreN)))
        vectorN <- c(vectorN, i)
      }
    }
    genrePopN.df$decade = vectorN
    
    outputN = genrePopN.df %>%
      ggplot(aes(x = decade, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 5) +
      scale_x_continuous(breaks = pretty(genrePopN.df$decade, n = 10)) +
      labs(title="Intervalos de confiança para popularidade ao longo das décadas", x="Década do filme", y="Média")
    
    print(outputN)
  })
  
  ###########################################
  combGenres <- subset(data, data$nGenres > 1)

  output$plot6 <- renderPlot({
    
    combG = subset(combGenres, grepl(input$selectGenre1, combGenres$genres))

    combG.df <- data.frame()
    vectorCombG <- c()
    for(i in genres){
      if(nrow(subset(combG, grepl(i, combG$genres))) >= 30 & i != input$selectGenre1){
        b = bootstrap(subset(combG, grepl(i, combG$genres)) , mean(rating))
        median.combG = CI.percentile(b, probs = c(.025, .975))
        combG.df <- data.frame(rbind(combG.df, data.frame(median.combG)))
        vectorCombG <- c(vectorCombG, i)
      }
    }
    combG.df$gender = vectorCombG
    
    outputGenderN = combG.df %>%
      ggplot(aes(x = gender, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 0.5) +
      labs(title="Intervalos de confiança para avaliação por combinação de gêneros", x="Gênero", y="Média")
    
    print(outputGenderN)
  })
 
  ###########################################################
   
  output$plot7 <- renderPlot({
    
    advG = subset(combGenres, grepl("Adventure", combGenres$genres))

    advG.df <- data.frame()
    vectorAdvG <- c()
    for(i in genres){
      if(nrow(subset(advG, grepl(i, advG$genres))) >= 30 & i != "Adventure"){
        b = bootstrap(subset(advG, grepl(i, advG$genres)) , mean(rating))
        median.AdvG = CI.percentile(b, probs = c(.025, .975))
        advG.df <- data.frame(rbind(advG.df, data.frame(median.AdvG)))
        vectorAdvG <- c(vectorAdvG, i)
      }
    }
    advG.df$gender = vectorAdvG
    
    outputAdvG = advG.df %>%
      ggplot(aes(x = gender, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 0.5) +
      labs(title="Intervalos de confiança para avaliação por combinação de gêneros", x="Gênero", y="Média")
    
    print(outputAdvG)
  })

  #######################################################
    
  output$plot9 <- renderPlot({
    
    advC = subset(data, grepl("Adventure", combGenres$genres))
    
    advC.df <- data.frame()
    vectorAdvG <- c()
    for(i in 1:6){
      if(nrow(subset(advC, advC$nGenres == i )) >= 30){
        b = bootstrap(subset(advC, advC$nGenres == i) , mean(rating))
        median.AdvG = CI.percentile(b, probs = c(.025, .975))
        advC.df <- data.frame(rbind(advC.df, data.frame(median.AdvG)))
        vectorAdvG <- c(vectorAdvG, i)
      }
    }
    advC.df$nGenres = vectorAdvG
    
    outputAdvC = advC.df %>%
      ggplot(aes(x = nGenres, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 0.5) +
      labs(title="Intervalos de confiança para avaliação por quantidade de gêneros", x="Quantidade de gêneros", y="Média")
    
    print(outputAdvC)
  })
  
  #####################################################
  
  output$plot10 <- renderPlot({
    
    advCI = subset(data, grepl(input$selectGenre1, combGenres$genres))
    
    advCI.df <- data.frame()
    vectorAdvG <- c()
    for(i in 1:6){
      if(nrow(subset(advCI, advCI$nGenres == i )) >= 30){
        b = bootstrap(subset(advCI, advCI$nGenres == i) , mean(rating))
        median.AdvG = CI.percentile(b, probs = c(.025, .975))
        advCI.df <- data.frame(rbind(advCI.df, data.frame(median.AdvG)))
        vectorAdvG <- c(vectorAdvG, i)
      }
    }
    advCI.df$nGenres = vectorAdvG
    
    outputAdvCI = advCI.df %>%
      ggplot(aes(x = nGenres, ymin = X2.5., ymax = X97.5.)) +
      geom_errorbar(width = 0.5) +
      labs(title="Intervalos de confiança para avaliação por quantidade de gêneros", x="Quantidade de gêneros", y="Média")
    
    print(outputAdvCI)
  })
  
})