# function to generate inputs
single_conditional_panels = function() {
  list(
    # in any case we need the trait(s):
    uiOutput("outsingletraits"),
    
    # condition 2
    conditionalPanel(
      condition = "input.selsingle == 'RCBD'",
      uiOutput("outsingleblock")
    )
  ) # end of list
}