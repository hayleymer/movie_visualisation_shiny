IMDB Movie Trends Dashboard

An interactive data exploration dashboard built with R Shiny and Plotly, analysing long-term trends in global film production using IMDB metadata (1918–2017).

This project demonstrates end-to-end workflow skills: data cleaning, feature engineering, interactive visualisation design, and deployment.

Project Objective

The goal of this project was to transform raw movie metadata into an interactive tool that enables users to explore:

How film runtimes have evolved over a century

Growth in production budgets over time

Differences between English and non-English films

Patterns across release years and budget ranges

Rather than presenting static charts, the dashboard supports real-time filtering and exploration to allow users to investigate trends dynamically.

Technical Implementation
Data Preparation

Parsed and standardised release dates

Engineered new features (release year, language grouping)

Filtered invalid runtime and budget values

Recoded language codes into readable categories

Visualisation Design

Interactive scatter plots using plotly

Language grouping with consistent colour mapping

Hover tooltips with contextual movie metadata

Zoom and export functionality

Reactive filtering logic for dynamic data exploration

Deployment

Built using shiny and shinydashboard

Deployed via shinyapps.io

Key Features
Movie Runtime Explorer

Visualises runtime vs release year to identify trends and outliers in film duration over time.

Movie Budget Explorer

Displays budget growth across decades, highlighting the expansion of production scale.

Interactive Movie Database

Filterable data table allowing users to subset films by:

Original language

Year range

Budget range

Live Application

https://yvjrbk-hayley-merat.shinyapps.io/Assessment3/

Data Source

Banik, R. (2017). The Movie Dataset. Kaggle

Internet Movie Database (IMDB)

Limitations & Future Enhancements

Budgets are not adjusted for inflation.

Analysis is exploratory rather than model-driven.

Future improvements could include inflation normalisation and trend modelling to strengthen economic comparisons across decades.
