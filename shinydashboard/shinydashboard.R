
library(shinydashboard)
library(shiny)
library(lattice)
library(shiny)

data(Theoph)


# Add tabset, tabitem
# Add fluid row
theoplot <- box("Theo PK",plotOutput("plot1"), width=6)

body <- dashboardBody(theoplot)
side <- dashboardSidebar()
head <- dashboardHeader(title="Theoph Explorer")


ui <- dashboardPage(head,side,body,title="Model")


server <- shinyServer(function(input,output,session) {
  
  output$plot1 <- renderPlot({
    xyplot(conc~Time, 
           Theoph,
           main="Theoph data set",
           subset = Subject %in% Theoph$Subject,
           group = Subject, 
           type='b')
  })
  
})

app <- shinyApp(ui,server)

runApp(app)
