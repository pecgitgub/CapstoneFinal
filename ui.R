#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(
  
  headerPanel("N-Gram Word Prediction"),
  
  sidebarPanel(
    
    textInput("text_input", "Text Input:", value = ""),
    submitButton('Submit'),
    br(),
    h3("Instructions:"),
    p("1. Type a phrase into the Text Box"),
    p('2. Click the "Submit" button'),
    p("3. Select a tab to view prediction output")
  ),
  
  mainPanel(
    tabsetPanel(type="tabs",
                tabPanel("Prediction",
                         h3("Word Prediction"),
                         verbatimTextOutput("predicted_word")
                ),
                tabPanel("Table",
                         h3("Predicted Words Ranked by Probability"),
                         dataTableOutput('predict_table')),
                tabPanel("Plot",
                         h3("Plot of Predicted Words"),
                         plotOutput("predict_plot")),
                tabPanel("About",
                         h3("About this App"),
                         p("Author: Satya Pechetty"),
                         p("Date: June 16th, 2017"),
                         p("This App was designed for the Capstone course of the Johns Hopkins Data Science Specialization.")
                         )
                
    )
    )
  
)
)