ui_constraint<-fluidPage(
  fluidRow(
    column(6,
           h4("Regulatory Constraint Index by Topics"),
           plotOutput(outputId = "constraintGraph1")),
    column(6,
           h4("Regulatory Constraint Index by Year"),
           plotOutput(outputId = "constraintGraph2"))
    
  ),
  
  fluidRow(
    
    sidebarLayout(
      
      # Input(s)
      sidebarPanel(width = 2,
                   selectInput(inputId = "topic3",
                               label = "Select topics:",
                               choices = colnames(ministryTopicMatrix),
                               multiple= T)
                   ),
      
      # Output(s)
      mainPanel(width = 10,
                h4("Explore Regulatory Constraint Index by Topic by Year"),
                plotOutput(outputId = "constraintGraph3")
                
      )
    ))
)