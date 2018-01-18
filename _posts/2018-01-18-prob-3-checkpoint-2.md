---
layout: post
title:  Prob 3 - Checkpoint 2
date: "2018-01-18 19:40:52"
published: true
tags: [example1, example2]
---

## Redução de  dimensionalidade

Para este problema, foram escolhidas 4 variáveis, tornando os dados uma estrutura de 4 dimensões. As variáveis escolhidas foram relacionadas a categorias que parlamentares escolhem investir com emendas, sendo elas: saneamento, saúde, gestão ambiental e urbanismo. Essas categorias ocorrem ao mesmo tempo para um determinado parlamentar.

Aos dados foi aplicada a função log com objetivos distribuir melhor os valores e melhorar a visualização, já que os dados estavam um pouco enviezados a esquerda. 



### PCA

Aplicando a abordagem PCA, podemos ver abaixo os valores de correlação a cada componente. No gráfico mais abaixo, as quatro dimensões foram reduziadas a duas. É possível observar a representação do autovetor de cada categoria e sua nova distrubuição de pontos, em que o objetivo é capturar o maior espalhamento possível nas duas dimensões.


{% highlight r %}
emendas.pca <- prcomp(select(emendas.cp22, -emendas.NOME_PARLAMENTAR, -Estado, -Regiao) , center = TRUE, scale. = TRUE)

print(emendas.pca)
{% endhighlight %}



{% highlight text %}
## Standard deviations:
## [1] 1.3912932 1.1235846 0.8410541 0.3073905
## 
## Rotation:
##                                PC1        PC2         PC3        PC4
## emendas.Saneamento       0.5300252 -0.5733851  0.08354775 -0.6191305
## emendas.Saúde            0.3305420  0.5499521  0.75687919 -0.1242116
## emendas.Urbanismo        0.6911535 -0.1347162 -0.08833320  0.7045251
## emendas.Gestão.Ambiental 0.3634861  0.5921433 -0.64214555 -0.3238722
{% endhighlight %}



{% highlight r %}
autoplot(emendas.pca, color="Estado", size = 3, data = emendas.cp22, label = F, loadings = TRUE, loadings.colour = 'blue', loadings.label = TRUE, loadings.label.size = 3)
{% endhighlight %}

![plot of chunk unnamed-chunk-2](/AD1figure/source/prob-3-checkpoint-2/2018-01-18-prob-3-checkpoint-2/unnamed-chunk-2-1.png)

Abaixo está um segundo gráfico que mostra quanto cada componente possui da variância total. Podemos concluir deste gráfico que os dois primeiros componentes são responsáveis por cerca de 80% da variância total, sendo assim, são os dois componentes escolhidos para representar o novo plano de duas dimensões, já que oferecem um maior espalhamento.


{% highlight r %}
 plot_pve <- function(prout){
   pr.var <- emendas.pca$sdev^2
   pve <- pr.var / sum(pr.var)
   df = data.frame(x = 1:NROW(pve), y = cumsum(pve))
   ggplot(df, aes(x = x, y = y)) + 
     geom_point(size = 3) + 
     geom_line() + 
     labs(x='Principal Component', y = 'Cumuative Proportion of Variance Explained')
}
 
 plot_pve(emendas.pca)
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/AD1figure/source/prob-3-checkpoint-2/2018-01-18-prob-3-checkpoint-2/unnamed-chunk-3-1.png)

### t-SNE

A seguir, para as mesmas variáveis e dimensão, aplicaremos a segunda abordagem, t-SNE. É possível observar no gráfico gerado que alguns pontos se aproximam mais que outros, formando espécies de grupos. Devido a essa característica, escolherei o resultado dessa abordagem para interpretação.





{% highlight r %}
emendas.tsne = Rtsne(select(cp, -emendas.NOME_PARLAMENTAR, -Estado, -Regiao), verbose = TRUE, perplexity = 10)
{% endhighlight %}



