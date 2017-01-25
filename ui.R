
#
#    http://shiny.rstudio.com/
#asdasd

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # Application title
  titlePanel("Resistencia Rodoviaria"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(sidebarPanel(
    tabsetPanel(
      tabPanel(
        "Veiculo",
        numericInput(
          "gL",
          "Peso [kg]:",
          min = 0,
          max = 500000,
          value = 6300
        ),
        numericInput(
          "P",
          "Potencia maxima [kW]:",
          min = 0,
          max = 90000,
          value = 110
        ),
        sliderInput(
          "Potencia utilizada [%]",
          min = 0,
          max = 100,
          step = 1,
          value = 100,
          inputId = "cP"
        ),
        numericInput(
          "c1",
          "c1:",
          min = 0,
          max = 90000,
          value = 0.65
        ),
        numericInput(
          "c2",
          "c2:",
          min = 0,
          max = 90000,
          value = 125
        ),
        numericInput(
          "aL",
          "Area frontal [m2]",
          min = 0,
          max = 50,
          value = 10
        ),
        numericInput(
          "ca",
          "ca:",
          min = 0,
          max = 90000,
          value = 0.046
        )
      ),
      
      tabPanel(
        "Rampa",
        numericInput(
          "i",
          "Inclininacao da rampa:",
          min = -50,
          max = 50,
          value = 0,
          step = 0.05
        )
      ),
      tabPanel(
        "Velocidade",
        numericInput(
          "vmax",
          "Velocidade maxima:",
          min = 0,
          max = 9000,
          value = 105
        ),
        numericInput(
          "vmin",
          "Velocidade minima:",
          min = 0,
          max = 5000,
          value = 15
        )
      )
    )
  ),
  # Show a plot of the generated distribution
  mainPanel(
    plotlyOutput("distPlot"),
    tableOutput("table"),
    textOutput("ft"),
    textOutput("rt"),
    hr(),
    h3(
      a(href="http://yuribecker.com.br","yuribecker.com.br")
    )
  ))
))
