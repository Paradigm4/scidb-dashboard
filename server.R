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

scaleStatsIfPossible = function(stats1, scaleCounts){
  if (min(stats1$count) == 0 || !(scaleCounts)) {
    return(stats1[, c("inst", "count", "bytes")])
  } else {
    factor= min(stats1$count)
    stats1$scaled.count = stats1$count / factor
    return(stats1[, c("inst", "scaled.count", "bytes")])
  }
}

plotArrayDist = function(stats1, plotName, color){
  isScaled = (colnames(stats1)[2] == "scaled.count")
  p1 = dygraph(stats1, main = plotName, group = "dygraph_barplot") 
  if (!isScaled) {
    p1 = p1 %>% dyAxis("y", label = colnames(stats1)[2], valueRange = c(-0.05*max(stats1[,2]), 1.05*max(stats1[,2])))
  } else {
    p1 = p1 %>% dyAxis("y", label = colnames(stats1)[2], valueRange = c(0.95, 1.05*max(max(stats1[,2]), 2)))
  }
  p1 = p1 %>% dyAxis("x", label = "Instance #") %>%
    dySeries(colnames(stats1)[2], label = "count")  %>%
    dyBarChart() %>%
    dyOptions(colors = color)
  p1
}

shinyServer(function(input, output) {
  
  observeEvent(input$chooseSecondArray, {
    if (input$chooseSecondArray == FALSE) {shinyjs::disable("array2") } else {shinyjs::enable("array2") }
  })

  get_array_stats_array1 <- reactive({
    stats1 = get_array_stats(input$array1, input$useCache)
    scaleStatsIfPossible(stats1, input$scaleCounts)
  })

  get_array_stats_array2 <- reactive({
    stats2 = get_array_stats(input$array2, input$useCache)
    scaleStatsIfPossible(stats2, input$scaleCounts)
  })
  
  output$dygraph <- renderDygraph({
    stats = get_array_stats_array1()
    plotName = sprintf("%s (%s)", 
                       input$array1, 
                       utils:::format.object_size(sum(stats$bytes), "auto") )
    plotArrayDist(stats[, c(1,2)], plotName, color = RColorBrewer::brewer.pal(3, "Set2")[3])
  })
  
  output$dygraph2 <- renderDygraph({
    if (input$chooseSecondArray & (input$array1 != input$array2)) {
      stats = get_array_stats_array2()
      plotName = sprintf("%s (%s)", 
                         input$array2, 
                         utils:::format.object_size(sum(stats$bytes), "auto") )
      plotArrayDist(stats[, c(1,2)], plotName, color = RColorBrewer::brewer.pal(3, "Set2")[1])
      } else { return(NULL) }
  })
  
  output$summary <- renderPrint({
    input$array1
  })
})
