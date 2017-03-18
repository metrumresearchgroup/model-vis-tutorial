library(shiny)
library(lattice)

data(Theoph)

shinyServer(function(input,output,session) {
  
  do_something <- reactive({
    
  })
  
  do_something_else <- eventReactive(input$foo, {
    
  })
  
  output$plot1 <- renderPlot({
    xyplot(conc~Time, Theoph, group = Subject, type='b',
           subset=Subject %in% input$Subject)
  })
  
  output$table1 <- renderTable({
    print(Theoph)
  })

})



