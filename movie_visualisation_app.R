library(shiny)
library(shinythemes)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(readxl)
library(ggvis)
library(dplyr)
library(lubridate)
library(htmltools)
library(dtplyr)


#import data

movies <- read_excel("./movies.xls")

movies$release_date <- as.Date(movies$release_date, format = "%d/%m/%Y")

movies <- movies  %>% 
  mutate(released = year(movies$release_date)) %>% 
  select(-c('imdb_id','overview', 'spoken_languages', 'release_date', 'production_companies', 'genres', 'production_countries')) %>% 
  filter(budget > 90000, runtime!=0)  %>% 
  mutate(original_language = recode(original_language, 'bm' = 'Belgium', 'bs' = 'Bosnian', 'ca' = 'Catalan', 'cn' = 'Chinese', 'cs' = 'Czech', 'dn' = 'Danish', 'da' = 'Danish', 'de' = 'German', 'en' = 'English', 'es' = 'Spanish', 'fi' = 'Finnish', 'fr' = 'French', 'hi' = 'Hindi', 'hu' = 'Hungarian', 'id' = 'Indonesian', 'it' = 'Italian', 'ja' = 'Japanese', 'ko' = 'Korean', 'nl' = 'Dutch', 'no' = 'Norwegian', 'nb' = 'Norwegian', 'pl' = 'Polish', 'pt' = 'Portuguese', 'ru' = 'Russian', 'sl' = 'Slovenian', 'sr' = 'Serbian', 'sv' = 'Swedish', 'ta' = 'Tamil', 'te' = 'Telugu', 'th' = 'Thai', 'uk' = 'Ukrainian', 'zh' = 'Chinese')) %>%
  mutate(language_group = if_else(original_language == "English", "English", "Foreign"))


