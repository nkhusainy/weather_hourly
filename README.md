# European Capital Weather History Shiny App

This repository contains a Shiny application that visualizes the history of hourly weather conditions
for selected European capital cities, for the past year (1st January 2025 to 8th January 2026).

The app allows users to explore how temperature, apparent temperature, wind speed,
and snowfall vary throughout the day for a chosen city and date.

## App Functionality

The Shiny app provides:
- Selection of a European capital city
- Selection of a date
- Hourly visualizations of:
  - Temperature (°C)
  - Apparent temperature (°C)
  - Wind speed (m/s)
  - Snowfall (cm)
  - Snow depth (m)

## Data Source

Weather data were obtained from the **Open-Meteo** open weather API:
https://open-meteo.com/

Hourly weather data were downloaded in advance and stored locally as a CSV file
to ensure reproducibility and offline execution of the app.

## Repository Structure

- `app.R` — Shiny application code
- `data/weather_hourly.csv` — Pre-downloaded hourly weather data
- `README.md` — Project documentation
- `CITATION.cff` — Citation information including Zenodo DOI

## How to Run the App

1. Clone this repository
2. Open the project in RStudio
3. Run the app using:

```r
shiny::runApp()
