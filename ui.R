library(shiny)

library(scidb)
scidbconnect()
library(rredis)
redisConnect()

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
      helpText("Distribution of array over SciDB instances"), 
      helpText("Plot shows counts per instance, or scaled count  (if minimum is non-zero)"),
      checkboxInput("useCache", "use cache?", FALSE)
    ),
    mainPanel(
      # verbatimTextOutput("summary"),
      plotOutput("distPlot")
    )
  )
))