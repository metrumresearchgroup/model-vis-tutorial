
library(shinydashboard)
library(shiny)
library(lattice)
data(Theoph)

select <- selectizeInput("Subject", "Select Subject", 
                         choices=seq(1,12), selected=1, multiple=TRUE)

m1 <- menuItem("Pick", select, maxt)

theoplot <- box("Theo PK",plotOutput("plot1"), width=4)
body <- dashboardBody(theoplot)

side <- dashboardSidebar(sidebarMenu(title="Please pick",m1))
head <- dashboardHeader(title="Title")

ui <- dashboardPage(head,side,body,title="Model")

server <- shinyServer(function(input,output,session) {
  
  do_something <- reactive({
     filter(Theoph, Subject %in% input$Subject)
  })
  
  do_something_else <- eventReactive(input$foo, {
    
  })
  
  output$plot1 <- renderPlot({
    data <- do_something()
    xyplot(conc~Time, data, group = Subject, type='b')
  })
  
  output$table1 <- renderTable({
    print(filter(Theoph, Subject %in% input$Subject))
  })
  
})

app <- shinyApp(ui,server)

runApp(app)
