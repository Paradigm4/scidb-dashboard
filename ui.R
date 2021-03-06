library(shiny)
library(dygraphs)
db <<- NULL
tryCatch({
  library(scidb)
  db <<- scidbconnect(username = "root", password = "Paradigm4", port = 8083, protocol = "https")
}, error = function(e){
  print(e)
})
try(
  {
    library(rredis)
    redisConnect()
  }
)
source('functions.R')

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  
  # Application title
  titlePanel("SciDB array dashboard"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    # Show a plot of the generated distribution
    sidebarPanel(
      selectInput("nmsp_list", "Choose a namespace:", 
                  choices = nmspList(),
                  selected = 'public'),
      selectInput("array1", "Choose a SciDB array:", 
                  choices = arrayList()),
      checkboxInput("chooseSecondArray", "Compare with another array", FALSE),
      selectInput("array2", "Compare with another SciDB array:", 
                  choices = NULL),
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