{% highlight text %}
## Read the 40 x 4 data matrix successfully!
## Using no_dims = 2, perplexity = 10.000000, and theta = 0.500000
## Computing input similarities...
## Normalizing input...
## Building tree...
##  - point 0 of 40
## Done in 0.00 seconds (sparsity = 0.882500)!
## Learning embedding...
## Iteration 50: error is 56.582196 (50 iterations in 0.01 seconds)
## Iteration 100: error is 57.559298 (50 iterations in 0.01 seconds)
## Iteration 150: error is 59.105090 (50 iterations in 0.01 seconds)
## Iteration 200: error is 53.785094 (50 iterations in 0.01 seconds)
## Iteration 250: error is 57.400277 (50 iterations in 0.01 seconds)
## Iteration 300: error is 1.515657 (50 iterations in 0.01 seconds)
## Iteration 350: error is 0.968219 (50 iterations in 0.01 seconds)
## Iteration 400: error is 0.670128 (50 iterations in 0.01 seconds)
## Iteration 450: error is 0.417757 (50 iterations in 0.01 seconds)
## Iteration 500: error is 0.350235 (50 iterations in 0.01 seconds)
## Iteration 550: error is 0.329184 (50 iterations in 0.01 seconds)
## Iteration 600: error is 0.307493 (50 iterations in 0.01 seconds)
## Iteration 650: error is 0.293002 (50 iterations in 0.01 seconds)
## Iteration 700: error is 0.287511 (50 iterations in 0.01 seconds)
## Iteration 750: error is 0.280826 (50 iterations in 0.01 seconds)
## Iteration 800: error is 0.240088 (50 iterations in 0.01 seconds)
## Iteration 850: error is 0.242246 (50 iterations in 0.01 seconds)
## Iteration 900: error is 0.235283 (50 iterations in 0.01 seconds)
## Iteration 950: error is 0.233690 (50 iterations in 0.01 seconds)
## Iteration 1000: error is 0.230780 (50 iterations in 0.01 seconds)
## Fitting performed in 0.18 seconds.
{% endhighlight %}



{% highlight r %}
 df = as.data.frame( emendas.tsne$Y)
 ggplot(df, aes(x = V1, y = V2)) + 
  geom_point(alpha = 0.5, size = 3, color = "darkgreen")
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/AD1figure/source/prob-3-checkpoint-2/2018-01-18-prob-3-checkpoint-2/unnamed-chunk-5-1.png)

### Interpretação

No gráfico resultante da metodologia  t-SNE é possível identificar cerca de 3-4 grupos principais de tamanhos semelhantes. Obersenvando os gráficos abaixo, agora com identificações de estados e regiões, pode-se notar que um dos grupos possuem apenas estados da região nordeste e centro-oeste, mais especificamente os estados PE, CE, GO e MS. Bem afastados desse primeiro, é possível notar outros grupos em que as regiões sul e sudeste aparecem com frequência e há uma diminuição na proporção daqueles identificados anteriormente. Estados da região norte quase não estão presentes e sempre que surgem, estão bem próximos de algum estado da região nordeste, assim como os estados do sul estão mais próximos aos do sudeste.

{% highlight r %}
df$Estado = cp$Estado

ggplot(df, aes(x = V1, y = V2, label = Estado)) + 
  geom_point(alpha = 0.5, size = 3, color = "orange") +
      geom_text(alpha = .7, size = 4, hjust = -.2)
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/AD1figure/source/prob-3-checkpoint-2/2018-01-18-prob-3-checkpoint-2/unnamed-chunk-6-1.png)

{% highlight r %}
df$Regiao = cp$Regiao

ggplot(df, aes(x = V1, y = V2, label = Regiao)) + 
  geom_point(alpha = 0.5, size = 3, color = "brown") +
    geom_text(alpha = .7, size = 4, hjust = -.2)
{% endhighlight %}

![plot of chunk unnamed-chunk-6](/AD1figure/source/prob-3-checkpoint-2/2018-01-18-prob-3-checkpoint-2/unnamed-chunk-6-2.png)
