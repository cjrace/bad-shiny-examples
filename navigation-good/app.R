library(shiny)
library(shinyGovstyle)
library(bslib)
library(dfeshiny)

# Using as temporary example for now
dfe_contents_links <- function(links_list) {
  # Add the HTML around the link and make an id by snake casing
  create_sidelink <- function(link_text) {
    tags$li(
      "—",
      actionLink(
        tolower(gsub(" ", "_", link_text)),
        link_text,
        `data-value` = link_text,
        class = "contents_link"
      )
    )
  }

  # The HTML div to be returned
  tags$div(
    style = "position: sticky; top: 0.5rem; padding: 0.25rem;", # Make it stick!
    h2("Contents"),
    tags$ul(
      id = "contents_links",
      style = "list-style-type: none; padding-left: 0; font-size: 1rem;", # remove the circle bullets
      `aria-label` = "Contents",
      lapply(links_list, create_sidelink)
    )
  )
}

ui <- bslib::page_fluid(
  tags$head(HTML("<title>MT Cars Explorer | Homepage</title>")),
  tags$html(lang = "en"),

  shinyGovstyle::skip_to_main(),

  dfeshiny::header(
    header = "MT Cars Explorer"
  ),

  gov_main_layout(
    layout_columns(
      # Override default wrapping breakpoints to avoid text overlap
      col_widths = breakpoints(sm = c(4, 8), md = c(3, 9), lg = c(2, 9)),
      ## Left navigation ------------------------------------------------
      dfe_contents_links(
        links_list = c(
          "Homepage",
          "Tables",
          "Charts",
          "Compare characteristics"
        )
      ),
      ## Dashboard panels -----------------------------------------------
      bslib::navset_hidden(
        id = "left_nav",
        nav_panel(
          "Home",
          div(id = "main_col", 
          h1("Homepage"),
          p(
            "This website allows you to explore the mtcars dataset, comparing car models directly, finding statistics by car characteristics and plotting variables against each other."
          )
        )
        ),
        nav_panel(
          "tables",
          p("Tables coming soon...")
        ),
        nav_panel(
          "charts",
          p("Charts coming soon...")
        ),
        nav_panel(
          "compare_characteristics",
          p("Characteristics comparison coming soon...")
        )
      )
    )
  ),

  shinyGovstyle::footer(
    full = FALSE
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
