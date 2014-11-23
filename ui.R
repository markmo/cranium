
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Cranium - The Private R Repo Manager"),
  
  # Sidebar with a slider input for number of bins
  sidebarPanel(
    fileInput('file1', 'Upload a package',
              accept=c("application/x-gzip")),
    tableOutput("filetable"),
    tags$hr(),
    textOutput("instruction"),
    tableOutput("packageDetail")
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    dataTableOutput("packageList")
  )
))
