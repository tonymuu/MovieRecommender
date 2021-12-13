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
        icon = icon("thumbs-up"),
      ),
      box(
        width = 12,
        uiOutput('debug')
      )
    ),
  )
)

tab2 = tabItem(
  "system-2",
  fluidRow(
    box(width = 12, title = "System 2: Get Recommended Movies Based on Popularity", status = "success", solidHeader = TRUE, collapsible = TRUE,
        div(class = "rateitems",
            uiOutput('ratings2')
        )
    )
  ),
  fluidRow(
    useShinyjs(),
    box(
      width = 12, status = "success", solidHeader = TRUE,
      title = "Step 2: Discover books you might like",
      br(),
      withBusyIndicatorUI(
        actionButton("btn", "Click here to get your recommendations", class = "btn-primary")
      ),
      br(),
      tableOutput("results2")
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

header = dashboardHeader(title = "Book Recommender")

shinyUI(
  dashboardPage(
    skin = "green",
    header,
    sidebar,
    body
  )
) 