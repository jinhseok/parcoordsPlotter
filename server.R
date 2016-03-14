library(shiny)
library(parcoords)
library(dplyr)

#load iris data set as default
default<-iris

shinyServer(function(input, output, session){
  
  #load user data file
  theData<-reactive({
    inFile <- input$file1
    if (is.null(inFile)){d<-default}
    else{d<-read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)}
    return(d)
  })
  
  #if cluster button is hit, run kmeans
  clusterFit<-eventReactive(input$run,{
    print("clusterFit run")
    d<-theData()
    numclust<-input$num
    print(c("numclust",numclust))
    # browser()
    d[which(sapply(d,is.factor)==T)]<-sapply(d[which(sapply(d,is.factor)==T)],as.numeric)
    return(kmeans(subset(d),numclust))
  })
  
  output$choices <- renderUI({
    d<-theData()
    if(input$run!=0){ #if cluster button was hit, add cluster column to data
      d<-theData()
      d<-cbind(clusterFit()$cluster,d)
    }
  return(chooserInput("mychooser","Available","Selected",colnames(d),c(),size=15,multiple = TRUE))
  })
  
  output$pcplot <- renderParcoords({
    d<-theData()
    if(input$run!=0){ #if cluster button was hit, add cluster column to data (there has to be a cleaner way to do this)
      d<-cbind(clusterFit()$cluster,d)
      colNums <- match(input$mychooser$right,c("clusterFit()$cluster",names(d)))
    }
    colNums <- match(input$mychooser$right,names(d))
    #pipe data into plot
    d %>% 
      select(colNums) %>%
      parcoords(
        rownames = F # turn off rownames from the data.frame
        , brushMode = "1d-axes"
        , reorderable = T
        , queue = F
        , margin = list(left=2, right=10, top=30, bottom=30)
        , color = list(
          colorBy = input$selector2
          ,colorScale = htmlwidgets::JS("d3.scale.category10()")
        )
        ,width=input$slider2,height=input$slider1
      )
  })
  output$varselected <- renderUI(selectInput('selector2',label=NULL,input$mychooser$right,selectize=FALSE))
})