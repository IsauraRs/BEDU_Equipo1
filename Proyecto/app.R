library(shiny)
library(shinydashboard)
library(shinythemes)
dataset <- read.csv("dataset.csv", header = TRUE)
ui <-

    fluidPage(

        dashboardPage(
            dashboardHeader(title = "Enfermedades coronarias"),

            dashboardSidebar(

                sidebarMenu(
                    menuItem("Histograma", tabName = "Dashboard", icon = icon("dashboard")),
                    menuItem("Dispersión", tabName = "Scatter", icon = icon("area-chart")),
                    menuItem("Data Table", tabName = "DataTable", icon = icon("table")),
                    menuItem("Suposiciones", tabName = "Assumptions", icon = icon("area-chart"))

                )
            ),
            dashboardBody(
                tabItems(
                    tabItem(tabName = "Dashboard",
                        fluidRow(
                            titlePanel("Histogramas correspondientes a las variables del dataset para enfermedades coronarias."),
                            selectInput("x","Seleccione el valor de X",
                            choices = names(dataset)),
                            box(plotOutput("plot1", height = 300)),
                            box(
                                title = "Control",
                                sliderInput("bins", "Observaciones",10,50,100)
                            )
                        )
                        
                    ),

                    tabItem(tabName = "Scatter",
                        fluidRow(
                            titlePanel(h3("Gráficos de dispersión")),
                            selectInput("x1", "Seleccione el valor de x",
                            choices = names(dataset)),
                            selectInput("y1", "Seleccione el valor de y",
                            choices = names(dataset)),
                            box(plotOutput("output_plot", height = 300, width = 460))

                        )
                    
                    ),

                    tabItem(tabName = "DataTable",
                        fluidRow(
                            titlePanel(h3("Data Table")),
                            dataTableOutput("DataTable")
                        )
                    ),

                    tabItem(tabName = "Assumptions",
                        fluidRow(
                            titlePanel(h3("Suposiciones basadas en gráficas")),
                            selectInput("x3", "Seleccione el gráfico",
                            choices = c("Hipertensos vs Presión sistólica", "Presión sistólica vs Derrame", "Derrame vs glucosa","Edad vs Presión sistólica")),
                            box(plotOutput("Mplots", height = 300))
                        )
                    
                    )

                )
            )

        )
    )

    server <- function(input, output){
        library(ggplot2)
        output$plot1 <- renderPlot({
            x <- dataset[,input$x]
            bin <- seq(min(x), max(x), length.out = input$bins + 1)
            ggplot(dataset,aes(x))+
            geom_histogram( breaks = bin)+
            labs( xlim = c(0, max(x)))+
            theme_light()+
            xlab(input$x) + ylab("Frecuencia")
        })

        output$output_plot <- renderPlot({
            ggplot(dataset, aes(x = dataset[,input$x1], y = dataset[,input$y1]))+
            geom_point()+
            ylab(input$y1)+
            xlab(input$x1)+
            theme_linedraw()
        })
        output$DataTable<- renderDataTable({dataset},
                                            options = list(aLengthMenu = c(10,20,30,40,50,100,110,120,150,200,210,220,250),
                                            iDisplayLength = 5)
        )

        output$Mplots <- renderPlot({
            switch(input$x3,
            "Hipertensos vs Presión sistólica" = ggplot(dataset, aes(x = prevalentHyp, y = sysBP))+ geom_point() +ggtitle("Los pacientes hipertensos han sufrido un derrame"),
            "Presión sistólica vs Derrame" = ggplot(dataset, aes(x = prevalentStroke, y = sysBP))+ geom_point()+ggtitle("Pacientes con presión sistólica baja han sufrido un derrame"),
            "Derrame vs glucosa" = ggplot(dataset, aes(x = prevalentStroke, y = glucose))+ geom_point()+ggtitle("Los pacientes que han tenido un derrame no tienen niveles altos de glucosa"),
            "Edad vs Presión sistólica" = ggplot(dataset, aes(x = age, y = sysBP))+ geom_point()+ggtitle("Pacientes con 45 o más años tienen presión sistólica alta")
            )
    
        })

    }

shinyApp(ui,server)