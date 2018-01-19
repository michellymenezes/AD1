---
layout: post
title:  Prob 4 - Checkpoint 1
date: "2018-01-18 21:36:05"
published: true
tags: [example1, example2]
---




## Análise de filmes

Para o checkpoint 1 do problema 4, nossa base de dados é referente a análise de filmes. Cada filme possui 0 ou mais caegorias, além de avaliações que variam de 1 a 5, em intervalos de 0,5.

Para todas as análises deste docuemnto, foi escolhido utilizar o cálculo de medianas, já que não queremos que, se em poucos números, valores extremos afetem o resultado final.

### Parte 1

A primeira parte é destinada para avaliar uma trilogia e idenfificar qual dos episódios há melhor avaliação e para qual há mais variação nas notas atribuídas ao filme.

A trilogia escolhida, composta de 3 filmes, foi Jurassic Park. No gráfico abaixo podemos ver como estão distribuídas as avaliações para cada filme. O eixo horizontal representa a nota atribuída e a altura que cada barra alcança no eixo vertical é referente a contagem de avaliações para uma dada nota.


{% highlight r %}
avaliacoes <- read.csv("ratings.csv")

jp_movies <- c(480, 1544, 4638)
jp_names <- c("Jurassic Park", "The Lost World: Jurassic Park", "Jurassic Park III")

jp <- subset(avaliacoes, avaliacoes$movieId == jp_movies[1] | avaliacoes$movieId == jp_movies[2] | avaliacoes$movieId == jp_movies[3])

jp["nome"] <- NA
for(i in 1:3){
  jp$nome[jp$movieId == jp_movies[i]] <- jp_names[i]
}

ggplot(jp, aes(rating)) + geom_histogram(binwidth = 0.5) + facet_grid(. ~
    nome, scales = "free", space = "free") + labs(x="Nota", y="Quantidade de avaliações")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-4-checkpoint-1/2018-01-18-prob-4-checkpoint-1/unnamed-chunk-1-1.png)

Com o objetivo de identificar o filme melhor avaliado, usaremos o processo Bootstrap. Ele consiste em permitir a inferências a partir de uma amostra, considerando intervalos e confinça. Dada uma amostra, elementos são selecionados da mesma aleatoreamente e então calcula-se a mediana. Esse processo é então repetido diversas vezes. 

Para cada filme foi aplicado o processo bootstrap e o valores obtidos das medianas são representados no gráfico abaixo. Interpretando, temos que a mediana da notas para *Jurassic Park* está no intervalo  de 3.5-4. De maneira análoga, a mediana de *Jurassic Park III* estará no intervalo 2-3 e de *The Lost Word: Jurassic Park* no intervalo 2.5-3.


{% highlight r %}
df <- data.frame()

for(i in jp_movies){
  b = bootstrap(subset(jp, movieId==i) , median(rating))
  median.jp = CI.percentile(b, probs = c(.025, .975))
  df <- data.frame(rbind(df, data.frame(median.jp)))
}

df$nome = c(jp_names[1], jp_names[2], jp_names[3])

df %>% 
  ggplot(aes(x = nome, ymin = X2.5., ymax = X97.5.)) + 
  geom_errorbar(width = .2) + labs(x="Nome do filme", y="Mediana")
{% endhighlight %}

![plot of chunk unnamed-chunk-2](/AD1/figure/source/prob-4-checkpoint-1/2018-01-18-prob-4-checkpoint-1/unnamed-chunk-2-1.png)

 Como o filme *Jurassic Park* é o que tem a maior nota em sua faixa de valores e a mesma não é compartilhada com nenhum outro filme, podemos afirma que esse filme é o que possui melhor avaliação. O mesmo não podemos afirmar para os outros dois, já que, como a faixa de valores pertencente a cada um deles possuem valores em comum, não sabemos ao certo qual o exato valor das medianas, impossibilitando uma rápida comparação visual.
 
 Por outro lado, é possível observar que o filme *Jurassic Park III* possui uma maior variação em suas notas. Tiramos essa conclusão obersevando o tamanho da linha traçada e a quantidade de valores que seu intervalo inclui. Ao subtrair seus extremos temos uma diferença de 3 - 2 = 1, enquanto os outros filmes tem ambos uma diferença de 0.5. 

### Parte 2

Na segunda parte temos o problema para avaliar relacionado a quantidade de gêneros que um filme possui. Queremos saber se filmes com uma determinada quantidade de gêneros recebem melhores avaliações.

