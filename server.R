library(shiny)
library(ggplot2)
source('~/ksen/scidb-dashboard/functions.R')
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  observeEvent(input$chooseSecondArray, {
    if (input$chooseSecondArray == FALSE) {shinyjs::disable("array2") } else {shinyjs::enable("array2") }
  })

  output$distPlot <- renderPlot({
    #stats1 = data.frame(inst=c(1:64), count=as.integer(runif(64)*100)) 
    # stats1 = iquery(sprintf("project(summarize(%s, 'per_instance=1'), count)", input$array1), return = TRUE)
    stats1 = get_array_stats(input$array1, input$useCache)
    if (min(stats1$count) == 0) {factor=1} else {factor= min(stats1$count)}
    stats1$scaledCount = stats1$count / factor
    
    stats1$arr = input$array1
    statsC = stats1

    if (input$chooseSecondArray){
      #stats2 = data.frame(inst=c(1:64), count=as.integer(runif(64)*100)) 
      # stats2 = iquery(sprintf("project(summarize(%s, 'per_instance=1'), count)", input$array2), return = TRUE)
      stats2 = get_array_stats(input$array2, input$useCache)
      if (min(stats2$count) == 0) {factor2 = 1} else {factor2= min(stats2$count)}
      stats2$scaledCount = stats2$count / factor2
      
      stats2$arr = input$array2
      statsC = rbind(stats1, stats2)
    }  
    if (!(input$scaleCounts) || factor == 1 || (input$chooseSecondArray & (if(exists('factor2')) {identical(factor2,1)} else {FALSE}))) {
      p1 = ggplot(statsC, aes(x = inst, y = count,      group=arr, shape=arr, color = arr)) + 
        ylim(0, max(2, 1.1*statsC$count))
    } else {
      p1 = ggplot(statsC, aes(x = inst, y = scaledCount, group=arr, shape=arr, color = arr)) + 
        ylim(0, max(2, 1.1*statsC$scaledCount))
    }
    p1 + geom_point(size = 3)  +
      theme(legend.text=element_text(size=15),
            legend.position="top")
  })
  output$summary <- renderPrint({
    input$array1
  })
  
  # array <- reactive({
  #   switch(input$array1)
  # })
  
  
  
})
