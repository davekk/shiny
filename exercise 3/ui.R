#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("JB's Exercise 2"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      fileInput(inputId = "datasetFile",
                label = "Upload the dataset to work with",
                accept = ".xlsx"),

      selectInput(inputId = "graphType",
                  label = "Type of graph",
                  choices = c("boxplot", "scatterplot", "histogram"),
                  selected = NULL),
      
      # the rest is written into the server...
    
      # and we use it below:
      conditionalPanel(
        condition = "input.graphType == 'boxplot'",
        uiOutput("outVarTrait"),
        uiOutput("outGroup")
      ),
      
     conditionalPanel(
       condition = "input.graphType == 'histogram'",
       uiOutput("outVarTrait4")
      ),
      
      conditionalPanel(
        condition = "input.graphType == 'scatterplot'",
        uiOutput("outVarTraitX"),
        uiOutput("outVarTraitY")
      )
      
    ), # end of sidebarPanel
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("thePlot")
    )
  )
))
