############



ui_specificities<-fluidPage(
  fluidRow(
  sidebarLayout(
    sidebarPanel(width = 2,
               
               # Text instructions
               #HTML("Select the period"),
               
               # Select variable for y-axis
               selectInput(inputId = "y",
                           label = "Select period:",
                           choices = c("2003-2007", "2008-2012", "2013-2017")),
               #selected = "2003-2007"),
               
               
               
               
               
               # Text instructions
               #HTML("Select the sample size"),
               
               # Numeric input for sample size
               numericInput(inputId = "n1",
                            label = "Number of specificities:",
                            min=1,
                            max=30,
                            value = 15,
                            step = 1),
               
               # Text instructions
               HTML("Select statistical significance threshold"),
               
               # Select threshold
               selectInput(inputId = "p1",
                           label = "p value:",
                           choices = c(0.001, 0.01, 0.05),
                           selected = 0.05)
               
  ),
  
  # Output(s)
  mainPanel(width = 10,
            h4("Explore the Lexical Specificities by Period of Time"),
            plotOutput(outputId = "barplot1")
           
    )
  
  )
  ),
  fluidRow(
    sidebarLayout(
      sidebarPanel(width = 2,
                   
                   # Text instructions
                   #HTML("Select the period"),
                   
                   
                   # Text instructions
                   #HTML("Select the Ministry"),
                   
                   # Select variable for y-axis
                   selectInput(inputId = "z",
                               label = "Select ministry:",
                               choices = unique(myData$ministry)),
                   #selected = myData$ministry[1]),
                   
                   # Text instructions
                   #HTML("Select the sample size"),
                   
                   # Numeric input for sample size
                   numericInput(inputId = "n2",
                                label = "Number of specificities:",
                                min=1,
                                max=30,
                                value = 15,
                                step = 1),
                   
                   # Text instructions
                   HTML("Select statistical significance threshold"),
                   
                   # Select threshold
                   selectInput(inputId = "p2",
                               label = "p value:",
                               choices = c(0.001, 0.01, 0.05),
                               selected = 0.05)
                   
      ),
      
      # Output(s)
      mainPanel(width = 10,
                
                h4("Explore the Lexical Specificities by Ministry"),
                plotOutput(outputId = "barplot2")
      )
      
    )
    
  )
)

  

