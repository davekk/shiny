#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(RMySQL)
library(tidyverse)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  mydb = dbConnect(drv = MySQL(),
                   host = "localhost",
                   port = 3306,
                   user = "root",
                   password = "",
                   dbname = "limidb3") # or use default.file = ... to provide the name
  # of the file containing the connexion details
  # Warning! In this implementation, the connection remains open all the time.
  
  observe({ # executed only once when the app starts
    showModal(modalDialog(title = "Hello!", "Successful connection to LiMiDB."))
  })

  
  metadata = reactive({ # the result of this reactive is the data frame itself
    # the query
    query = paste0("SELECT * FROM `p_metadata`")
    dbGetQuery(mydb, query)

  })
  
  OTUtable = reactive({ # the result of this reactive is the data frame itself
    # the query
    query = paste0("SELECT * FROM `otutbl`")
    dbGetQuery(mydb, query)
    
  })
  
  taxonomy = reactive({ # the result of this reactive is the data frame itself
    # the query
    query = paste0("SELECT * FROM `p_taxonomy`")
    dbGetQuery(mydb, query)
    
  })
  
  samplelist = reactive({ # the result of this reactive is the data frame itself
    # the query
    unique(metadata()$sample)
  })
  
  #RenderUI for the list of samples
  output$listSamples = renderUI({
    selectInput(inputId = "selSample",
                label = "Select the sample of interest",
                choices = samplelist())
  })
  
  observeEvent(input$saverds, { # saves whenever somebody clicks the button "Synchronise"
    saveRDS(object = OTUtable(), file = "material/OTUtable.rds")
    txtMessage = paste("The OTU table has been successfully saved into an RDS file.")
    # showModal(modalDialog(txtMessage))
    shinyalert::shinyalert(title="Perfecto!", text = txtMessage, type = "success",
                           timer = 4000, # in milliseconds
                           showConfirmButton = F)
  })
  
  
  observeEvent(input$viewdt, { # to view the OTUs associated with the selected sample
    df = OTUtable() %>% filter(sample == input$selSample)
    output$materialdt = DT::renderDataTable({
      DT::datatable(df, rownames = F,
                    options = list(scrollX = T, scroller = T),
                    selection = list(mode = "multiple", selected = NULL))
    })
  })
  
  # a reactive to produce the genotypes
  fbmaterial = reactive({
    req(input$filegrem)
    dfile = input$filegrem
    newfname = paste0(dfile$datapath, '.xlsx')
    file.copy(dfile$datapath, newfname)
    fb = readxl::read_xlsx(newfname, sheet = 1)
    fb$Accession_Number # genotypes
  })
  
  
  # design
  fbdesign = reactive({
    
    if (is.null(fbmaterial()) | length(fbmaterial())==0) return()
    
    trt = fbmaterial() # genotypes or treatments
    design = input$seldesign
    if (design == "CRD") r = as.integer(input$design_r) else b = as.integer(input$design_b)
    
    fb = switch(design,
                RCBD = agricolae::design.rcbd(trt = trt, r = b),
                CRD = agricolae::design.crd(trt = trt, r = r))
    fb$book$plots = as.integer(fb$book$plots) # just a glitch in agricolae
    fb$book # the return value is a slot from the object created with agricolae
    
  })
  
  # observeEvent for the preview button
  observeEvent(input$btnPreview, {
    output$fbpreview = rhandsontable::renderRHandsontable({
      rhandsontable::rhandsontable(fbdesign(), readOnly = T)
    })
  })
  
  
  # the observer for the download button
  output$btnDwnld = downloadHandler(
    filename = paste0("data-", Sys.time(), ".csv"),
    content = function(file) { write.csv(x = fbdesign(), file = file, row.names = F) }
  )
  
  # a reactive to produce the single experiment design file
  fbsingle = reactive({
    req(input$filesingle)
    dfile = input$filesingle
    newfname = paste0(dfile$datapath, '.xlsx')
    file.copy(dfile$datapath, newfname)
    readxl::read_xlsx(newfname, sheet = 1)
  })
  
  
  # select the genotypes
  output$outsinglegen = renderUI({
    req(input$filesingle)
    # selectInput
    selectInput(inputId = "selgenotypes", label = "Select the column containing genotypes", choices = names(fbsingle()))
  })
  
  # select the block
  output$outsingleblock = renderUI({
    req(input$filesingle)
    # selectInput
    selectInput(inputId = "selblock", label = "Select the block", choices = names(fbsingle()))
  })
  
  
  # select the traits
  output$outsingletraits = renderUI({
    req(input$filesingle)
    # selectInput
    selectInput(inputId = "seltraits", label = "Select the trait(s) of interest", choices = names(fbsingle()), multiple = T)
    
  })
  
  # run the single_environment_analysis!!!
  observeEvent(
    eventExpr = input$btnsingle,
    handlerExpr = {
      design = input$selsingle
      fb = as.data.frame(fbsingle())
      traits = input$seltraits
      block = input$selblock
      genotypes = input$selgenotypes
      if (design == "RCBD") {
        pepa::repo.rcbd(traits = traits, geno = genotypes, rep = block, dfr = fb)
      } else {
        pepa::repo.crd(traits = traits, geno = genotypes, dfr = fb)
      
      }
      
    }
  ) # end of this observeEvent
  
})
