# loading packages
library(shiny)
library(shinydashboard)
library(readxl)
library(stringr)

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
          text = module,
          tabName = str_replace_all(module, pattern = ' ', replacement = '_')
        )
      })
    )
  })
  
  # creating the main body where the questions will be shown
  output$mainBody <- renderUI(
    do.call(
      tabItems,
      lapply(modules, function(module){
        tabItem(
          tabName = str_replace_all(module, pattern = ' ', replacement = '_'),
          h2(module)
        )
      })
    )
  )
  
}