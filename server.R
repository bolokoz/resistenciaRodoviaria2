
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(plotly)

shinyServer(function(input, output) {
  
  #Velocidity table
  vtable <- reactive({
    
    # DADOS
    
    reducoes = unlist(strsplit(input$reducoes,","))
    rotacoes = unlist(strsplit(input$rotacoes,","))
    potencias = unlist(strsplit(input$potencias,","))
    marchas = seq(input$n_marchas)
    
    # VELOCIDADE
    
    v = function(N,gt)
      ((60* N * 3.1415 * input$d) / (1000 * input$gd * gt))
    
    # Create velocity table
    
    velocity.df = data.frame(rotacoes)

    
  })
  
  ## shifts table
  stable <- reactive({
    
    # DADOS
    
    reducoes = unlist(strsplit(input$reducoes,","))
    rotacoes = unlist(strsplit(input$rotacoes,","))
    potencias = unlist(strsplit(input$potencias,","))
    marchas = seq(input$n_marchas)
    
    
    # Create shift table
    
    shift.df = rbind.data.frame(marchas)
    rbind(shift.df,reducoes)
    
  })

  # output$distPlot <- renderPlotly({
  #   
  # })
  
  output$vTable <- renderTable({
    
    vtable = vtable()
    
  })
  
  output$sTable <- renderTable({
    
    stable = stable()
    
    })

})
