
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
  
  ## ft table
  ftable <- reactive({
    
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
    
    # Create ft table
    ft.df = data.frame(matrix(
      NA,
      ncol = length(marchas) * 2 + 1,
      nrow = length(rotacoes)))
    
    ## put velocity values every odd collumn, skpping the first 
    ft.df[seq(2, length(marchas) * 2 + 1, 2)] = velocity.df[2:length(marchas) + 1]
    
    ## create a name vector 
    ftcol = paste("Ft",seq(1:length(marchas)))
    ## put name vector for the collumn names, intercalating ftcol and marchas names
    colnames(ft.df) = c("Potencia",rbind(marchas,ftcol))
    
    ## put first collumn potencias
    ft.df[1] = potencias
    
    ## put ft values every even number
    
    ft = function(v,p,efi) (efi* 3.6 * v/p)
    ##first create ft matrix
    ft.matrix = matrix(NA,ncol=length(marchas),nrow=length(potencias))
    
    for(i in 1:length(marchas)){
      ft.matrix[i] = velocity.df[i]*potencias[i]*3.6/input$efi
    }
    
    
   
    
    ft.matrix
    
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

  output$distPlot <- renderPlotly({
     
    # RESISTENCIAS
    
    ## ROLAMENTO
    rr = function(x)
      (input$c1 + (input$c2 * x))* input$gL
    
    
    ## AERODINAMICA
    ra = function(x)
      (input$ca * x ^ 2 * input$aL)
    
    ## RAMPA
    rg = (input$gL * 10 * input$i)
    
    layout_settings_x = list(
      title = " Velocidade [kmh]",
      dtick = 10,
      rangemode = "nonnegative"
    )
    
    layout_settings_y = list(
      title = " Forca [kN]",
      exponentformat = "E",
      dtick = 200,
      range = c(0, ftmax*1.2 )
    )
    
    
    plot_ly(data, x = ~ vel) %>%
      add_trace(y = ~ ft, mode = 'lines', type='scatter', name = "Forca Motriz") %>%
      add_trace(y = ~ rt, mode = 'lines', type='scatter', name = "Resistencia total ") %>%
      
      add_trace(x = vel_lim, y = ftmax, name = "Limite aderencia",
                mode = "lines", type='scatter',
                line = list(dash='dash')) %>%
      
      add_trace(x = input$vmax, y = c(0,ftmax), name = "Limite velocidade",
                mode = "lines",type='scatter',
                line = list(dash='dash')) %>%
      # add_trace(x = c(0,110), y = c(800,800),name = "Limite Corrente Eletrica",
      #           mode = "lines", type='scatter') %>%
      
      layout(title = " Forca x Velocidade",
             xaxis = layout_settings_x,
             yaxis = layout_settings_y,
             legend = list(orientation = 'h'))
    
   })
  
  output$vTable <- renderTable({
    
    vtable = vtable()
    
  })
  
  output$fTable <- renderTable({
    
    ftable = ftable()
    
  })
  
  output$sTable <- renderTable({
    
    stable = stable()
    
    },
    include.colnames=FALSE)

})
