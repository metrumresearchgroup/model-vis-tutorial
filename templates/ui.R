
library(shinydashboard)
library(shiny)

slide <- sliderInput("slide", "Slider", min=0,max=100,step=1,value=50)
text <-  textInput("text", "Text")
select <- selectizeInput("Subject", "Select Subject", choices=seq(1,12), selected=1, multiple=TRUE)
dt <- dateInput("date", "Date")
num <- numericInput("numeric", "Numeric", min=0, max=100, value=50)
action <- actionButton("action", "Action")
check <- checkboxInput("yes", "Yes")
checkg <- checkboxGroupInput("yesg", "Yes Group", choices=c(1,2,3,4), selected=c(2,4))
radio <- radioButtons("radio", "Radio", choices=c(1,2,3,4), selected=2)

m1 <- menuItem("Pick", slide,text,select,dt,num,action,check,checkg,radio)

tab1 <- tabPanel("Theoph plot", box(title="The plot",  plotOutput("plot1")))
tab2 <- tabPanel("Theoph data", tableOutput("table1"))
tabset <- tabsetPanel(tab1,tab2)

body <- dashboardBody(tabset)
side <- dashboardSidebar(sidebarMenu(title="Please pick",m1))
head <- dashboardHeader(title="Title")

dashboardPage(head,side,body,title="Model")


