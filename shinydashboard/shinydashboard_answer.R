
library(shinydashboard)
library(shiny)
library(lattice)
library(shiny)
library(dplyr)
library(mrgsolve)

data(Theoph)

mod <- mread("popex", modlib())
# out <- 
#   mod %>% 
#   ev(amt=100,ii=24, addl=9) %>%
#   mrgsim(end=380, delta=0.1,Req="DV")



sel <- selectizeInput("subject", "Subject", 
                      multiple=TRUE, selected=1,
                      choices=unique(Theoph$Subject))

title <- textInput("title", "Plot title")

logy <- checkboxInput("logy", "Log Y scale")

vline <- numericInput("vert", "Vertical line", value=12)

nid <- numericInput("nid", "Number of subjects", value=1, min=1, max=100)

go <- actionButton("go", "Go")

# Add tabset, tabitem
# Add fluid row
theoplot <- box("Theo PK",plotOutput("plot1"), width=6)
theosum <- box("Theo Summary", tableOutput("table1"),width=6)

body <- dashboardBody(theoplot,theosum)
side <- dashboardSidebar(sel,title,logy,nid,go)
head <- dashboardHeader(title="PK Explorer")


ui <- dashboardPage(head,side,body,title="Model")


server <- shinyServer(function(input,output,session) {
  
  get_data <- reactive({
     filter(Theoph, Subject %in% input$subject)
  })
  
  get_data2 <- eventReactive(input$go, {
     get_data()
  })
  
  
  sim <- eventReactive(input$go, {
    mod %>%
      ev(amt=100, ii=24, addl=9) %>%
      Req(DV) %>%
      mrgsim(nid=input$nid, end=380,delta=0.5)
  })
  
  output$plot1 <- renderPlot({
    plot(sim(),main=input$title,scales=list(y=list(log=input$logy)))    
    # xyplot(conc~Time, 
    #        get_data2(), 
    #        group = Subject, 
    #        main=input$title,
    #        scales=list(y=list(log=input$logy)),
    #        type='b')
  })

  output$table1 <- renderTable({
    Theoph %>% 
      filter(Subject %in% input$subject & Time > 0) %>%
      group_by(Subject) %>%
      summarise(Min = min(conc), Max = max(conc), Mean=mean(conc))
  })
  
})

app <- shinyApp(ui,server)

runApp(app)