# Define UI for application 
ui <- 
  fluidPage(
  theme = shinytheme("united"),
  dashboardBody(
  
  # App title and introduction text above tabs
  titlePanel(strong("IMDB - Movies")),
  h3("Introduction"),
  h5("The Internet Movie Database (IMDB) provides a source of information that allow users to gain insights into the production data of movies, both present and past. 
     The data sourced here contains metadata consisting of 45000 movies released before July 2017 gained from the IMDB website.
     Data points include year of release, runtime, budget, predominant language and movie title."), 
  h3("Interaction"),
  h5(("To navigate the data presented, use the"), strong("tab functions"), ("below.")),
  h5(em("Movie Lengths"), "- enables you to explore the increasing length of movies over time"),
  h5(em("Movie Budgets"), "- enables you to explore the increasing budgets of movies over time (not adjusted for inflation"), 
  h5(em("Movie Database"), "- enables you to explore the entire database categories. You can filter results based on Language, Runtime and Budget"),
 
  #set tabs and instructions for each tab
  tabsetPanel(type = "tabs",
              tabPanel("Movie Lengths", 
                       br(), 
                       h4(strong("Explore the Data")),
                       p(strong("1."), "Toggle the", strong("Language Group"), "to see English/Foreign movies only"),
                       p(strong("2."), "Hover over", strong("markers"), "to see information about individual movies"),
                       p(strong("3."), "Zoom in and out to get a closer look at years and lengths that interest you"),
                       br(),
                       plotlyOutput("lengthfig"),
                       h5(strong("Observations")),
                       p("By exploring this graph,it appears that even in the earlier days of cinema, long epics have been created to keep us glued to the screen for over 200 minutes. There appears to also be a slight trend upwards on the length of movies. This is evident for both English and Foreign language films. Notice the outliers of 'Carlos' in 2010, with a whopping 300 minute runtime. It might have you thinking - could it have been a mini-series?")
                       ),

              tabPanel("Movie Budgets", 
                       br(), 
                       h4(strong("Explore the Data")),
                       p(strong("1."), "Toggle the", strong("Language Group"), "to see English/Foreign movies only"),
                       p(strong("2."), "Hover over", strong("markers"), "to see information about individual movies"),
                       p(strong("3."), "Zoom in and out to get a closer look at years and budgets that interest you"),
                       br(),
                       plotlyOutput("budgetfig"),
                       h5(strong("Observations")),
                       p("By exploring this graph, you would be right in concluding that movies are increasing in number, and cost of production. 'The Pirates of the Caribbean' maxes out the movie budgets with a whopping $300million USD in 2007. Another interesting observation is the German film, 'Metropolis', made in 1927 for $92 million. Let's not forget the original film, 'Mickey' made by Disney in 1918 for a total cost of $250 thousand. This equates to $5 million. Still pretty reasonable compared to modern animation movies of today. Just look at Finding Dory, which was made for $200 million.")),
            
            
              tabPanel("Movie Database", 
                       br(),
                       h4(strong("Explore the Data")),
                       p(strong("1."), "Select the", strong("Original Language"), "drop down menu to explore different languages"),
                       p(strong("2."), "Slide the", strong("Range of Years Released"), "sliders to narrow your focus to specific time periods"),
                       p(strong("3."), "Slide the", strong("Range of Budgets"), "sliders to explore movies with the biggest and smallest budgets (inflation not factored)"),
                       br(),
                       
  #set reactive widgets for tab 3
              fluidRow(
                column(4, 
                       selectInput("p",label = "Original Language", 
                                choices = c(unique(as.character(movies$original_language)
                ))
                )
                ),
                column(4, 
                       sliderInput("q", 
                            label = "Range of Years Released:",
                            min = 1918, max = 2017, value = c(1918, 2017), 
                            sep = '')
                ),
                column(4,     
                sliderInput("r", 
                            label = "Range of Budgets:",
                            min = 0, max = max(movies$budget), value = c(min(movies$budget), max(movies$budget))
                ))),
  
  #insert dataframe for tab 3
              DT::dataTableOutput("table")
              ),
              br(),
              br(),
#reference source of data
              p(style="text-align: right;",
                em("Data Sourced from Banik, R. The Movie Dataset, Kaggle Website"))
              
  )
)
)



# Define server 
server <- function(input, output) {

  #render table reactive to slider and select widgets
  output$table <- DT::renderDataTable(DT::datatable({
    data <- movies %>%
    
    filter(
      released >= input$q[1],
      released <= input$q[2],
      budget >= input$r[1],
      budget <= input$r[2])
    
    if (input$p != "All") {
      data <- data[data$original_language == input$p,]
    }
  }))

  #use plotly to build interactive fig1 - length x year released
  output$lengthfig <- renderPlotly({
    
    length <- movies$runtime
    year <- movies$released
    
    l <- list(
      font = list(
        family = "sans-serif",
        size = 12,
        color = "#000"),
      bgcolor = "#E2E2E2",
      bordercolor = "#FFFFFF",
      borderwidth = 2)
    
    fig1 <- plot_ly(type = "scatter", mode = "markers", data = movies, x = ~released, y = ~length, text = ~paste("Title: ", title, '<br>Year:', released, '<br>Length:', runtime, '<br>Language:', original_language),
                    color = ~language_group,
                    colors = "Set2",
                    marker = list(size = 10,
                                  line = list(color = 'white',
                                              width = 1)))
    fig1 <- fig1 %>% config(fig1,
                            scrollZoom = TRUE, 
                            displaylogo = FALSE,
                            toImageButtonOptions = list(format= 'svg',
                                                        filename= 'runtime',
                                                        height= 600,
                                                        width= 900,
                                                        scale= 1 )) %>% 
      layout(title = '<b> Movie Lengths by Year Released (1918-2017) <b>',
             xanchor = 'left',
             yaxis = list(title = 'Movie Length (Minutes)'),
             xaxis = list(title = 'Year Released'))  %>% 
      layout(legend = l) %>%
      layout(legend = list(x = 100, y = 0.6)) %>%
      layout(legend=list(title=list(text='Language Group')))
    
    print(fig1)
  })
  
  output$budgetfig <- renderPlotly({
    m <- list(
      font = list(
        family = "sans-serif",
        size = 12,
        color = "#000"),
      bgcolor = "#E2E2E2",
      bordercolor = "#FFFFFF",
      borderwidth = 2)
 
#use plotly to build interactive fig2 - budget x year released 
    fig2 <- plot_ly(type = "scatter", mode = "markers", data = movies, x = ~released, y= ~budget, text = ~paste("Title: ", title, '<br>Year:', released, '<br>Budget:', budget, '<br>Language:', original_language),
                    color = ~language_group,
                    colors = "Set2",
                    marker = list(size = 10,
                                  line = list(color = 'white',
                                              width = 1)))
    
    fig2 <- fig2  %>% config(fig2,
                             scrollZoom = TRUE, 
                             displaylogo = FALSE,
                             toImageButtonOptions = list(format= 'svg',
                                                         filename= 'movie_budget',
                                                         height= 600,
                                                         width= 900,
                                                         scale= 1 ))  %>% 
      layout(title = '<b> Movie Budget by Year Released (1918-2017) <b>',
             xanchor = 'left',
             yaxis = list(title = 'Movie Budget (US Dollars)'),
             xaxis = list(title = 'Year Released')) %>% 
      layout(legend = m) %>% 
      layout(legend = list(x = 100, y = 0.6)) %>% 
      layout(legend=list(title=list(text='Language Group')))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

