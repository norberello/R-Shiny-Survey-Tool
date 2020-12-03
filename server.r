# loading packages
library(shiny)
library(shinydashboard)
library(readxl)

server <- function(input, output, session){
  
  # reading the questionnaire file
  rawQues <- read_excel('questions.xlsx', sheet = 'questions')
  
  # creating vector of module names
  modules <- unique(rawQues$Module)
  
  # creating the sidebar menu
  output$sidebar <- renderMenu({
    sidebarMenu(
      lapply(modules, function(module){
        menuItem(
          text = module
        )
      })
    )
  })
  
}