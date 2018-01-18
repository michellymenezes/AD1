---
layout: post
title:  Prob 1 - Checkpoint 2
date: "2018-01-17 20:40:15"
published: true
tags: [example1, example2]
---

## Despesas parlamentares

Os parlamentares eleitos no Brasil possuem uma cota mensal destinada a reembolsá-los por diversos gastos relacionados ao trabalho que exercem. Essa cota varia de acordo com o estado ao qual o parlamentar foi eleito. 

### Analisando dados relacionados a alimentação

As despesas são classificadas em diferentes categorias. Neste tópico do documento, vamos avaliar aquelas despesas classificadas como "Fornecimento de alimentação do parlamentar".

No gráfico abaixo, podemos observar, de um modo geral, todos os gastos relacionados a esta categoria e como eles estão distribuídos de acordo com seus valores líquidos em que cada ponto representa um gasto. Podemos também calcular a mediana e moda para mais detalhes.



{% highlight r %}
require(ggplot2)
{% endhighlight %}



{% highlight text %}
## Carregando pacotes exigidos: ggplot2
{% endhighlight %}



{% highlight r %}
gastos <- read.table("ano-atual.csv", sep = ",", header = T)

despesasAlimentares <- subset(gastos, txtDescricao == "FORNECIMENTO DE ALIMENTAÇÃO DO PARLAMENTAR")

ggplot(despesasAlimentares, aes(txtDescricao, vlrLiquido)) + geom_point(position = position_jitter(width = .1), alpha = .3, colour="maroon4")
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-1-checkpoint-2/2018-01-17-prob-1-checkpoint-2/unnamed-chunk-1-1.png)

{% highlight r %}
Moda <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

median(despesasAlimentares$vlrLiquido)
{% endhighlight %}



{% highlight text %}
## [1] 46.76
{% endhighlight %}



{% highlight r %}
Moda(despesasAlimentares$vlrLiquido)
{% endhighlight %}



{% highlight text %}
## [1] 55.09
{% endhighlight %}

A mediana mostra a centralidade dos valores, o valor central é 46,76. Já a moda mostra qual o valor mais frequente em que nesse caso é 55,09. A maioria dos valores estão concentrados abaixo de 500 e é possível observar uma segunda concentração por volta dos 700. Há alguns pontos extremos que estão muito distantes de onde a maioria deles se encontram, chegando a atingir um valor maior que 5000. Para quem analisa, é sugerido que tente entender porque esses dados se comportam assim. Podemos investigar um pouco mais mudando o ponto de vista: vamos agrupar as despesas por estados e por partido para observar como os gastos se distribuem através dessas novas perspectivas.


{% highlight r %}
ggplot(despesasAlimentares, aes(sgUF, vlrLiquido)) +  geom_point(position = position_jitter(width = .1), alpha = .3, colour="slateblue4") + coord_flip()
{% endhighlight %}

![plot of chunk unnamed-chunk-2](/AD1/figure/source/prob-1-checkpoint-2/2018-01-17-prob-1-checkpoint-2/unnamed-chunk-2-1.png)

{% highlight r %}
ggplot(despesasAlimentares, aes(sgPartido, vlrLiquido)) +  geom_point(position = position_jitter(width = .1), alpha = .3, colour="goldenrod4") + coord_flip()
{% endhighlight %}

![plot of chunk unnamed-chunk-2](/AD1/figure/source/prob-1-checkpoint-2/2018-01-17-prob-1-checkpoint-2/unnamed-chunk-2-2.png)

Podemos agora reparar os estados que apresetam mais desses valores muito diferentes como, por exemplo, Paraná, Pará e Maranhão. No outro gráfico, podemos observar o mesmo fenômeno em partidos como PSDB, PSD e PPS. O padrão do gráfico geral permanece o mesmo nos dois novos gerados: a maioria das despesas são referentes a valores abaixo de 500.

É possível notar em ambos os gráficos a presença de uma variável nomeada "NA", ela representa as despesas relacionadas a alimentação que tiveram seus valores registrados, mas não possuem estado e partido definidos em seus respectivos gráficos. É sugerido que se investigue a quem esses gastos estão relacionados. Para isso, analisamos somente somente as despesas relacionadas a essa variável e verificamos a quais parlamentares ela estão associadas. 


{% highlight r %}
missingValues = subset(despesasAlimentares, is.na(despesasAlimentares$sgUF))

ggplot(missingValues, aes(txNomeParlamentar, vlrLiquido)) +  geom_boxplot() + geom_point(position = position_jitter(width = .1), alpha = .3, colour="seagreen4") + coord_flip()
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/AD1/figure/source/prob-1-checkpoint-2/2018-01-17-prob-1-checkpoint-2/unnamed-chunk-3-1.png)

Podemos notar que os valores estão associados a seis partidos diferentes. A linhas desenhadas no meio de cada retângulo no gráfico mostra onde está localizada a mediana. A partir disto podemos observar que não há um padrão: ela está em alguns casos no meio, deixando a representação simétrica e em outros mais nos extremos, deixando assimétrica. Comparando esse gráfico com o que mostra os gastos de cada partido podemos observar algo interessante, o PT que antes não apresentava valores muito variantes agora é o que possui o valor mais alto e desigual!

### Analisando despesas totais
As depesas dos parlamentares são classificadas em tipos. Abaixo podemos visualizar um gráfico em barras que mostra a soma dos valores líquidos em cada tipo de despesa.


{% highlight r %}
gastoPorTipo <- aggregate(vlrLiquido~txtDescricao, gastos, sum)
ggplot(gastoPorTipo, aes(txtDescricao, vlrLiquido)) + geom_bar(stat="identity") + coord_flip()
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/AD1/figure/source/prob-1-checkpoint-2/2018-01-17-prob-1-checkpoint-2/unnamed-chunk-4-1.png)

A partir dele é possível concluir que os parlamentares gastam mais recursos de suas cotas em despesas classificadas como "Divulgação de atividade parlamentar".

Logo abaixo, temos um gráfico exibindo como cada despesa dessas categorias estão distribuiídas. Quanto mais longa a linha formada pelos pontos, maior a variação nos valores das despepesas referentes a um determinado tipo.
Podemos observar que "Divulgação de atividade parlamentar" possui valores que variam muito, assim como outros tipos de despesa como "Serviços postais", "Locação ou fretamento de aeronaves" e "Consutorias, pesquisas e trabalhos técnicos".


{% highlight r %}
ggplot(gastos, aes(txtDescricao, vlrLiquido)) + geom_point(position = position_jitter(width = .1), alpha = .3) + coord_flip()
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/AD1/figure/source/prob-1-checkpoint-2/2018-01-17-prob-1-checkpoint-2/unnamed-chunk-5-1.png)
