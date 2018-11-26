#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(magrittr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  numericVars = reactive({
    tempvec = sapply(X = fieldbook(), FUN = is.numeric)
    names(tempvec[tempvec])
  })

  #reactive component
  fieldbook = reactive({ # the final value of the reactive element will be the dataframe
    
    dfile = input$datasetFile
    if(is.null(dfile)) return() # making sure no error while no file
    
    # to make sure we preserve a copy of the file:
    newfilename = paste0(dfile$datapath, ".xlsx")
    file.copy(dfile$datapath, newfilename)
    # then we read the data file:
    datatable = readxl::read_xlsx(newfilename, sheet = 1)
    
  })
  
  #RenderUI for traitX,
  output$outVarTraitX = renderUI({
    selectInput(inputId = "traitX",
                label = "Select trait (x axis)",
                choices = c("Choose trait" = "", numericVars())) # other way to specify placeholder
  })
  
  #RenderUI for traitY
  output$outVarTraitY = renderUI({
    selectInput(inputId = "traitY",
                label = "Select trait (y axis)",
                choices = c("Choose trait" = "", numericVars())) # other way to specify placeholder
  })
  
  #RenderUI for single trait
  output$outVarTrait = renderUI({
    selectInput(inputId = "trait",
                label = "Select trait",
                choices = c("Choose trait" = "", numericVars())) # other way to specify placeholder
  })
  
  #RenderUI for single trait (for histogram)
  output$outVarTrait4 = renderUI({
    selectInput(inputId = "traitHistogram",
                label = "Select trait",
                choices = c("Choose trait" = "", numericVars())) # other way to specify placeholder
  })
  
  #RenderUI for grouping variable
  output$outGroup = renderUI({
    vars = sapply(X = fieldbook(), FUN = is.character)
    goodVars = names(vars[vars]) # for now, only character columns can be chosen as grouping factors
    selectInput(inputId = "groupingVar",
                label = "Optional grouping variable",
                choices = c("Choose variable" = "", "--none--",goodVars), selected = "--none--") # other way to specify placeholder
  })
  
  
  #RenderPlot
  output$thePlot = renderPlot({
    if (input$graphType=="boxplot") {
      req(input$trait) # req prevents triggering an error in case a variable is NULL
      p = fieldbook() %>% ggplot(aes_string(y = input$trait)) + geom_boxplot() # VERY IMPORTANT: aes_string(), not aes()!!!!!
      req(input$groupingVar)
      if(input$groupingVar == "--none--") p else p + aes_string(x = input$groupingVar)
    } else {
      # scatterplot or histogram
      if (input$graphType=="histogram") {
        req(input$traitHistogram) # req prevents triggering an error in case a variable is NULL
        fieldbook() %>% ggplot(aes_string(x = input$traitHistogram)) + geom_histogram() # VERY IMPORTANT: aes_string(), not aes()!!!!!
        
      } else {
        # scatterplot
        req(input$traitX, input$traitY)
        fieldbook() %>% ggplot(aes_string(x = input$traitX, y = input$traitY)) + geom_point() + geom_smooth()
        # VERY IMPORTANT: aes_string(), not aes()!!!!!
      }
    }
  })
  
})