Para isso, primero reunimos em uma tabela todos os filmes, classificando-os pela quantidade de gêneros que cada um possui. Para cada filme também é calculada a mediana de suas avaliações. Para esta análise, descartamos todos os dados que não possuem gêneros ou avaliações. Ou seja, são considerados apenas aqueles com número de gêneros >= 1 e mediana de avaliaçÕes >= 1.


{% highlight r %}
movie.genre <- read.csv("movie-genre.csv")
genre.median <- data.frame(movieId=numeric(0), n=numeric(0), mediana=numeric(0))


for(id in 1:149532){
  #se existir filme com id n
  if(nrow( subset(movie.genre, movieId == id) ) > 0){
    
    id <- as.numeric(id)
    avaliacoes1 <- subset(avaliacoes, movieId == id)
    #se esse filme possui avaliacoes
    if(nrow(avaliacoes1) > 0){
      
      # se filme possui um gênero e é no genre
      if(length(movie.genre$genre[movie.genre$movieId==id]) == 1 & movie.genre$genre[movie.genre$movieId==id]  == "(no genres listed)"){
        v.n <- 0
      }
      else{
          # n é quantidade de gêneros
          v.n <- as.numeric(sum(movie.genre$movieId == id))
      }
      # calcula mediana de avaliaçÕes do filme
      v.mediana <- median(avaliacoes1$rating)
      # adiciona na tabela
      genre.median <- rbind(genre.median, data.frame(movieId = id, n = v.n, mediana = v.mediana))
    }
  }
}

str(genre.median)
{% endhighlight %}



{% highlight text %}
## 'data.frame':	10325 obs. of  3 variables:
##  $ movieId: num  1 2 3 4 5 6 7 8 9 10 ...
##  $ n      : num  5 3 2 3 1 3 2 2 1 3 ...
##  $ mediana: num  4 3 3 3 3 4 3 4 3 3.5 ...
{% endhighlight %}

Assim como na parte 1, aplicamos o processo bootstrap nessa amostra também. Neste caso, por não conter dados suficientes, foi decidido descartar os casos em que o número de gêneros ultrapassa a quatidade 6. O resultado é um gráfico como o anterior, mas agora representando os intervalos com valores que as medianas podem assumir em cada grupo.


{% highlight r %}
df <- data.frame()

for(i in 1:6){
  b = bootstrap(subset(genre.median, n==i) , median(mediana))
  median.mv = CI.percentile(b, probs = c(.025, .975))
  df <- data.frame(rbind(df, data.frame(median.mv)))
}

df$Generos = c(1,2,3,4,5,6)

df %>% 
  ggplot(aes(x = Generos, ymin = X2.5., ymax = X97.5.)) + 
  geom_errorbar(width = .1) + labs(x="Quantidade de gêneros", y="Mediana")
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/AD1/figure/source/prob-4-checkpoint-1/2018-01-18-prob-4-checkpoint-1/unnamed-chunk-4-1.png)

A partir da análise visual e de valores do intervalos, é possível notar que alguns grupos tem comportamento igual. Os intervalos dos quatro últimos podem antingir como ponto máximo a mediana referente a 3.5. Porém, somente o grupo dos filmes de 5 gêneros possui um intervalo sem variação, chegando a conclusão que a mediana para este é sempre 3.5, enquanto para o outros ainda existe a possibilidade de assumir valores menores. Devido a esta observação, decidimos que filmes com classificados com 5 gêneros em geral recebem avaliações melhores.

Para comparar o grupo recem selecionado como o de melhores avaliações com o que receber apenas uma avaliação, presisamos fazer o bootstrap da diferença de suas respectivas medianas. Então fazemos:


{% highlight r %}
b.diff.means = bootstrap2(data = subset(genre.median, mediana == 5)$mediana, 
                          data2 = subset(genre.median, mediana == 1)$mediana, 
                          median)

means.diff = CI.percentile(b.diff.means, probs = c(.025, .975))

means.diff
{% endhighlight %}

{% highlight r %}

##                     2.5% 97.5%
## median: data-data2    4     4
{% endhighlight %}

{% highlight r %}
data.frame(means.diff) %>% 
  ggplot(aes(x = "Diferença", ymin = X2.5., ymax = X97.5.)) + 
  geom_errorbar(width = .2)
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/AD1/figure/source/prob-4-checkpoint-1/2018-01-18-prob-4-checkpoint-1/unnamed-chunk-6-1.png)

Como o grupo 5 não possuía um intervalos propriamente tido, a direferença resultante tembém é semenlhante. O valor pode ser conferido no output acima.
