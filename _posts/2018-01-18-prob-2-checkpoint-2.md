---
layout: post
title:  Prob 2 - Checkpoint 2
date: "2018-01-18 19:21:21"
published: true
tags: [example1, example2]
---

## Bilhetes aéreos emitidos para trechos além de BSB

O gráfico abaixo resume como se concentram e estão distribuídos os valores relacionados a emissão de blihetes aéreos com trechos além de BSB (Brasília). Para cada mês, podemos observar suas respectivas distribuições para duas categorias diferentes: quando o passageiro é o próprio parlamentar e quando é uma terceira pessoa. Ao fim da análise o leitor pode concluir que os valores de todos os bilhetes se concentram mais entre 0-1000 reais, a frequência de emissão de bilhetes para parlamentares é maior que para terceiros em todos os meses, pois a macha roxa é maior e mais escura que a laranja e que existem pontos com valores fora do padrão em que, em sua maior parte, foram de bilhetes para parlamentares. 

{% highlight text %}
## Carregando pacotes exigidos: ggplot2
{% endhighlight %}

![plot of chunk unnamed-chunk-1](/AD1/figure/source/prob-2-checkpoint-2/2018-01-18-prob-2-checkpoint-2/unnamed-chunk-1-1.png)

Para facilitar leitura foram feitas algumas mudanças. As categorias de passageiros que antes estavam sobrepostas foram separadas para uma melhor análise individual e comparação. Os valores negativos foram removidos da visualização, o intuito é somente ter valores que foram realmente gastos. Legendas foram adicionadas e uma mudança nas cores foi realizada para melhor compreensão das variáves. O tamanho do gráfico foi aumentado com a intenção de melhorar a visualização já que houve um maior espalhamento dos pontos plotados.
