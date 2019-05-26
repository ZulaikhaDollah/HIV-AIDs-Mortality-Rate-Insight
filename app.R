library(shiny)
library(rgdal)     # R wrapper around GDAL/OGR
library(ggplot2)   # for general plotting
library(ggmap)    # for fortifying shapefiles
library(dplyr)
library(maptools)

State_df <-read.csv("https://raw.githubusercontent.com/ZulaikhaDollah/HIV-AIDs-Dataset/master/State.csv", header=T, sep = ",")
Gender_df <-read.csv("https://raw.githubusercontent.com/ZulaikhaDollah/HIV-AIDs-Dataset/master/Gender.csv", header=T, sep = ",")
AgeGroup_df <-read.csv("https://raw.githubusercontent.com/ZulaikhaDollah/HIV-AIDs-Dataset/master/AgeGroup.csv", header=T, sep = ",")
Occupation_df <-read.csv("https://raw.githubusercontent.com/ZulaikhaDollah/HIV-AIDs-Dataset/master/Occupation.csv", header=T, sep = ",")
RiskFactor_df <-read.csv("https://raw.githubusercontent.com/ZulaikhaDollah/HIV-AIDs-Dataset/master/RiskFactor.csv", header=T, sep = ",")

# Source helper functions -----
source("helpers.R")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("HIV/AIDs Mortality Rate Insight in Malaysia"),
  
  tabsetPanel(
    tabPanel("Map",
       sidebarLayout(
         sidebarPanel(
           
           selectInput("year", 
                       label = "Choose a year to display",
                       choices = c(1990:2014),
                       selected = "2014")
           ),
         mainPanel(
           textOutput("selected_year"),
           #output Map malaysia
           plotOutput(outputId = "map")
         )
       )         
    ),
    tabPanel(
      "Plot",
      # Sidebar layout with input and output definitions ----
      sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
          
          selectInput("var", 
                      label = "Mortal Rate Vs ",
                      choices = c("State",
                                  "Gender", 
                                  "Age",
                                  "Occupation", 
                                  "Risk Factor"),
                      selected = "Gender")
          
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
          
          h3("From year 1986 to 2014"),
          textOutput("selected_var"),
          
          # Output: Histogram ----
          plotOutput(outputId = "distPlot")
          
        )
      )
    )
    
  )
)

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
