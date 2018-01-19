---
layout: post
title:  Prob 5 - Checkpoint 2
date: "2018-01-18 22:12:40"
published: true
tags: [example1, example2]
---



Neste checkpoint serão respondidas duas perguntas a partir de análise de regressão. A análise será feita com objetivo de mostrar se uma váriável, por exemplo, tem ou não influência significativa no valor de outra.

Para esta análise, estaremos usando dados com 5000 linhas relacionados a encontros relâmpagos de 4 minutos e que envolveram um total de 310 americanos. Os dados originais foram coletados por professores da Columbia Business School, a versão aqui utlizada possui apenas as colunas de interesse para o modelo a ser utilizado na análise. 

Em resumo, os participantes tinham vários encontros de 4 minutos e após cada um deles, uma ficha era preenchida avaliando aqueles com quem se encontraram. Cada linha nos dados representa um desses encontros.


{% highlight r %}
data = read.csv("speed-dating.csv")
data = data.frame(data$gender, data$attr, data$shar, data$like, data$prob)
names(data) <- c("gender", "attr", "shar", "like", "prob")

head(data)
{% endhighlight %}



{% highlight text %}
##   gender attr shar like prob
## 1      0    6    5    7    6
## 2      0    7    6    7    5
## 3      0    5    7    7   NA
## 4      0    7    8    7    6
## 5      0    5    6    6    6
## 6      0    4    4    6    5
{% endhighlight %}

## Notas em Likes x Notas em Atração

Dentre as categorias a serem preenchidas na fichas duas delas são nota em Like e nota em atração. A primeira é referente a quanto a pessoa gostou (no geral) do candidato com quem acabou de se ter um encontro, podendo esta nota variar de 0 a 10. A segunda é referente ao quão atraente o candidato será avaliado, podendo também variar de 0 a 10.

A partir dessas duas variáveis, **queremos saber se a nota atribuída para atração tem influência significativa na nota atribuída para o "Like" e se há diferença quando analisamos para quando homens e mulheres atribuem essas notas separadamente**.

Para isso, separamos um dataframe para cada gênero em que pessoas do sexo feminino são identificadas por 0 e pessoas do sexo masculino são ideintificadas por 1.


{% highlight r %}
womenLike = subset(data, data$gender == 0)
menLike = subset(data, data$gender == 1)
{% endhighlight %}

Após isso, podemos ter uma visão geral de como essas duas variáveis se comportam juntas para cada grupo. É possível identificar manchas mais escuras no gráfico, elas representam áreas em que a ocorrênncia é mais frequente. Dados incompletos são desconsiderados para o modelo.


{% highlight r %}
ggplot(data, aes(data$attr, data$like)) +
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="purple4") +
  labs(title="Avaliações por pessoas após um encontro", x= "Nota em atração", y="Nota em Like") +
  facet_grid(gender ~ ., scales = "free", space = "free")
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-3-1.png)

Podemos agora definir um modelo de regressão linear para cada grupo de maneira que seja possível descobrir a quantidade de influência que a nota de atração exerce sobre a nota de like. Podemos então traçar uma linha de regressão em ambos os gráficos com objetivo de de obter os valores previstos através do modelo.


{% highlight r %}
dataLikeMod = lm(like ~ attr, data = data)

ggplot(data, aes(data$attr, data$like)) +  
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="purple4") + 
  labs(title="Previsão do modelo", x= "Nota em atração", y="Nota em Like") +  
  geom_line(aes(y = predict(dataLikeMod, data)), colour = "red") +
  facet_grid(gender ~ ., scales = "free", space = "free")
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-4-1.png)

{% highlight r %}
womenLikeMod = lm(like ~ attr, data = womenLike)
menLikeMod = lm(like ~ attr, data = menLike)
{% endhighlight %}

Tendo computado os valores previsto, é possível agora visualizar os resíduos do modelo. Em um bom modelo, resíduos não apresentam tedências, eles geralmente estão dispostos de maneira aleatória, sugerindo uma boa captura por parte do modelo.


{% highlight r %}
ggplot(womenLikeMod, aes(attr, .resid)) + 
  labs(title="Resíduos do modelo para grupo do sexo feminino", x= "Nota em atração", y="Resíduos") +
  geom_point(alpha = 0.1, color="springgreen4") +
  geom_hline(yintercept = 0, colour = "blue")
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-5-1.png)

{% highlight r %}
ggplot(menLikeMod, aes(attr, .resid)) +
   labs(title="Resíduos do modelo para grupo do sexo masculino", x= "Nota em atração", y="Resíduos") + 
  geom_point(alpha = 0.1, color="springgreen4") + 
  geom_hline(yintercept = 0, colour = "blue")
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-5-2.png)

