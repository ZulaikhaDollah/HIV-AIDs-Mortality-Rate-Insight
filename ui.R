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
