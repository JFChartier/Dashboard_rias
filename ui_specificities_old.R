############
ui_specificities<-sidebarLayout(
  
  # Input(s)
  sidebarPanel(width = 2,
               
               # Text instructions
               #HTML("Select the period"),
               
               # Select variable for y-axis
               selectInput(inputId = "y",
                           label = "Select period:",
                           choices = c("2003-2007", "2008-2012", "2013-2017")),
                           #selected = "2003-2007"),
               
               
               
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
               numericInput(inputId = "n",
                            label = "Number of specificities:",
                            min=1,
                            max=30,
                            value = 15,
                            step = 1),
               
               # Text instructions
               HTML("Select statistical significance threshold"),
               
               # Select threshold
               selectInput(inputId = "p",
                           label = "select p value:",
                           choices = c(0.001, 0.01, 0.05),
                           selected = 0.05)
               
  ),
  
  # Output(s)
  mainPanel(width = 10,
            #fluidRow(
            #splitLayout(cellWidths = c("50%", "50%"), 
            #plotOutput("barplot1"), 
            #plotOutput("barplot2"))
            #)
            #show specificity barplot
            #HTML("<h3><b>Most important lexical specificities of the selected period</b></h3>"),
            #br(),
            plotOutput(outputId = "barplot1"),
            
            br(),br(),
            
            #show specificity barplot
            #HTML("<h3><b>Most important lexical specificities of the selected Ministry</b></h3>"),
            #br(),
            plotOutput(outputId = "barplot2")
            
  )
)
