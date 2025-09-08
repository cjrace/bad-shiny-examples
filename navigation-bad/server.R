function(input, output, session) {

  # Navigation button observer
  observeEvent(input$go_to_viz, {
    updateNavbarPage(session, inputId = "mtcars_explorer", selected = "Visualizations")
  })

  observeEvent(input$go_to_comparison, {
    updateNavbarPage(session, inputId = "mtcars_explorer", selected = "Car Comparison")
  })

  observeEvent(input$go_to_performance, {
    updateNavbarPage(session, inputId = "mtcars_explorer", selected = "Performance")
  })


  # Visualization outputs
  output$scatter_plot <- renderPlot({
    p <- ggplot(mtcars, aes_string(x = input$x_var, y = input$y_var))

    if(input$color_var != "none") {
      p <- p + aes_string(color = input$color_var)
    }

    p <- p + geom_point(size = 3, alpha = 0.7)

    if(input$show_smooth) {
      p <- p + geom_smooth(method = "lm", se = TRUE, alpha = 0.3)
    }

    p + theme_minimal() +
      labs(title = paste(input$y_var, "vs", input$x_var))
  })

  output$histogram <- renderPlot({
    ggplot(mtcars, aes_string(x = input$x_var)) +
      geom_histogram(bins = 15, fill = "steelblue", alpha = 0.7, color = "white") +
      theme_minimal() +
      labs(title = paste("Distribution of", input$x_var),
           y = "Frequency")
  })

  # Performance Analysis - Filtered data
  filtered_data <- reactive({
    mtcars %>%
      filter(cyl >= input$cyl_filter[1] & cyl <= input$cyl_filter[2],
             hp >= input$hp_filter[1] & hp <= input$hp_filter[2],
             gear %in% input$gear_filter)
  })

  output$avg_mpg <- renderText({
    round(mean(filtered_data()$mpg), 1)
  })

  output$car_count <- renderText({
    nrow(filtered_data())
  })

  output$avg_hp <- renderText({
    round(mean(filtered_data()$hp), 0)
  })

  output$performance_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = wt, y = mpg, color = factor(cyl))) +
      geom_point(size = 3) +
      geom_smooth(method = "lm", se = FALSE) +
      theme_minimal() +
      labs(title = "Weight vs MPG (Filtered Data)",
           x = "Weight (1000 lbs)", y = "Miles per Gallon",
           color = "Cylinders")
  })

  # Car Comparison outputs
  output$comparison_table <- DT::renderDataTable({
    if(length(input$compare_cars) > 0) {
      comparison_data <- mtcars[input$compare_cars, , drop = FALSE]
      DT::datatable(comparison_data,
                    options = list(pageLength = 15, scrollX = TRUE))
    }
  })

  output$radar_comparison <- renderPlot({
    if(length(input$compare_cars) >= 2) {
      # Simple comparison plot showing key metrics
      comparison_data <- mtcars[input$compare_cars, c("mpg", "hp", "wt", "qsec")]
      comparison_data$car <- rownames(comparison_data)

      # Normalize data for better comparison (0-1 scale)
      comparison_data$mpg_norm <- comparison_data$mpg / max(mtcars$mpg)
      comparison_data$hp_norm <- comparison_data$hp / max(mtcars$hp)
      comparison_data$wt_norm <- 1 - (comparison_data$wt / max(mtcars$wt)) # Lower weight is better
      comparison_data$qsec_norm <- 1 - (comparison_data$qsec / max(mtcars$qsec)) # Lower time is better

      # Reshape for plotting
      library(tidyr)
      plot_data <- comparison_data %>%
        select(car, mpg_norm, hp_norm, wt_norm, qsec_norm) %>%
        pivot_longer(-car, names_to = "metric", values_to = "value")

      ggplot(plot_data, aes(x = metric, y = value, color = car, group = car)) +
        geom_line(size = 1.2) +
        geom_point(size = 3) +
        coord_polar() +
        theme_minimal() +
        labs(title = "Performance Comparison",
             subtitle = "Normalized metrics (higher is better)",
             x = "", y = "") +
        scale_x_discrete(labels = c("HP", "MPG", "Speed\n(1/4 mile)", "Weight\n(lighter)")) +
        theme(axis.text.y = element_blank())
    } else {
      # Show message when less than 2 cars selected
      ggplot() +
        annotate("text", x = 0.5, y = 0.5,
                 label = "Select at least 2 cars to compare",
                 size = 6, hjust = 0.5) +
        theme_void()
    }
  })
}
