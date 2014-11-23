
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(miniCRAN)
library(utils)
library(tools)

localCRAN <- "/Users/markmo/Downloads/miniCRAN"
uri <- paste0("file:///", normalizePath(localCRAN))

# using it as an event bus
values <- reactiveValues()

# Limit max file upload to 9MB
options(shiny.maxRequestSize = 9*1024^2)

options(repos = c(CRAN=uri))
getOption("repos")

shinyServer(function(input, output) {
   
  output$packageList <- renderDataTable({
    # trigger this output when the value of dummy changes
    x = values$dummy
    pkgs <- available.packages(type="source")
    m <- pkgs[, 1:2]
    rownames(m) <- NULL
    m
  },
  options=list(pageLength=25),
  callback="function(table) {
    table.on('click.dt', 'tr', function(row) {
      $(this).parent().find('tr').removeClass('selected');
      $(this).toggleClass('selected');
      Shiny.onInputChange('selection',
                          $(this).find('td:first-child').text());
    });
  }"
  )
  
  output$instruction <- renderText({
    if (is.null(input$selection)) {
      "Select package -->"
    }
  })
  
  output$packageDetail <- renderTable({
    if (!is.null(input[["selection"]])) {
      desc <- packageDescription(input$selection)
      if (!is.na(desc)) {
        df <- data.frame(as.matrix(desc)[, 1])
        t(df)
      } else {
        t(data.frame(Package=c("Not found")))
      }
    }
  })
  
  output$filetable <- renderTable({
    inFile <- input$file1
    if (is.null(inFile)) {
      return(NULL)
    }
    system(paste("mv ", inFile$datapath, " ", localCRAN, "/src/contrib/", inFile$name, sep=""))
    write_PACKAGES(paste(localCRAN, "/src/contrib", sep=""))
    
    # trigger a re-render of output$packageList
    values$dummy <- T

    inFile[, 1:3]
  })
  
})
