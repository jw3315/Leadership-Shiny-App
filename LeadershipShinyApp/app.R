library(shiny)
library(readxl)
library(DT)
library(rsconnect)
LOC <- read_excel("data/LOC.xlsx")
Weight <- read_excel("data/Weight.xlsx")
w=as.matrix(Weight[,2:6])

ui <- navbarPage(
  title = 'Leadership Potential Model',
  tabPanel('Leaderhip Score',
           sidebarPanel(
              selectInput("Results","Results Orientation", choices = LOC$Results,multiple = TRUE,selected = LOC$Results[1:3]),
              selectInput("Strategic","Strategic Orientation", choices = LOC$Strategic,multiple = TRUE,selected = LOC$Strategic[1:3]),
              selectInput("Collaboration","Collaboration and Influence Orientation", choices = LOC$`Collaboration and Influence`,multiple = TRUE,selected = LOC$`Collaboration and Influence`[1:3]),
              selectInput("Team","Team Leadership Orientation", choices = LOC$`Team Leadership`,multiple = TRUE,selected = LOC$`Team Leadership`[1:3]),
              selectInput("Developing","Developing Organizational Capabilities Orientation", choices = LOC$`Developing Organizational Capabilities`,multiple = TRUE,selected = LOC$`Developing Organizational Capabilities`[1:3]),
              selectInput("Change","Change Leadership Orientation", choices = LOC$`Change Leadership`,multiple = TRUE,selected = LOC$`Change Leadership`[1:3]),
              selectInput("Market","Market Understanding Orientation", choices = LOC$`Market Understanding`,multiple = TRUE,selected = LOC$`Market Understanding`[1:3]),
              selectInput("Inclusiveness","Inclusiveness Orientation", choices = LOC$Inclusiveness,multiple = TRUE,selected = LOC$Inclusiveness[1:3])
           ),
           mainPanel(
             # tabsetPanel(
               tabPanel("Level of Competence", dataTableOutput("mytable1")),
               tabPanel("Score of Leadership", dataTableOutput("mytable2")),
               verbatimTextOutput("txtout")
             # )
           )
  )
              
)


server <- function(input, output) {
  score <-reactive({c(length(input$Results),
            length(input$Strategic),
            length(input$Collaboration),
            length(input$Team),
            length(input$Developing),
            length(input$Change),
            length(input$Market),
            length(input$Inclusiveness))})
  
  diff<-function(p){
    # p=as.matrix(Simulation[1,2:6])
    # w=as.matrix(Weight[,2:6])  ## this is known
    realLOC=matrix(score(),nrow=1)
    # sum(sapply(c(p%*%t(w)-realLOC),abs))
    sum(sapply(c(p%*%t(w)-realLOC),function(x) x^2))
    # sum(c(p%*%t(w)-realLOC))
  }
  
  result=reactive({constrOptim(rep(7,5), f=diff, grad=NULL,
                               ui = rbind(diag(1,5,5),diag(-1,5,5),w), 
                               ci = c(rep(1-1e-04,5),rep(-7-1e-04,5),score()-1e-10),outer.eps=0)$par})
  

  # result=reactive({round(constrOptim(rep(7,5), f=diff, grad=NULL,
  #                                    ui = rbind(diag(1,5,5),diag(-1,5,5),w), 
  #                                    ci = c(rep(0,5),rep(-7-1e-04,5),c(length(input$Results),
  #                                                                length(input$Strategic),
  #                                                                length(input$Collaboration),
  #                                                                length(input$Team),
  #                                                                length(input$Developing),
  #                                                                length(input$Change),
  #                                                                length(input$Market),
  #                                                                length(input$Inclusiveness))))$par,1)})
  # result=reactive({constrOptim(rep(7,5), 
  #                              f=diff, 
  #                              grad=NULL,
  #                              ui = as.matrix(rbind(diag(1,5,5),w)), 
  #                              ci = c(rep(0,5),c(length(input$Results),
  #                                                length(input$Strategic),
  #                                                length(input$Collaboration),
  #                                                length(input$Team),
  #                                                length(input$Developing),
  #                                                length(input$Change),
  #                                                length(input$Market),
  #                                                length(input$Inclusiveness))
                                      # ))})
  # round(result%*%t(w),1)-realLOC
  
  output$mytable1<-renderDataTable(
    data.frame(orientation=names(LOC),
               realLOC=score(),
               predLOC=c(round(result()%*%t(w),1))),
    caption= 'Level of Competence'
                )
  output$mytable2<-renderDataTable(
    data.frame(leadershipPredictor=names(Weight[2:6]),
               num=round(result(),1)),
    caption= 'Score of Leadership'
  )
  
  output$txtout<-renderText(
    paste('Leadership Potential Score:', round(result()%*%c(0.1,0.15,0.2,0.25,0.3),2)))
  }



shinyApp(ui = ui, server = server)
