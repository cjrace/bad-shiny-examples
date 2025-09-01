page_navbar(
  title = "MTCars Explorer",
  id = "mtcars_explorer",
  theme = bs_theme(bootswatch = "flatly"),

  # Data Overview Page
  nav_panel(
    "Homepage",

    # Added navigation button
    div(
      style = "margin-top: 20px; text-align: left;",
      actionButton("go_to_comparison", "Click here",
                   class = "btn-primary btn-lg",
                   icon = icon("table", lib = "font-awesome")),

      style = "margin-top: 20px; text-align: center;",
      actionButton("go_to_viz", "Click here",
                   class = "btn-primary btn-lg",
                   icon = icon("chart-line")),

      style = "margin-top: 20px; text-align: left;",
      actionButton("go_to_performance", "Click here",
                   class = "btn-primary btn-lg",
                   icon = icon("masks-theater", lib = "font-awesome"))
    ),

  ),

  # Visualizations Page
  nav_panel(
    "Visualizations",
    page_sidebar(
      sidebar = sidebar(
        selectInput("x_var", "X Variable:",
                    choices = names(mtcars),
                    selected = "wt"),
        selectInput("y_var", "Y Variable:",
                    choices = names(mtcars),
                    selected = "mpg"),
        selectInput("color_var", "Color by:",
                    choices = c("None" = "none", names(mtcars)),
                    selected = "cyl"),
        hr(),
        checkboxInput("show_smooth", "Show trend line", TRUE)
      ),

      layout_columns(
        card(
          card_header("Scatter Plot"),
          plotOutput("scatter_plot", height = "400px")
        ),
        card(
          card_header("Distribution"),
          plotOutput("histogram", height = "400px")
        )
      )
    )
  ),

  # Performance Analysis Page
  nav_panel(
    "Performance",
    layout_columns(
      col_widths = c(4, 8),
      card(
        card_header("Filter Options"),
        sliderInput("cyl_filter", "Number of Cylinders:",
                    min = min(mtcars$cyl), max = max(mtcars$cyl),
                    value = c(min(mtcars$cyl), max(mtcars$cyl)),
                    step = 2),
        sliderInput("hp_filter", "Horsepower Range:",
                    min = min(mtcars$hp), max = max(mtcars$hp),
                    value = c(min(mtcars$hp), max(mtcars$hp))),
        checkboxGroupInput("gear_filter", "Gears:",
                           choices = sort(unique(mtcars$gear)),
                           selected = sort(unique(mtcars$gear)))
      ),
      card(
        card_header("Filtered Results"),
        layout_columns(
          value_box(
            title = "Average MPG",
            value = textOutput("avg_mpg"),
            showcase = icon("gas-pump"),
            theme = "primary"
          ),
          value_box(
            title = "Car Count",
            value = textOutput("car_count"),
            showcase = icon("car"),
            theme = "success"
          ),
          value_box(
            title = "Avg Horsepower",
            value = textOutput("avg_hp"),
            showcase = icon("bolt"),
            theme = "warning"
          )
        ),
        plotOutput("performance_plot", height = "300px")
      )
    )
  ),

  # Comparison Page
  nav_panel(
    "Car Comparison",
    page_sidebar(
      sidebar = sidebar(
        selectInput("compare_cars", "Select Cars to Compare:",
                    choices = rownames(mtcars),
                    selected = c("Mazda RX4", "Honda Civic"),
                    multiple = TRUE,
                    size = 10,
                    selectize = FALSE),
        helpText("Select multiple cars to compare their specifications")
      ),

      layout_columns(
        card(
          card_header("Comparison Table"),
          DT::dataTableOutput("comparison_table")
        ),
        card(
          card_header("Performance Radar Chart"),
          plotOutput("radar_comparison", height = "400px")
        )
      )
    )
  )
)
