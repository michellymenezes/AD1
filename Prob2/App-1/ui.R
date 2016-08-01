shinyUI(fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(img(src="cat2.gif", height = 72)),
    mainPanel(
      img(src="cat.gif", height = 200)
    )
  )
))