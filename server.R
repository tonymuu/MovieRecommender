## server.R

# load functions
source('functions/cf_algorithm.R') # collaborative filtering
source('functions/similarity_measures.R') # similarity measures
source('scripts/preprocess.R')
source('scripts/recommender.R')

get_user_ratings <- function(value_list) {
  dat <- data.table(movie_id = sapply(strsplit(names(value_list), "_"), function(x) ifelse(length(x) > 1, x[[2]], NA)),
                    rating = unlist(as.character(value_list)))
  dat <- dat[!is.null(rating) & !is.na(movie_id)]
  dat[rating == " ", rating := 0]
  dat[, ':=' (movie_id = paste("m", movie_id, sep = ""), rating = as.numeric(rating))]
  dat <- dat[rating > 0]
  
  idx = which(dat$movie_id %in% movieIDs)
  new.ratings = rep(NA, n.item)
  new.ratings[idx] = dat$rating
  
  new.ratings
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
      "selectRecommendation",
      "Recommendation Method",
      c("UBCF", "IBCF")
    )
  })
  
  handleButtonResetRecommendation <- eventReactive(input$btnSubmitRating, {
    removeUI("#recomm")
    
    moviesToRate = getRecommendedGenreMovies("", "Popularity")
    getMovieRatingTiles(moviesToRate)
  })
  
  observeEvent(input$btnResetRecommendation, {
    removeUI("#recomm")
    
    # Get personalized recommendations
    value_list <- reactiveValuesToList(input)
    user_ratings <- get_user_ratings(value_list)
    cat(str(input$selectRecommendation))
    movies = getRecommendedMovies(user_ratings, input$selectRecommendation)

    insertUI(
      "#placeholder",
      "afterEnd",
      ui = div(
        id = 'recomm',
        box(
          width = 12,
          title = "We found these movies that you might like",
          getMovieTiles(movies)
        )
      )
    )
  })

  # Calculate recommendations when the sbumbutton is clicked
  handleEventGenreFilterChange <- eventReactive(
    {
      input$selectGenre
      input$selectSortBy
    },
    {
      getRecommendedGenreMovies(input$selectGenre, input$selectSortBy)
    }
  )

  # display the recommendations
  output$recommendationResults1 <- renderUI({
    getMovieTiles(handleEventGenreFilterChange())
  })
  
  # show the movies to be rated
  output$recommendationResults2 <- renderUI({
    box(
      width = 12,
      title = "Rate these movies to get movie recommendations based on your preference",
      handleButtonResetRecommendation()
    )
  })
}) # server function
