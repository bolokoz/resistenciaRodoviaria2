
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
    
    reducoes = as.numeric(unlist(strsplit(input$reducoes,",")))
    rotacoes = as.numeric(unlist(strsplit(input$rotacoes,",")))
    potencias = as.numeric(unlist(strsplit(input$potencias,",")))
    marchas = seq(as.numeric(input$n_marchas))
    
    # VELOCIDADE
    
    v = function(N,gt)
      ((60* N * 3.1415 * input$d) / (1000 * input$gd * gt))
    
    
    # Create velocity table
    
    velocity.df = data.frame(matrix(NA, ncol = length(marchas) + 1, nrow = length(rotacoes)))
    colnames(velocity.df) = c("Rotacoes", marchas)
    
    velocity.df[1] = rotacoes
    velocity.df[1,1:length(marchas) + 1] = v(rotacoes[1],reducoes)
    
    for(i in 1:length(rotacoes)){
      
      velocity.df[i,1:length(marchas) + 1] = v(rotacoes[i],reducoes)
    }
    
    velocity.df
    
    
  })
  
  ## shifts table
  stable <- reactive({
    
    # DADOS
    
    reducoes = unlist(strsplit(input$reducoes,","))
    rotacoes = unlist(strsplit(input$rotacoes,","))
    potencias = unlist(strsplit(input$potencias,","))
    marchas = seq(as.numeric(input$n_marchas))
    
    
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
    
    },
    include.colnames=FALSE)

})