Nos exemplos acima, não fica muito claro onde está posicionada a maioria do resíduos. Logo esbaixo está um gráfico que apresenta a frequência em cada um dos grupos. É possível identificar que para o grupo do sexo feminino a maioria dos resíduos estão em torno de 0, com valores entre -1 e 1. Para o grupo do sexo masculino, reparamos que a concentração de resíduos é maior no valor 0 quando comparado com o outro grupo, mas que valores que se aproximam de 0 ainda apresentam maior frequência.


{% highlight r %}
ggplot(womenLikeMod, aes(.resid)) + labs(title="Frequência de resíduos para grupo do sexo feminino", x= "Resíduo", y="Frequência") + 
  geom_freqpoly(binwidth = 0.5, color="springgreen4") 
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-6-1.png)

{% highlight r %}
ggplot(menLikeMod, aes(.resid)) + labs(title="Frequência de resíduos para grupo do sexo masculino", x= "Resíduo", y="Frequência") + 
  geom_freqpoly(binwidth = 0.5, color="springgreen4") 
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-6-2.png)

Agora que temos uma ideia visual de como se comporta o modelo e seus resíduos, vamos recuperar dados referentes ao modelo de cada grupo.

Primeiro para o grupo do sexo feminino. Avaliando os dados de intervalo de confiança (conf.low e conf.high) vemos que o intervalo desses valores não incluem o valor 0, podendo concluir que a variável "attr" possui influência significativa no valor de Like (a mesma informação podemos concluir a partir do p-valor, por ser suficientemente pequeno). Com magnitude apresentada de 0.65744, esse valor representa a força de correlação (quanto mais próximo do valor -1 ou 1, melhor), mostrando que há uma correlação positiva. O valor de R-quadrado é referente ao quanto o modelo formulado explica a variável em questão, podemos dizer então que esse modelo, para pessoas do sexo feminino, explica cerca de 46.4% do valor da variável like.


{% highlight r %}
tidy(womenLikeMod, conf.int = TRUE)
{% endhighlight %}



{% highlight text %}
##          term  estimate  std.error statistic       p.value  conf.low
## 1 (Intercept) 2.0635940 0.08864880  23.27831 3.444874e-108 1.8897574
## 2        attr 0.6574372 0.01446505  45.45004  0.000000e+00 0.6290718
##   conf.high
## 1 2.2374306
## 2 0.6858025
{% endhighlight %}



{% highlight r %}
summary(womenLikeMod)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = like ~ attr, data = womenLike)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -6.0082 -0.6933 -0.0082  0.9641  5.9641 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  2.06359    0.08865   23.28   <2e-16 ***
## attr         0.65744    0.01447   45.45   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.411 on 2387 degrees of freedom
##   (65 observations deleted due to missingness)
## Multiple R-squared:  0.4639,	Adjusted R-squared:  0.4637 
## F-statistic:  2066 on 1 and 2387 DF,  p-value: < 2.2e-16
{% endhighlight %}

Nos voltamos agora para o grupo do sexo masculino. O intervalo de confiança também não inclui o valor 0, mostrando que a variável "attr" possui influência significativa no valor de Like (o p-valor, por ser suficientemente pequeno, também indica isso). Com magnitude apresentada de 0.6145953, o coeficiente apresenta correlação positiva. O valor de R-quadrado nos permite concluir que esse modelo, para pessoas do sexo masculino, explica cerca de 42.5% do valor da variável like.


{% highlight r %}
tidy(menLikeMod, conf.int = TRUE)
{% endhighlight %}



{% highlight text %}
##          term  estimate  std.error statistic       p.value  conf.low
## 1 (Intercept) 2.3355204 0.09656083  24.18704 8.166189e-116 2.1461690
## 2        attr 0.6145953 0.01461986  42.03839 1.003904e-289 0.5859264
##   conf.high
## 1 2.5248719
## 2 0.6432642
{% endhighlight %}



{% highlight r %}
summary(menLikeMod)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = like ~ attr, data = menLike)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -7.4815 -0.6377 -0.0231  0.8207  6.0499 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  2.33552    0.09656   24.19   <2e-16 ***
## attr         0.61460    0.01462   42.04   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.333 on 2394 degrees of freedom
##   (68 observations deleted due to missingness)
## Multiple R-squared:  0.4247,	Adjusted R-squared:  0.4244 
## F-statistic:  1767 on 1 and 2394 DF,  p-value: < 2.2e-16
{% endhighlight %}

Apesar de bastante semelhantes, fazendo uma comparação geral entre os dois grupos afirmamos que, a partir do modelo, para pessoas do sexo feminino, a avaliação para atração explica mais a nota em like se comparada com o segundo grupo.

## Notas em Probabilidade de novo encontro x Notas em interesses em comum

