library(shiny)

# Sample dataset
data <- mtcars[, 1:5]
data$cyl <- as.factor(data$cyl)

ui <- fluidPage(
  titlePanel("Filter mtcars by cylinders"),
  selectInput(
    inputId = "cyl_select",
    label = "Select number of cylinders:",
    choices = levels(data$cyl),
    selected = levels(data$cyl)[1]
  ),
  tableOutput("filtered_table")
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    subset(data, cyl == input$cyl_select)
  })

  output$filtered_table <- renderTable(
    filtered_data() |>
      head(),
    rownames = TRUE
  )
}

shinyApp(ui, server)
