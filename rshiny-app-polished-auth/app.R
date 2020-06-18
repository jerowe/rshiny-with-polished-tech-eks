library(shiny)

ui <- polished::secure_ui(
  fluidPage(
    fluidRow(
      column(
        6,
        h1("Hello Shiny!")
      ),
      column(
        6,
        br(),
        actionButton(
          "sign_out",
          "Sign Out",
          icon = icon("sign-out-alt"),
          class = "pull-right"
        )
      ),
      column(
        12,
        verbatimTextOutput("user_out")
      )
    )
  )
)

server <- polished::secure_server(function(input, output, session) {
  output$user_out <- renderPrint({
    session$userData$user()
  })

  observeEvent(input$sign_out, {
    sign_out_from_shiny(session)
    session$reload()
  })
})

options(shiny.autoreload = TRUE)
options(shiny.host = '0.0.0.0')
options(shiny.port = 8080)

shinyApp(ui, server, onStart = function() {
  library(polished)

  # configure the global sessions when the app initially starts up.
  polished::global_sessions_config(
    app_name = Sys.getenv("POLISHED_APP_NAME"),
    api_key = Sys.getenv("POLISHED_API_KEY")
  )
})

