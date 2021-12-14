## ui.R
library(shiny)
library(shinydashboard)
library(recommenderlab)
library(data.table)
library(ShinyRatingInput)
library(shinyjs)

devtools::install_github("leonawicz/apputils")
library(apputils)
source('functions/helpers.R')

tab1 = tabItem(
  "system-1",
  fillPage(
    box(
      class = "rateitems",
      title = "Top Movies",
      width = 12,
      solidHeader = T,
      status = "success",
      box(
        uiOutput('selectSortBy'),
        uiOutput('selectGenre')
      ),
      infoBox(
        "",
        value = "How to use this app",
        subtitle = "Select genre from dropdown list, and select sort by method, the movie recommendations will be displayed automatically!",
        icon = icon("lightbulb"),
      ),
      box(
        width = 12,
        uiOutput('recommendationResults1')
      )
    ),
  )
)

tab2 = tabItem(
  "system-2",
  fillPage(
    useShinyjs(),
    box(
      title = "Recommended Movies",
      width = 12,
      solidHeader = T,
      status = "success",
      class = "rateitems",
      box(
        uiOutput('selectRecommendation'),
        fluidRow(
          width = 12,
          actionButton("btnSubmitRating", "Get Movies To Rate", class = "btn-primary"),
          actionButton("btnResetRecommendation", "Submit Ratings and Get Recommendations", class = "btn-primary")
        )
      ),
      infoBox(
        "",
        value = "How to use this app",
        subtitle = "Select which recommendation method to use: UBCF means User Based Collaborative filtering, and IBCF means Item Based Collaborative Filtering. Then click on \"Get Movies To Rate\" button to get a list of movies to be rated by you. Once done, click submit and get personalized movie recommendations!!",
        icon = icon("lightbulb"),
      ),
      tags$div(id = "placeholder"),
      uiOutput("recommendationResults2")
    )
  )
)

sidebar = dashboardSidebar(
  sidebarMenu(
    # Setting id makes input$tabs give the tabName of currently-selected tab
    id = "tabs",
    menuItem("System 1: Recommended Genre Movies", tabName = "system-1"),
    menuItem("System 2: Personalized Recommendations", tabName = "system-2")
  ),
  disable = FALSE
)

body = dashboardBody(
  includeCSS("css/style.css"),
  tabItems(tab1, tab2)
)

header = dashboardHeader(title = "Movie Recommender")

shinyUI(
  dashboardPage(
    skin = "green",
    header,
    sidebar,
    body
  )
) 