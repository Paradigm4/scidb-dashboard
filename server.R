library(shiny)
library(ggplot2)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    arr = scidb(input$dataset)
    stats = array_stats(arr, per_instance = TRUE)
    if (min(stats$count) == 0) {factor=1} else {factor= min(stats$count)}
    stats$scaledCount = stats$count / factor
    ggplot(stats, aes(x = inst, y = scaledCount)) + geom_point()
  })
  output$summary <- renderPrint({
    input$dataset
  })
  
  # array <- reactive({
  #   switch(input$dataset)
  # })
  
  
  
})