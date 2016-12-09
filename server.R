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
    arr1 = scidb(input$array1)
    stats1 = array_stats(arr1, per_instance = TRUE)
    if (min(stats1$count) == 0) {factor=1} else {factor= min(stats1$count)}
    stats1$scaledCount = stats1$count / factor
    
    if (input$chooseSecondArray != FALSE){
      arr2 = scidb(input$array2)
      stats2 = array_stats(arr2, per_instance = TRUE)
      if (min(stats2$count) == 0) {factor=1} else {factor= min(stats2$count)}
      stats2$scaledCount = stats2$count / factor
      
      
      
      stats1$arr = input$array1
      stats2$arr = input$array2
      statsC = rbind(stats1, stats2)
      
      
      # geom_point(data=stats2, aes(x=inst, y=scaledCount), color="blue") +
    }  else { 
      stats1$arr = input$array1
      statsC = stats1
    }
    ggplot(statsC, aes(x = inst, y = scaledCount, group=arr, shape=arr, color = arr)) + geom_point() + 
      ylim(0, max(2, 1.1*statsC$scaledCount)) +
      theme(legend.text=element_text(size=15),
            legend.position="top")
  })
  output$summary <- renderPrint({
    input$array1
  })
  
  observeEvent(input$chooseSecondArray, {
    if (input$chooseSecondArray == FALSE) {shinyjs::disable("array2") } else {shinyjs::enable("array2") }
  })
  # array <- reactive({
  #   switch(input$array1)
  # })
  
  
  
})