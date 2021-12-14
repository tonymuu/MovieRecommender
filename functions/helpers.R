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


#############################################################################
#################### UI Helpers #############################################
#############################################################################
num_rows <- 6
num_movies <- 3

getCurrentIndex = function(i, j) {
  (i - 1) * num_movies + j
}

getMovieTiles = function(recom_result) {
  lapply(1:num_rows, function(i) {
    list(
      fluidRow(
        br(),
        lapply(1:num_movies, function(j) {
          idx = getCurrentIndex(i, j)
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
}

getMovieRatingTiles = function(recom_result) {
  lapply(1:num_rows, function(i) {
    list(
      fluidRow(
        br(),
        lapply(1:num_movies, function(j) {
          idx = getCurrentIndex(i, j)
          apputils::infoBox(
            recom_result$Genres[idx],
            value = recom_result$Title[idx],
            subtitle = div(
              style = "color: #f0ad4e;",
              ratingInput(paste0("select_", recom_result$MovieID[idx]), label = "", dataStop = 5)
            ),
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
}


# Set up a button to have an animated loading indicator and a checkmark
# for better user experience
# Need to use with the corresponding `withBusyIndicator` server function
withBusyIndicatorUI <- function(button) {
  id <- button[['attribs']][['id']]
  div(
    `data-for-btn` = id,
    button,
    span(
      class = "btn-loading-container",
      hidden(
        img(src = "ajax-loader-bar.gif", class = "btn-loading-indicator"),
        icon("check", class = "btn-done-indicator")
      )
    ),
    hidden(
      div(class = "btn-err",
          div(icon("exclamation-circle"),
              tags$b("Error: "),
              span(class = "btn-err-msg")
          )
      )
    )
  )
}

# Call this function from the server with the button id that is clicked and the
# expression to run when the button is clicked
withBusyIndicatorServer <- function(buttonId, expr) {
  # UX stuff: show the "busy" message, hide the other messages, disable the button
  loadingEl <- sprintf("[data-for-btn=%s] .btn-loading-indicator", buttonId)
  doneEl <- sprintf("[data-for-btn=%s] .btn-done-indicator", buttonId)
  errEl <- sprintf("[data-for-btn=%s] .btn-err", buttonId)
  shinyjs::disable(buttonId)
  shinyjs::show(selector = loadingEl)
  shinyjs::hide(selector = doneEl)
  shinyjs::hide(selector = errEl)
  on.exit({
    shinyjs::enable(buttonId)
    shinyjs::hide(selector = loadingEl)
  })
  
  # Try to run the code when the button is clicked and show an error message if
  # an error occurs or a success message if it completes
  tryCatch({
    value <- expr
    shinyjs::show(selector = doneEl)
    shinyjs::delay(2000, shinyjs::hide(selector = doneEl, anim = TRUE, animType = "fade",
                     time = 0.5))
    value
  }, error = function(err) { errorFunc(err, buttonId) })
}

# When an error happens after a button click, show the error
errorFunc <- function(err, buttonId) {
  errEl <- sprintf("[data-for-btn=%s] .btn-err", buttonId)
  errElMsg <- sprintf("[data-for-btn=%s] .btn-err-msg", buttonId)
  errMessage <- gsub("^ddpcr: (.*)", "\\1", err$message)
  shinyjs::html(html = errMessage, selector = errElMsg)
  shinyjs::show(selector = errEl, anim = TRUE, animType = "fade")
}

appCSS <- "
.btn-loading-container {
  margin-left: 10px;
  font-size: 1.2em;
}
.btn-done-indicator {
  color: green;
}
.btn-err {
  margin-top: 10px;
  color: red;
}
"
