library(shiny)
library(ggplot2)
source('~/ksen/scidb-dashboard/functions.R')
# Define server logic required to draw a histogram
dyBarChart <- function(dygraph) {
  dyPlotter(dygraph = dygraph,
            name = "BarChart",
            path = system.file("examples/plotters/barchart.js",
                               package = "dygraphs"))
}
shinyServer(function(input, output) {
  
  observeEvent(input$chooseSecondArray, {
    if (input$chooseSecondArray == FALSE) {shinyjs::disable("array2") } else {shinyjs::enable("array2") }
  })

  get_array_stats_ux <- reactive({
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
    statsC = statsC[, c("inst", "count")]
    return(statsC)
  })

  output$dygraph <- renderDygraph({
    stats = get_array_stats_ux()
    dygraph(stats, main = "Count / Instances") %>%
      dyAxis("y", label = "Count", valueRange = c(-0.05*max(stats$count), max(stats$count)))%>%
      dySeries("count", label = input$array1)  %>%
      dyBarChart()
  })
  
  output$summary <- renderPrint({
    input$array1
  })
  
  # array <- reactive({
  #   switch(input$array1)
  # })
  
  
  
})
