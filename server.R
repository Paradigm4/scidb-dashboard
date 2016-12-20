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
dyMultiColumn <- function(dygraph) {
  dyPlotter(dygraph = dygraph,
            name = "MultiColumn",
            path = system.file("examples/plotters/multicolumn.js",
                               package = "dygraphs"))
}
shinyServer(function(input, output) {
  
  observeEvent(input$chooseSecondArray, {
    if (input$chooseSecondArray == FALSE) {shinyjs::disable("array2") } else {shinyjs::enable("array2") }
  })

  get_array_stats_array1 <- reactive({
    stats1 = get_array_stats(input$array1, input$useCache)
    if (min(stats1$count) == 0) {factor=1} else {factor= min(stats1$count)}
    stats1$scaledCount = stats1$count / factor
    return(stats1[, c("inst", "count")])
  })

  get_array_stats_array2 <- reactive({
    stats2 = get_array_stats(input$array2, input$useCache)
    if (min(stats2$count) == 0) {factor2 = 1} else {factor2= min(stats2$count)}
    stats2$scaledCount = stats2$count / factor2
    
    return(stats2[, c("inst", "count")])
  })
  
  output$dygraph <- renderDygraph({
    stats1 = get_array_stats_array1()
    if (!input$chooseSecondArray) {
      dygraph(stats1, main = "Count / Instances") %>%
        dyAxis("y", label = "Count", valueRange = c(-0.05*max(stats1$count), max(stats1$count)))%>%
        dySeries("count", label = input$array1)  %>%
        dyBarChart()
    } else {
      stats2 = get_array_stats_array2()
      statsC <- data.frame(inst=stats1$inst, stats1=stats1$count, stats2=stats2$count)
      colnames(statsC)=c("inst", input$array1, input$array2)
      dygraph(statsC) %>%
        dyAxis("y", label = "Count", valueRange = c(-0.05*max(stats1$count), max(stats1$count)))%>%
        dyMultiColumn()
    }
  })
  
  output$summary <- renderPrint({
    input$array1
  })
  
  # array <- reactive({
  #   switch(input$array1)
  # })
  
  
  
})
