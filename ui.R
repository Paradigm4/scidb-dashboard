library(shiny)
library(dygraphs)
tryCatch({
  library(scidb)
  scidbconnect()
}, error = function(e){
  print(e)
})
try(
  {
    library(rredis)
    redisConnect()
  }
)
source('~/ksen/scidb-dashboard/functions.R')

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  
  # Application title
  titlePanel("SciDB array dashboard"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    # Show a plot of the generated distribution
    sidebarPanel(
      selectInput("array1", "Choose a SciDB array:", 
                  choices = arrayList()),
      checkboxInput("chooseSecondArray", "Compare with another array", FALSE),
      selectInput("array2", "Compare with another SciDB array:", 
                  choices = arrayList()),
      helpText("SciDB array residency"), 
      helpText("Plot shows counts per instance, or scaled count  (if minimum is non-zero)"),
      h4("Options"),
      checkboxInput("scaleCounts", "scale counts when possible", FALSE),
      checkboxInput("useCache", "use cache", FALSE)
    ),
    mainPanel(
      dygraphOutput("dygraph"),
      dygraphOutput("dygraph2")
    )
  )
))