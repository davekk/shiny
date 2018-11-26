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
  titlePanel("JB's exercise 1"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout( # two arguments: sidebarPanel() and mainPanel()
    
    sidebarPanel(
      textInput(inputId = "projectName",
                label = "Experiment project name",
                placeholder = "Enter the name of your project"),
      
      # simple dropdown list
      selectInput(inputId = "experimentType",
                label = "Type of experiment",
                choices = c("Controlled trial", "Varietal trial", "Germplasm trial", "Uncontrolled trial", "Kid's experiment")),
      
      selectizeInput(inputId = "crops",
                     label = "Crop(s)",
                     choices = c("Maize", "Trigo", "Cassava", "Common bean", "Wheat", "Yam"),
                     selected = c("Trigo","Wheat"),
                     multiple = TRUE,
                     options = list(placeholder = "Select your crops (max. 3)", maxItems = 3)),
      
      dateInput(inputId = "plantingDate",
                label = "Planting date"),
      
      dateRangeInput(inputId = "experimentDates",
                     label = "Experiment dates"),
      
      checkboxInput(inputId = "breeding_bool",
                    label = "Check this box if this is a breeding experiment"),
      
      checkboxGroupInput(inputId = "sites",
                     label = "Site(s)",
                     choices = c("Peru", "India", "Netherlands", "Togo", "Nigeria", "France"),
                     selected = NULL),
      
      textAreaInput(inputId = "projectNotes",
                label = "Project notes",
                placeholder = "Your random notes here",
                width = "100%", height = "100%"),
      
      fileInput(inputId = "datasetFile",
                label = "Upload your dataset"),
      
      radioButtons(inputId = "experimentalUnits",
                   label = "Experimental units",
                   choices = c("kg/ha", "ton/ha", "ton/acre"))
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      htmlOutput("selectedVars_HTML")
    )
  )
))
