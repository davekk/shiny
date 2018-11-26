#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer( function(input, output) {
   
  output$selectedVars_HTML <- renderUI({
    HTML(paste(input$projectName,
               input$experimentType,
               input$plantingDate,
               input$experimentDates[1],
               input$experimentDates[2],
               input$experimentalUnits,
               input$datasetFile$name,
               input$datasetFile$datapath,
               paste("Type of file is", input$datasetFile$type),
               input$projectNotes,
               sep="<br/>",
               'static text'))
  })
})
