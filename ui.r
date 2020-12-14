# loading packages
library(shiny)
library(shinydashboard)

# creating the ui
ui <- dashboardPage(
  # start header
  dashboardHeader(title = 'Demo Survey'),
  # end header
  
  # start sidebar
  dashboardSidebar(
    sidebarMenuOutput('sidebar')
  ),
  # end sidebar
  
  # start main body
  dashboardBody(
    tags$link(href='style.css', rel='stylesheet'),
    uiOutput('mainBody')
  )
  # end main body
)