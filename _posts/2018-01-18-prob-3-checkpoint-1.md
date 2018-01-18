---
layout: post
title:  Prob 3 - Checkpoint 1
date: "2018-01-18 19:22:50"
published: true
tags: [example1, example2]
---

## Emendas para sáude na região Norte

O objetivo deste documento é fazer uma breve análise a respeito de alguns dados adiquiridos sobre emendas parlamentares. Emendas são custeios requisitados por parlamentares para a execução de algum projeto. Esses projetos são destinados para uma ciadade específica e podem ser classificados em diferentes funções.

Nesta análise, estaremos explorando dados referentes as emendas aprovadas para estados da região norte, destinadas a categoria Saúde. Logo abaixo, você pode visualizar a plotagem das emendas. O eixo y representa o valor. O eixo x representa o tempo, em dias, definidos para a realização do projeto.




{% highlight r %}
ggplot(norte, aes(DIAS, VALOR_REPASSE_EMENDA)) + 
  geom_point(position = position_jitter(width = .1), alpha = .4) +
  labs(title="Emendas para saúde na região Norte", x= "Tempo (em dias)", y="Valor em R$")
{% endhighlight %}

![plot of chunk unnamed-chunk-2](/AD1/figure/source/prob-3-checkpoint-1/2018-01-18-prob-3-checkpoint-1/unnamed-chunk-2-1.png)

Tendo em vista que temos apenas valores numéricos como variáveis, podemos utilizar o método hierárquico para formar clusters com os pontos no gráfico. A função *hclust* foi aplicada para a construção da árvore e junto a ela o valor **average** para definir o método de clustering, esta calcula a distância média entre as combinações de pontos. Com ajuda do gráfico e através de uma análise visual foi decidido que os pontos serão divididos em 6 clusters - passa-se então o parâmetro 6 para **h** na função *cutree*. O resultado pode ser visualizado abaixo:


{% highlight r %}
d<- dist(scale(norte.k))
hc <- hclust(d, method="average")
norte.k$cluster = factor(cutree(hc, k=6))

ggplot(norte.k, aes(norte.DIAS, norte.VALOR_REPASSE_EMENDA, colour = cluster)) + 
  geom_point(size = 3, alpha = .4) +
  labs(title="Clusters de emendas para saúde na região Norte", x= "Tempo (em dias)", y="Valor em R$", colour="Clusters")
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/AD1/figure/source/prob-3-checkpoint-1/2018-01-18-prob-3-checkpoint-1/unnamed-chunk-3-1.png)

Visualmente falando, o agrupamento aparenta ter sido bem executado. É possível identificar pontos concentrados formando grupos em que cada grupo apresenta uma cor diferenciada. Os clusters 4, 1 e 5 são caracterizados por menores custos, mas com períodos de tempo que vão crescendo na ordem mencionada. Da mesma forma se comportam os clusters 6 e 3, mas com valores considerados intermediários se comparados com os demais. Por último, o cluster 2 é caracterizado por ser de alto custo e curto tempo.

Podemos filtrar o primeiro gráfico de modo que alguns detalhes sejam representados. A partir deles poderemos compará-los com os agrupamentos e tirar algumas conclusões.

Do gráfico abaixo podemos observar que os clusters 1, 3, 5, 6 possuem semelhanças por serem constituídos principalmente pela categoria  Administração Pública Municipal. O cluster 4, por outro lado, possui uma maior presença das duas outras categorias.


{% highlight r %}
ggplot(norte, aes(DIAS, VALOR_REPASSE_EMENDA, color = NATUREZA_JURIDICA )) + 
  geom_point(position = position_jitter(width = .1), alpha = .4) +
  labs(title="Emendas para saúde na região Norte", x= "Tempo (em dias)", y="Valor em R$", colour="Natureza jurídica")
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/AD1/figure/source/prob-3-checkpoint-1/2018-01-18-prob-3-checkpoint-1/unnamed-chunk-4-1.png)

Comparando o gráfico seguinte com os clusters podemos concluir que o cluster 4 é principalmente caracterizado por investimentos que aquisição. Nos 1 e 5, apesar de heterogêneo, se destacam investimentos de ampliação, reforma, manutenção ou educação. Enquanto nos 3 e 6 estão mais presentes investimentos de construção.


{% highlight r %}
ggplot(norte, aes(DIAS, VALOR_REPASSE_EMENDA, color = TIPO )) + 
  geom_point(position = position_jitter(width = .1), alpha = .4) +
  labs(title="Emendas para saúde na região Norte", x= "Tempo (em dias)", y="Valor em R$", colour="Tipo de investimento")
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/AD1/figure/source/prob-3-checkpoint-1/2018-01-18-prob-3-checkpoint-1/unnamed-chunk-5-1.png)
