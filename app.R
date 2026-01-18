#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

ui <- fluidPage(
  titlePanel("European Capital Weather History Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("city", "Choose a city:",
                  choices = c("Berlin", "Amsterdam", "Paris", "Stockholm", "Vienna", "Rome")),
      dateInput("date", "Select a date:",
                min = as.Date("2025-01-01"),
                max = as.Date("2026-01-08"),
                value = as.Date("2025-01-01")
      )
    ),
    mainPanel(
      plotOutput("weatherPlot"),
      tableOutput("summaryTable")
    )
  )
)

server <- function(input, output, session) {
  library(dplyr)
  library(lubridate)

  # Load data once
  weather_data <- read.csv("data/weather_hourly.csv", stringsAsFactors = FALSE)

  # Clean column names
  colnames(weather_data) <- c("location_id", "city", "time", "temperature_C",
                              "snowfall_cm", "snow_depth_m",
                              "apparent_temperature_C", "wind_speed_kmh")

  # Convert time to POSIXct
  weather_data$time <- ymd_hm(weather_data$time)
  weather_data$date <- as.Date(weather_data$time)
  weather_data$hour <- hour(weather_data$time)

  # Reactive filtered data
  filtered_data <- reactive({
    weather_data %>%
      filter(city == input$city,
             date == input$date)
  })

  library(ggplot2)

  output$weatherPlot <- renderPlot({
    df <- filtered_data()
    ggplot(df, aes(x = hour)) +
      geom_line(aes(y = temperature_C, color = "Temperature")) +
      geom_line(aes(y = apparent_temperature_C, color = "Apparent Temperature")) +
      geom_line(aes(y = wind_speed_kmh/2, color = "Wind speed (scaled)")) +
      geom_line(aes(y = snowfall_cm*2, color = "Snowfall (scaled)")) +
      labs(x = "Hour", y = "Value", color = "Variable") +
      theme_minimal()
  })

  output$summaryTable <- renderTable({
    df <- filtered_data()
    if(nrow(df) == 0) return(NULL)
    data.frame(
      Min_Temperature = min(df$temperature_C),
      Max_Temperature = max(df$temperature_C),
      Avg_Wind_kmh = round(mean(df$wind_speed_kmh), 1),
      Total_Snowfall_cm = sum(df$snowfall_cm)
    )
  })


}

shinyApp(ui, server)
