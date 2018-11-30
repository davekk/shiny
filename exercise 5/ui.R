#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

source("helpers/helperCode.R")
source("helpers/singleinputs.R")

sidebar = dashboardSidebar(
  #width="200px",
  sidebarMenu(
    
    menuItem("Dataset Selection", icon = icon("dashboard"),
             menuSubItem("Dataset List", tabName  = "material", icon = icon("table"))
             ),
    
    menuItem("Fieldbook", icon = icon("leaf"),
             menuSubItem("Design", tabName  = "design", icon = icon("table"),
                         selected = T)
             ),
    
    menuItem("Analysis", icon = icon("pie-chart"),
             menuSubItem("Single environment", tabName  = "single", icon = icon("table"))
             )
  )
)


body = dashboardBody(
  
  tabItems(
    
    # menu item 1
    # all the things to be displayed when we are in that menu
    tabItem(tabName = "material",
            h2("Selecting samples"), # the thing to be displayed when the user clicked on the "material" tab
            shinyalert::useShinyalert(), # necessary to "allow" the use of a shinyAlert in the corresponding tabitem
            uiOutput("listSamples"), # produces the dropdown list
            actionButton(inputId = "saverds", # will save a local image of the DB in RDS format
                         label = "Synchronise database",
                         icon = icon("refresh")),
            
            actionButton(inputId = "viewdt", # to show the associated OTUs
                         label = "Show associated OTUs",
                         icon = icon("table")),
            br(),
            br(),
            DT::dataTableOutput("materialdt")
    ),
  
    # menu item 2
    tabItem(tabName = "design",
            h2("Design"), # the thing to be displayed when the user clicked on the "material" tab
            
            # fileInput
            fileInput(inputId = "filegrem",
                      label = "Upload file",
                      placeholder = "Select file...",
                      accept = ".xlsx"),
            
            # selectInput
            selectInput(inputId = "seldesign", label = "Design", choices = design_choices, selected = "CRD"),
            
            # function to draw different designs, drawing from a different file
            design_conditional_panels(),
            
            actionButton(inputId = "btnPreview",
                         label = "Fieldbook preview",
                         icon = icon("table")),
            
            downloadButton(outputId = "btnDwnld",
                           label = "Download"),
            br(), br(),
            
            rhandsontable::rHandsontableOutput("fbpreview")
            
    ),
    
    
    # menu item 3
    tabItem(tabName = "single",
            h2("Single environment analysis"), # the thing to be displayed when the user clicked on the "material" tab
            
            # upload file
            fileInput(inputId = "filesingle",
                        label = "Upload file",
                        accept = ".xlsx",
                        placeholder = "No file yet..."),
            
            # select input
            selectInput(inputId = "selsingle", label = "Design", choices = design_choices, selected = "CRD"),
            
            # uiOutput for genotypes
            uiOutput("outsinglegen"),
            
            # function to output the conditional panels, drawing from the helper file
            single_conditional_panels(),
            
            br(),
            br(),
            actionButton(inputId = "btnsingle",
                         label = "Run analysis",
                         icon = icon("play-circle"))
            
            
    )
    
  )
  
  
) # end of dashboardBody()



dashboardPage(
  dashboardHeader(title = "My Exercise 4"),
  sidebar,
  body
)