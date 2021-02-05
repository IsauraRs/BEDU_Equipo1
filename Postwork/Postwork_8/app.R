library(shiny)
library(ggplot2)

match.data <- read.csv("match.data.csv")

ui <- fluidPage(

    titlePanel("Postwork 8"),
    
        mainPanel(
            tabsetPanel(
                tabPanel("Score plots",
                         sidebarPanel( 
                             selectInput("x", "Seleccione el valor de X",
                                choices = c("away.score","home.score")
                )),plotOutput("output_plot")),
                tabPanel("Score probabilities",
                         h4("Home team score probabilities"),img( src = "plot3.png",height=355,width=680),
                         h4("Away team score probabilities"),img( src = "plot4.png",height=355,width=680),
                         h4("Score combinations probabilities"),img( src = "heatmap1.png",height=355,width=680)),
                tabPanel("Data Table", dataTableOutput("data_table")),
                tabPanel("Max/min gains",
                         h4("Min gains"),img( src = "plot2.png",height=355,width=680),
                         h4("Max gains"),img( src = "plot1.png",height=355,width=680),)
                )
            )
        )

server <- function(input, output) {
    
    output$data_table <- renderDataTable( {match.data}
                                          )
    output$output_plot <- renderPlot(ggplot(match.data,aes(x=match.data[,input$x])) +
                                  geom_bar()+
                                      facet_wrap("away.score")+
                                      xlab(input$x)
                                      )
}
shinyApp(ui = ui, server = server)
