library(shiny)
library(parcoords)
library(shinythemes)
source("chooser.R") #for chooserInput

shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  fluidRow( column(12,textOutput("text1")),
    column(12,titlePanel("Parcoords Plotter"),p("Each axis represents a variable and each line represents a subject. Click and drag variable names left and right to reorder axes. Click and drag along an axis to draw a rectangle that constrains the range of that variable. Click and drag the rectangle to shift the demarcated range up or down."))),
    fluidRow(
      column(5,wellPanel(fileInput('file1', h4("1. Upload your data (csv format)"),accept=c('text/csv','text/comma-separated-values,text/plain','.csv')),
                        tags$hr(),
                        fluidRow(
                          column(4,checkboxInput('header', 'Header', TRUE)),
                          column(4,radioButtons('sep', 'Separator', c(Comma=',',Semicolon=';',Tab='\t'),',')),
                          column(4,radioButtons('quote', 'Quote', c(None='','Double Quote'='"','Single Quote'="'"),''))
                          )
                        ),
              tags$hr(),
              wellPanel(fluidRow(column(5,h4("Axis height (px)"),sliderInput("slider1",label=NULL,min=200,max=1500,value=500)),
                                 column(5,h4("Plot width (px)"),sliderInput("slider2",label=NULL,min=200,max=5000,value=1300)),
                                 column(2,h4("Color by"),uiOutput("varselected"))))),
      column(5, wellPanel(h4("2. Add variables to plot"),p("Add and remove variables by clicking on right and left arrows."),
                          uiOutput("choices"),tags$b("Note: The \"iris\" dataset is loaded by default as an example. The variables on the left-hand column will be replaced by the ones in your dataset once you upload your file."))),
      column(2, wellPanel(h4("3. Run K-means clustering (optional)"),p("This will create a variable (awkwardly named \"clusterFit$cluster\") that contains the K-means clustering solution based on the specified number of clusters."),numericInput("num", label = h5("Specify number of clusters:"), value=2, min=2, max=9),actionButton("run", label = "Run")))
    ),
    column(12,parcoordsOutput("pcplot"))
))