Agora temos voltamos o interesse para duas outras variáveis: prob e shar. A primeria é uma nota que o participante dá, referente a sua opinião sobre a probabilidade que a pessoa com quem acabou de se encontrar tem de querer repetir o encontro no futuro. A segunda variável é uma nota referente a quanto o participante acha que ele e a pessoa com quem acabou de se encontrar compartilham interesses e hobbies. Ambas variáveis variam de 1 a 10.

**Queremos desenvolver um modelo para saber se a nota atribuída a compartilhamento de interesses tem influência significativa na nota atribuída para o probabilidade de reencontro**.

Antes, uma breve visualização de como essas duas variáveis se comportam juntas. Assim como no exemplo anterior, áreas com valores de maior frequência são identficadas por manchas mais escuras e dados incompletos são desconsiderados.


{% highlight r %}
ggplot(data, aes(data$shar, data$prob)) +
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="indianred3") +
  labs(title="Avaliações em possibilidade e compatilhamento após um encontro", x= "Nota em interesses compartilhados", y="Nota em probabilidade de reencontro")
{% endhighlight %}

![plot of chunk unnamed-chunk-9](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-9-1.png)

Abaixo definimos um modelo de regressão linear afim de descobrir a quantidade de influência que a nota de compartilhamento de interesses exerce sobre a nota de possibilidade de reencontro. Traçamos uma linha de regressão no gráfico anterior com objetivo de de obter os valores previstos através do modelo.


{% highlight r %}
dataProbMod = lm(prob ~ shar, data = data)

ggplot(data, aes(data$shar, data$prob)) +  
  geom_point(alpha = 0.1, position = position_jitter(width = 0.3), color="indianred3") + 
  labs(title="Previsão do modelo", x= "Nota em interesses compartilhados", y="Nota em probabilidade de reencontro") +  
  geom_line(aes(y = predict(dataProbMod, data)), colour = "red")
{% endhighlight %}

![plot of chunk unnamed-chunk-10](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-10-1.png)

Abaixo possível agora visualizar os resíduos do modelo e, assim como no exemplo anterior, plotamos também um gráfico com a frequência desses resíduos. Não é apresentada visualmente nenhuma tendência significantemente maior para um dos lados qunado comparados. Identificamos que é no valor 0 que há uma maior frequência de resíduos. Além disso, a forma visualizada na frequência lembra uma distribuição normal, o que é considerado um bom indicativo em análise de resíduos.


{% highlight r %}
ggplot(dataProbMod, aes(shar, .resid)) + 
  labs(title="Resíduos do modelo", x= "Nota em interesses compartilhados", y="Resíduos") +
  geom_point(alpha = 0.1, color="darkcyan") +
  geom_hline(yintercept = 0, colour = "blue")
{% endhighlight %}

![plot of chunk unnamed-chunk-11](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-11-1.png)

{% highlight r %}
ggplot(dataProbMod, aes(.resid)) + labs(title="Frequência de resíduos", x= "Resíduo", y="Frequência") + 
  geom_freqpoly(binwidth = 0.5, color="darkcyan") 
{% endhighlight %}

![plot of chunk unnamed-chunk-11](/AD1/figure/source/prob-5-checkpoint-2/2018-01-18-prob-5-checkpoint-2/unnamed-chunk-11-2.png)

Assim como no modelo anterior, faremos a mesma interpretação para outros dados pertencentes ao modelo.

Sobre o intervalo de confiança, este é definido por 0.4386388:0.4923304 e não inclui o valor 0, concluímos que a variável "shar" possui influência significativa no valor de prob (o p-valor por ser suficientemente pequeno também confirma essa conclusão). Com valor de magnitude igual a 0.46548, dizemos que há alguma correlação a respeito da variável independente e que a mesma é positiva, pois seu valor é maior que 0. O valor de R-quadrado referente indica que o modelo formulado explica em 21.39% a variável em questão (probabilidade de reencontro).


{% highlight r %}
tidy(dataProbMod, conf.int = TRUE)
{% endhighlight %}



{% highlight text %}
##          term  estimate  std.error statistic       p.value  conf.low
## 1 (Intercept) 2.5604555 0.07864929  32.55536 9.413429e-208 2.4062618
## 2        shar 0.4654846 0.01369320  33.99387 2.951897e-224 0.4386388
##   conf.high
## 1 2.7146492
## 2 0.4923304
{% endhighlight %}



{% highlight r %}
summary(dataProbMod)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = prob ~ shar, data = data)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -6.2843 -1.2843  0.1121  1.1812  6.9741 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  2.56046    0.07865   32.55   <2e-16 ***
## shar         0.46548    0.01369   33.99   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.928 on 4248 degrees of freedom
##   (668 observations deleted due to missingness)
## Multiple R-squared:  0.2139,	Adjusted R-squared:  0.2137 
## F-statistic:  1156 on 1 and 4248 DF,  p-value: < 2.2e-16
{% endhighlight %}
