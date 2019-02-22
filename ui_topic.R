library(d3heatmap)
ui_topic<-fluidPage(
  fluidRow(
    
  sidebarLayout(
  
      # Input(s)
      sidebarPanel(width = 2,
                   
                   # Text instructions
                   #HTML("Select topics"),
                   
                   # Select variable for y-axis
                   selectInput(inputId = "topic",
                               label = "Select topics:",
                               choices = colnames(ministryTopicMatrix),
                               multiple= T)
                   
                      
      ),
      
      # Output(s)
      mainPanel(width = 10,
                h4("Explore the Weight of Topics by Year"),
                plotOutput(outputId = "topicGraph1")
                
                
                
      )
    )),
  fluidRow(
    
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(width = 2,
                 
                 # Text instructions
                 #HTML("Select topics"),
                 
                 # Select variable for y-axis
                 selectInput(inputId = "topic2",
                             label = "Select topics:",
                             choices = colnames(ministryTopicMatrix),
                             selected = colnames(ministryTopicMatrix)[1:2],
                             multiple= T)#,
                 #selectInput(inputId = "ministryTopic",
                             #label = "Select ministry:",
                            # choices = row.names(ministryTopicMatrix),
                             #multiple= T)
                 
                 
    ),
    
    # Output(s)
    mainPanel(width = 10,
              h4("Explore the Weight of Topics by Ministry"),
              d3heatmapOutput("topicGraph2", width = "100%", height="900px")
              
              
    )
  ))
)