---
layout: post
title:  Prob 5 - Checkpoint 3
date: "2018-01-18 22:15:17"
published: true
tags: [example1, example2]
---



Para este checkpoint continuaremos utilizando os dados de encontros relâmpagos e fazendo análise de regressão. Porém, agora estaremos tentando explicar uma variável categórica, em busca dos fatores que têm mais efeito significativo na mesma.

A variável categórica a ser explicada é "dec", ela é referente a ocorrência de match entre as duas pessoas envolvidas no encontro. Para criação do modelo, foram escolhidas como variáveis independentes algumas principais que descrevem a opinião do participante 1 sobre a pessoa com quem acabou de ter um encontro, foram elas:

* attr - nota para o quão atraente a outra pessoa foi avaliada
* sinc - nota para o quão sincera a outra pessoa foi avaliada
* fun - nota para o quão divertida a outra pessoa foi avaliada
* shar - nota para quanto interesses são compartilhado com a outra pessoa
* like - nota para o quanto a outra pessoa agradou no geral
* prob - nota para quanto se acha que a outra pessoa tem interesse em um reencontro

Inicialmente, uma breve visualização da relação e frequência entre as variáveis utilizadas. Manchas mais escuras representam uma maior ocorrência.


{% highlight r %}
dados = read.csv("speed-dating2.csv")
dados = data.frame(dados$dec, dados$attr, dados$sinc, dados$fun, dados$shar, dados$like, dados$prob)
names(dados) <- c("dec", "attr", "sinc", "fun", "shar", "like", "prob")

head(dados)
{% endhighlight %}



{% highlight text %}
##   dec attr sinc fun shar like prob
## 1 yes    6    9   7    5    7    6
## 2 yes    7    8   8    6    7    5
## 3 yes    5    8   8    7    7   NA
## 4 yes    7    6   7    8    7    6
## 5 yes    5    6   7    6    6    6
## 6  no    4    9   4    4    6    5
{% endhighlight %}



{% highlight r %}
ggplot(dados, aes(dados$dec, dados$attr)) +
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="darkred") +
    labs(title="Avaliação em atração X Match", x= "Match", y="Nota em atração")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-5-checkpoint-3/2018-01-18-prob-5-checkpoint-3/unnamed-chunk-1-1.png)

{% highlight r %}
ggplot(dados, aes(dados$dec, dados$sinc)) +
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="darkblue") +
    labs(title="Avaliação em sinceridade X Match", x= "Match", y="Nota em sinceridade")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-5-checkpoint-3/2018-01-18-prob-5-checkpoint-3/unnamed-chunk-1-2.png)

{% highlight r %}
ggplot(dados, aes(dados$dec, dados$fun)) +
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="darkorange") +
    labs(title="Avaliação em divertido(a) X Match", x= "Match", y="Nota em divertido(a)")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-5-checkpoint-3/2018-01-18-prob-5-checkpoint-3/unnamed-chunk-1-3.png)

{% highlight r %}
ggplot(dados, aes(dados$dec, dados$shar)) +
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="darkgreen") +
    labs(title="Avaliação em interesses em comum X Match", x= "Match", y="Nota em interesses em comum")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-5-checkpoint-3/2018-01-18-prob-5-checkpoint-3/unnamed-chunk-1-4.png)

{% highlight r %}
ggplot(dados, aes(dados$dec, dados$like)) +
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="#66c2a4") +
    labs(title="Avaliação em like X Match", x= "Match", y="Nota em like")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-5-checkpoint-3/2018-01-18-prob-5-checkpoint-3/unnamed-chunk-1-5.png)

{% highlight r %}
ggplot(dados, aes(dados$dec, dados$prob)) +
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="purple4") +
    labs(title="Avaliação em possibilidade de reencontro X Match", x= "Match", y="Nota em possibilidade de reencontro")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-5-checkpoint-3/2018-01-18-prob-5-checkpoint-3/unnamed-chunk-1-6.png)

Agora montamos o modelo com a variáveis independentes selecionadas com objetivo de descobrir se cada uma delas possui influência significativa e qual a "força" na variável dependente de match.


{% highlight r %}
model <- glm(dec ~ attr + sinc + fun + shar + like + prob, data=dados, family = 'binomial')
{% endhighlight %}

Como a função glm( ) atribui 0 ao primeiro level da variável categórica e 1 ao segundo level, nosso modelo estará tentado explicar a possibilidade de match ser positiva.

### 1. Que fatores nos dados têm efeito significativo na chance do casal ter um match? E como é esse efeito (positivo/negativo)?


{% highlight r %}
tidy(model, conf.int = TRUE)
{% endhighlight %}



{% highlight text %}
##          term    estimate  std.error  statistic       p.value
## 1 (Intercept) -6.60423270 0.25283240 -26.120990 2.105837e-150
## 2        attr  0.43292914 0.03046307  14.211606  7.762445e-46
## 3        sinc -0.29426748 0.03002783  -9.799826  1.127799e-22
## 4         fun  0.06752731 0.03134354   2.154425  3.120686e-02
## 5        shar  0.12450887 0.02571736   4.841434  1.289056e-06
## 6        like  0.59056972 0.04195855  14.075076  5.404711e-45
## 7        prob  0.16620984 0.02231472   7.448438  9.445195e-14
##       conf.low  conf.high
## 1 -7.107680186 -6.1163910
## 2  0.373651768  0.4931043
## 3 -0.353564392 -0.2358192
## 4  0.006106971  0.1290089
## 5  0.074188164  0.1750330
## 6  0.509104107  0.6736343
## 7  0.122592138  0.2100903
{% endhighlight %}

A partir do resumo acima, é possível concluir algumas coisas sobre as variáveis:

* Observando os intervalos de confiança de cada variável, é possível dizer que todas posssuem influência significativa já que o valor 0 não está presente em nenhum dos intervalos.
* A única que possui influência de efeito negativo é a variável **sinc**, todas a outras apresentam efeito positivo.
* Apesar de apresentar efeito significativo, esse valor referente a variável **fun** não é muito alto, apenas 0,067.

### 2. Que fatores nos dados têm mais efeito na chance de um casal ter match?

Para saber quais fatores tem mais efeito na chance de um casal ter match, geramos a tabela abaixo, que separa exatamente os valores de interesse para responder essa pergunta.


{% highlight r %}
 stargazer(model, type="text")
{% endhighlight %}



{% highlight text %}
## 
## =============================================
##                       Dependent variable:    
##                   ---------------------------
##                               dec            
## ---------------------------------------------
## attr                       0.433***          
##                             (0.030)          
##                                              
## sinc                       -0.294***         
##                             (0.030)          
##                                              
## fun                         0.068**          
##                             (0.031)          
##                                              
## shar                       0.125***          
##                             (0.026)          
##                                              
## like                       0.591***          
##                             (0.042)          
##                                              
## prob                       0.166***          
##                             (0.022)          
##                                              
## Constant                   -6.604***         
##                             (0.253)          
##                                              
## ---------------------------------------------
## Observations                 4,207           
## Log Likelihood            -1,960.045         
## Akaike Inf. Crit.          3,934.091         
## =============================================
## Note:             *p<0.1; **p<0.05; ***p<0.01
{% endhighlight %}

* Vemos que as três principais variáveis de efeito presentes no modelo são **attr**, **sinc** e **like**, pois essas apresentam valores mais próximos de -1 ou 1.
* Dentre a três principais, **like** é a variável independente que tem mais efeito na chance de um casal ter match, sendo esse efeito positivo.

