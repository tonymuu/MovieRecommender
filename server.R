## server.R

# load functions
source('functions/cf_algorithm.R') # collaborative filtering
source('functions/similarity_measures.R') # similarity measures
source('scripts/preprocess.R')
#source('scripts/recommender.R')


withConsoleRedirect = function(containerId, expr) {
  # Change type="output" to type="message" to catch stderr
  # (messages, warnings, and errors) instead of stdout.
  txt <- capture.output(results <- expr, type = "output")
  if (length(txt) > 0) {
    insertUI(paste0("#", containerId), where = "beforeEnd",
             ui = paste0(txt, "\n", collapse = "")
    )
  }
  results
}

num_rows <- 6
num_movies <- 3

getCurrentIndex = function(i, j) {
  (i - 1) * num_movies + j
}

shinyServer(function(input, output, session) {
  
  # show the books to be rated
  output$selectGenre <- renderUI({
    selectInput(
      "selectGenre",
      "Genre",
      genre_list,
      selected = NULL
    )
  })
  
  output$selectSortBy <- renderUI({
    radioButtons(
      "selectSortBy",
      "Sort By",
      c("Popularity", "Average Rating")
    )
  })
  
  output$selectRecommendation <- renderUI({
    radioButtons(
      "selectSortBy",
      "Sort By",
      c("Popularity", "Average Rating")
    )
  })
  

  # Calculate recommendations when the sbumbutton is clicked
  df <- eventReactive(
    {
      input$selectGenre
      input$selectSortBy
    },
    {
      # get the user's rating data
      getRecommendedGenreMovies(input$selectGenre, input$selectSortBy)
    })

  # display the recommendations
  output$debug <- renderUI({
    recom_result <- df()

    lapply(1:num_rows, function(i) {
      list(
        fluidRow(
          br(),
          lapply(1:num_movies, function(j) {
            idx = getCurrentIndex(i, j)
            cat(recom_result$image_url[idx])
            apputils::infoBox(
              recom_result$Genres[idx],
              value = recom_result$Title[idx],
              subtitle = paste(round(recom_result$ave_ratings[idx], digits = 1), "/ 5.0 out of ", recom_result$ratings_per_movie[idx]," reviews"),
              icon = apputils::icon(list(src = recom_result$image_url[idx]), class = "my-icon-123", lib = "local"),
              fill = TRUE,
              color = "white",
              width = 4
            )
          }),
          br()
        )
      ) # columns
    }) # rows
  })
}) # server function
