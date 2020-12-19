# loading packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
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
  
  # function to create a list of divs for each question in a module
  questionsDivList <- function(moduleName){
    q <- rawQues[rawQues$Module==moduleName,]
    qList <- list()
    for (i in 1:nrow(q)){
      if(q$Type[i]=='closed'){
        qList[[i]] <- div(
          prettyRadioButtons(
            inputId = paste0(moduleName, i),
            label = q$Question[i], 
            choices = strsplit(q$Options[i], split = ',')[[1]],
            icon = icon("check"), 
            bigger = TRUE,
            status = "info",
            animation = "jelly",
            inline = FALSE
          ),
          class = 'questionDiv'
        )
      }
      else if(q$Type[i]=='open-num'){
        qList[[i]] <- div(
          numericInput(
            inputId = paste0(moduleName, i),
            label = q$Question[i],
            value = NA,
            width = '100%'
          ),
          class = 'questionDiv numeric'
        )
      }
      else if(q$Type[i]=='open-char'){
        qList[[i]] <- div(
          textInput(
            inputId = paste0(moduleName, i),
            label = q$Question[i],
            value = NA
          ),
          class = 'questionDiv numeric'
        )
      }
      else{
        qList[[i]] <- div(
          h4(q$Question[i]),
          class = 'questionDiv'
        )
      }
    }
    return(qList)
  }
  
  # creating the main body where the questions will be shown
  output$mainBody <- renderUI({
    tabItemList <- lapply(
      modules, function(module){
        tabItem(
          tabName = str_replace_all(module, pattern = ' ', replacement = '_'),
          fluidRow(
            column(width = 3),
            column(
              width = 6,
              do.call(div, questionsDivList(module))
            ),
            column(width = 3)
          )
        )
      }
    )
    do.call(tabItems, tabItemList)
  })
  
}