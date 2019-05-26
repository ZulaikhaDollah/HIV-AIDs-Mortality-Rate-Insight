# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    dataset_df <- switch(input$var, 
                         "Gender" = Gender_df,
                         "Age" = AgeGroup_df,
                         "Occupation" = Occupation_df,
                         "Risk Factor" = RiskFactor_df,
                         "State" = State_df)
    
    if(input$var == "Gender"){
      ggplot(data=dataset_df, aes(x=Year, y=MortRate, group=gender)) +
        geom_line(aes(color=gender))+
        geom_point()
    }else if(input$var == "Age"){
      ggplot(data=dataset_df, aes(x=Year, y=MortRate, group=Age)) +
        geom_line(aes(color=Age))+
        geom_point()
    }else if(input$var == "Occupation"){
      ggplot(data=dataset_df, aes(x=Year, y=MortRate, group=JobStatus)) +
        geom_line(aes(color=JobStatus))+
        geom_point()
    }else if(input$var == "Risk Factor"){
      ggplot(data=dataset_df, aes(x=Year, y=MortRate, group=Factor)) +
        geom_line(aes(color=Factor))+
        geom_point()
    }else if(input$var == "State"){
      ggplot(data=dataset_df, aes(x=Year, y=MortRate, group=State)) +
        geom_line(aes(color=State))+
        geom_point()
    }
    
    
  })
  
  output$map <- renderPlot({
    data <- paste("Y",input$year,sep="")
    
    dsn <- paste(getwd(),"/data",sep="")
    shapefile <- readOGR(dsn=dsn, layer="Malaysiapoly17")
    percent_map(shapefile, data)
  })
  
  output$selected_year <- renderText({ 
    paste("Year Selected ", input$year)
  })
  
  output$selected_var <- renderText({ 
    paste("Mortal Rate Vs ", input$var)
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
