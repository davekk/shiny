# design choices, in the form of a named vector
design_choices = c("Completely randomized design (CRD)" = "CRD",
                   "Randomized complete block design (RCBD)" = "RCBD")


# function to generate inputs
design_conditional_panels = function() {
  list(
    # condition 1
    conditionalPanel(
      condition = "input.seldesign == 'CRD'",
      selectInput(inputId = "design_r",
                  label = "Replications",
                  choices = 2:100,
                  selected = 2)
    ),
    
    # condition 2
    conditionalPanel(
      condition = "input.seldesign == 'RCBD'",
      selectInput(inputId = "design_b",
                  label = "Blocks",
                  choices = 2:100,
                  selected = 2)
    )
  ) # end of list
}