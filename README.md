# README

  

This is the API only version of the application. The front end is a separate repository. The front end repository can be found [[here](https://github.com/jteixeira00/weather-app-frontend)]

  

This project represents a weather API built using Ruby on Rails, providing endpoints to fetch historical weather data for specific locations in a determined time period. The data served originates from [[Open-Meteo](https://open-meteo.com/en/docs/historical-weather-api)], with the help of a local database that prevents the need to perform repeated API calls to the remote server.

  

# Weather App 🌦️

  

## Features

  

+ Historical weather data for a specific location (latitude and longitude) and date range
+ Storage of the results in a database
+ Serves historical weather data through JSON (both per day and per hour for a given day)
+ Possibility for separate databases
+ Several types of data display


## Prerequisites
Ensure you have the following installed: 
- **Ruby** (version >= 3.0) 
- **Rails** (version >= 7.0)

## Installation

+ Clone the repository
+   Install dependencies with `bundle install`
+ Initialize the database with `rails db:create db:migrate`
+ Launch the server with `rails server`


## Usage

### Endpoints

#### Multi Day Weather Data
Retrieves the daily weather data for a time interval:

    GET /weathers?latitude=<latitude>&longitude=<longitude>&start_date=<start_date>&end_date=<end_date>
 
 + `latitude` and `longitude`: Coordinates for the location
 + `start_date` and `end_date`: Date range for the requested weather data (YYYY-MM-DD format)
#### Example:

    GET /weathers?latitude=41.1494512&longitude=-8.6107884&start_date=2024-11-04&end_date=2024-11-06

 #### Hourly Data
Retrieves the hourly data for a specific day:

    GET /hourly_weather?latitude=<latitude>&longitude=<longitude>&date=<start_date>

 + `latitude` and `longitude`: Coordinates for the location
 + `date`: Date for the requested weather data (YYYY-MM-DD format)

#### Example:

    GET /hourly_weather?latitude=40.2056&longitude=-8.4195&date=2024-11-02


