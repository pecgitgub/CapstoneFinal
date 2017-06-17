#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# Load packages
library(shiny)
library(data.table)
library(stylo)
library(ggplot2)

source("PredictionModel.R")

# Output
shinyServer(function(input,output) {
  
  PredictTable <- reactive({
    build_predict_table(input$text_input)
  })
  
  output$predicted_word <- renderText({
    PredictTable()[1]$WORD
  })
  
  output$predict_table <- renderDataTable({ 
    head(PredictTable(), 10)
  }, options = list( pageLength = 10, paging = FALSE, searching = FALSE) )
  
  output$predict_plot <- renderPlot({
    data <- PredictTable()[1:20]
    plot <- ggplot(data, aes(x=reorder(WORD,-P), y=P, fill=P)) +
      geom_bar(stat='identity', alpha=0.9) +
      theme(axis.text.x = element_text(angle = 60, hjust = 1, size=15)) +
      theme(axis.title = element_text(size=20)) +
      theme(axis.title.y = element_text(vjust=2)) +
      theme(legend.position='none') +
      labs(y = "Probability") +
      labs(x = "Word")
    plot
  })
  
}
)