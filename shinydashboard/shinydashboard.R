
library(shinydashboard)
library(shiny)
library(lattice)
library(shiny)

data(Theoph)

select <- selectizeInput("Subject", "Select Subject", 
                         choices=seq(1,12), selected=1, multiple=TRUE)

m1 <- menuItem("Plot",  select)

# Add tabset, tabitem
# Add fluid row
theoplot <- box("Theo PK",plotOutput("plot1"), width=6)

body <- dashboardBody(theoplot)
side <- dashboardSidebar(sidebarMenu(m1))
head <- dashboardHeader(title="Title")


ui <- dashboardPage(head,side,body,title="Model")


server <- shinyServer(function(input,output,session) {
  
  do_something <- reactive({
     # Filter the data set
  })
  
  do_something_else <- eventReactive(input$foo, {
    
  })
  
  output$plot1 <- renderPlot({
    xyplot(conc~Time, Theoph, 
           subset = Subject %in% input$Subject,
           group = Subject, type='b')
  })
  
  output$plot2 <- renderPlot({
    xyplot(conc~Wt, Theoph)
  })
  
  
  output$table1 <- renderTable({
    print(filter(Theoph, Subject %in% input$Subject))
  })
  
})

app <- shinyApp(ui,server)

runApp(app)
