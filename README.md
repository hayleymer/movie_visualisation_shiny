# IMDB Movie Trends Dashboard

<img width="2461" height="1313" alt="screenshot" src="https://github.com/user-attachments/assets/4e5c2457-54c8-401c-8f25-8623356d498b" />

## Business Problem

Film production trends evolve over time due to technological advancement, industry investment, and global market expansion. Understanding long-term trends in film runtime, production budgets, and language distribution provides valuable insight into industry growth, production scale, and content diversification.

However, static charts limit the ability to explore complex relationships across multiple variables and time periods.

This project develops an interactive dashboard that allows users to dynamically explore global film production trends using IMDB metadata.

The objective is to transform raw movie metadata into an interactive analytical tool that supports real-time exploration of runtime trends, budget growth, and language distribution across nearly a century of film production.

---

## Dataset

The dataset contains IMDB movie metadata spanning 1918–2017, including:

- Film release dates  
- Production budgets  
- Runtime duration  
- Original language  
- Movie titles and metadata  

### Key variables used

- Release date  
- Runtime (minutes)  
- Budget  
- Original language  

### Engineered features

New analytical variables were created to support time-based analysis:

- Release year extracted from release date  
- Language grouping (English vs non-English)  
- Cleaned and filtered budget and runtime values  

Invalid or missing values were removed to ensure reliable visualisation.

---

## Approach

### Data Preparation

- Parsed and standardised release dates  
- Extracted release year for trend analysis  
- Cleaned runtime and budget values  
- Recoded language categories into interpretable groups  

### Visualisation Design

Interactive visualisations were built using Plotly to allow dynamic exploration.

Key visualisation features:

- Runtime vs release year scatter plot  
- Budget vs release year scatter plot  
- Colour grouping by language  
- Interactive hover tooltips showing movie details  
- Zoom, pan, and export functionality  

### Dashboard Development

The dashboard was built using Shiny and shinydashboard to enable interactive analysis.

Reactive components allow users to dynamically filter data by:

- Language  
- Release year range  
- Budget range  

This enables users to explore trends interactively rather than relying on static visualisations.

### Deployment

The dashboard was deployed using shinyapps.io, enabling public access via a web browser without requiring local installation.

---

## Results

The dashboard enables interactive exploration of film industry trends over nearly 100 years.

Key capabilities include:

- Visualising how film runtimes have evolved over time  
- Exploring growth in production budgets across decades  
- Comparing English and non-English film production patterns  
- Identifying outliers and structural trends  

The interactive design allows users to dynamically investigate relationships between production scale, time, and language.

---

## Key Findings

Exploratory analysis revealed several structural industry trends:

- Film production budgets have increased significantly over time  
- Runtime duration shows gradual stabilisation after early variation  
- English-language films dominate production volume  
- High-budget films have become more common in recent decades  

These findings reflect the expansion and commercialisation of global film production.

---

## Tech Stack

R  
shiny  
shinydashboard  
plotly  
dplyr  

### Analytical and Visualisation Techniques

- Data cleaning and preprocessing  
- Feature engineering  
- Interactive visualisation  
- Dashboard development  
- Reactive filtering and user-driven exploration  

---

## How to Run

### Run locally in R

Open the project in RStudio and run:

```r
shiny::runApp()
```

### View deployed dashboard

Live application available at:

https://yvjrbk-hayley-merat.shinyapps.io/Assessment3/

No installation required for online access.
