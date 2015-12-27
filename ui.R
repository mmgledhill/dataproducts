data(USArrests)
data(state.name)
stateslist<-rownames(USArrests)
library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("State Arrest Rankings"),
  sidebarPanel(
    h3('Select a State'),
    selectInput('statein', 'Options', c(Choose='', stateslist),selected="Alaska",selectize=FALSE),
    radioButtons("crimein", "Checkbox",
                       c("Murder" = 1,
                         "Assault" = 2,
                         "Rape" = 4),
                       selected="Murder")
    #submitButton('Submit')
  ),
  mainPanel(
    h3('Your results for'),
    verbatimTextOutput("stateout"),
    p('Out of the 50 states, with #1 being the highest arrest rate it ranks:'),
    verbatimTextOutput("staterank"),
    verbatimTextOutput("statesumm"),
    plotOutput('newHist'),
    h3('Scroll down to see the worst states:'),
    dataTableOutput('worststates')
  
  )
))