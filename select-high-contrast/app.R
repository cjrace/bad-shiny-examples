library(shiny)
library(shinyGovstyle)

# Sample dataset
data <- mtcars[, 1:5]
data$cyl <- as.factor(data$cyl)

ui <- fluidPage(
  titlePanel("Filter mtcars by cylinders"),
  select_Input(
    inputId = "cyl_select",
    label = "Select number of cylinders:",
    select_text = levels(data$cyl),
    select_value = levels(data$cyl)
  ),
  govReactableOutput(caption = "", "filtered_table")
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    subset(data, cyl == input$cyl_select)
  })

  output$filtered_table <- renderGovReactable(
    govReactable(
      filtered_data() |>
        head()
    )
  )
}

shinyApp(ui, server)
