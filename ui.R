library(shiny)

arrayList <- function() {
library(scidb)
scidbconnect()
arrayList = scidbls()
notR_arrays = !(grepl("R_array+", arrayList, perl=TRUE))
arrayList[notR_arrays]}

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
      helpText("Plot shows distribution of array over SciDB instances", 
               "Count is scaled w.r.t. minimum",
               "(unless minimum is zero)")
    ),
    mainPanel(
      # verbatimTextOutput("summary"),
      plotOutput("distPlot")
    )
  )
))