#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
library(shinythemes)
############
myData = readRDS("riasMeta.rds")
ministryTopicMatrix=readRDS("ministryTopicMatrix.rds")

ui<-navbarPage(theme = shinytheme("paper"), inverse=F, windowTitle= "RegCan", title = "Dashboard RegCan: ",
               
           navbarMenu("About",
                      
                      tabPanel(title = "Project",
                               source("ui_project.R", local = T, encoding = 'UTF-8')$value
                      ),
                      tabPanel("Team",
                               source("ui_team.R", local = T, encoding = 'UTF-8')$value
                      ),
                      tabPanel("Contact",
                               source("ui_contact.R", local = T, encoding = 'UTF-8')$value
                      )
           ),
           
           tabPanel("Lexical Specificities",
                    source("ui_specificities.R", local = T, encoding = 'UTF-8')$value
           ),
           
           tabPanel("Topic Modeling",
                    source("ui_topic.R", local = T, encoding = 'UTF-8')$value
           ),
           #tabPanel("Semantic Search Engine",
            #        plotOutput(outputId = "search")
           #),
           tabPanel("Regulatory Constraint Index",
                    source("ui_constraint.R", local = T, encoding = 'UTF-8')$value
           )
           
)

# Define server 
server <- function(input, output, session) {
  #call packages
  if ("quanteda" %in% installed.packages()==FALSE)
  {
    install.packages('quanteda',dependencies = TRUE)
  }
  library(quanteda)
  
  
  if ("Matrix" %in% installed.packages()==FALSE)
  {
    install.packages('Matrix',dependencies = TRUE)
  }
  
  library(Matrix)
  
  if ("shiny" %in% installed.packages()==FALSE)
  {
    install.packages('shiny',dependencies = TRUE)
  }
  
  library(shiny)
  
  if ("dplyr" %in% installed.packages()==FALSE)
  {
    install.packages('dplyr',dependencies = TRUE)
  }
  
  library(dplyr)
  
  if ("ggplot2" %in% installed.packages()==FALSE)
  {
    install.packages('ggplot2',dependencies = TRUE)
  }
  
  library(ggplot2)
  library(proxy)
  library(magrittr)
  
  if ("d3heatmap" %in% installed.packages()==FALSE)
  {
    install.packages('d3heatmap',dependencies = TRUE)
  }
  library(d3heatmap)
  ####################################
  
  
  #####################################
  #load data
  myData=readRDS("riasMeta.rds")
  myMatrix=readRDS("riasDfm.rds")
  myTopicYears=readRDS("topicYears.rds")
  ministryTopicMatrix=readRDS("ministryTopicMatrix.rds")
  corrTopicContraint=readRDS("corrTopicContraint.rds")
  contraintYears=readRDS("contraintYears.rds")
  constraintTopicYear=readRDS("constraintTopicYear.rds")
  
  
  
  
  #################################
  
  
  ########################################
  #render of specificities
  
  #selectionner les n specificites lexicales les plus fortes 
  nSpecificite1<- reactive({input$n1})
  nSpecificite2<- reactive({input$n2})
  
  #set target
  periodTime<-reactive({input$y})
  ministry<-reactive({input$z})
  
  #filtrer seulement les specificites significative au seuil p
  seuilP1<-reactive({input$p1})
  seuilP2<-reactive({input$p2})
  
  # Create reactive data frame
  specificities_select_period <- reactive({
    
    if (periodTime()<=2007) {
      cible = (myData$DATE_year<=2007 & myData$DATE_year>=2003)
      referent = myData$DATE_year<=2007
    } 
    else if (periodTime()<=2012) {
      cible = (myData$DATE_year<=2012 & myData$DATE_year>=2008)
      referent = myData$DATE_year<=2012
    }
    else if (periodTime()<=2017){
      cible = (myData$DATE_year<=2017 & myData$DATE_year>=2013)
      referent = myData$DATE_year<=2017
    }
    
    docvars(myMatrix, "target")<-cible
    subDFM<-dfm_subset(myMatrix, referent)
    
    #calculer les specificites
    specificites = quanteda::textstat_keyness(x=subDFM, target=subDFM@docvars$target==T, measure="chi2", sort=TRUE)
    
    #filter NA
    specificites=specificites[is.na(specificites$chi2)==F,]
    
    specificites=specificites[specificites$p<seuilP1()]
    specificites
  })
  
  # Create reactive data frame
  specificities_select_ministry <- reactive({
    
    #calculer les specificites
    specificites = quanteda::textstat_keyness(x=myMatrix, target=myData$ministry==ministry(), measure="chi2", sort=TRUE)
    
    #filter NA
    specificites=specificites[is.na(specificites$chi2)==F,]
    
    specificites=specificites[specificites$p<seuilP2()]
    specificites
  })
  
  
  output$barplot1 <- renderPlot(
    {
      
      #afficher les specificit?s
      quanteda::textplot_keyness(x=specificities_select_period(), n=nSpecificite1(), show_legend = F, color = c("darkblue", "red"))
      
    })
  
  output$barplot2 <- renderPlot(
    {
      
      #afficher les specificit?s
      quanteda::textplot_keyness(x=specificities_select_ministry(), n=nSpecificite2(), show_legend = F, color = c("darkblue", "red"))
      #print(ministry())
    })
  
  ##########################################
  #topic render
  topic_select1<-reactive({
    myTopicYears %>% filter(Topic %in% input$topic) %>%
      select(c(1:3))
    })
  output$topicGraph1 <- renderPlot(
    {
      pd=position_dodge(0.2)
      ggplot(topic_select1(), aes(Year, Weight, colour=Topic, group=Topic)) +
        stat_summary(fun.data=mean_cl_boot, geom="errorbar", width=0.1, alpha = .5, position=pd) +
        stat_summary(fun.y=mean, geom="line", size=2, position=pd) +
        stat_summary(fun.y=mean, geom="point", position=pd)+theme_bw()
      
    })
  
  
  
  topic_select2<-reactive({
    #ministryTopicMatrix[,input$ministryTopic]
    input$topic2
  })
  
  
  col.pal <- RColorBrewer::brewer.pal(9, "Reds")
  output$topicGraph2 <- renderD3heatmap(
    {
      #pheatmap::pheatmap(mat= ministryTopicMatrix, color=col.pal, show_colnames = TRUE, show_rownames = TRUE, drop_levels = TRUE, fontsize = 10, clustering_method = "complete", cluster_rows=T, main = "The Weights of Topics by Ministry")
      d3heatmap(ministryTopicMatrix[,topic_select2()],yaxis_width=260, xaxis_height=140,  colors = "Reds", Colv = T, cexCol=1, cexRow=1)
    })
  
  
  
  ###########################################
  #render contraint
  
  output$constraintGraph1 <- renderPlot(
    {
      ggplot(corrTopicContraint,aes(x= reorder(Topic,ConstraintT),ConstraintT))+geom_bar(stat ="identity", fill="darkblue")+coord_flip()+theme_bw()+ylab("Correlation between Regulatory Constraint Index and Topics")+xlab(NULL)
      
    })
  
  output$constraintGraph2 <- renderPlot(
    {
      ggplot(contraintYears, aes(x=Year, y=Constraint)) +
        stat_summary(aes(y = Constraint,group=1), fun.y=mean, colour="darkblue", geom="line",group=1, size=2)+
        stat_summary(fun.data=mean_cl_boot, geom="errorbar", width=0.2)+
        theme_bw()+
        ylab("Regulatory Constraint Index")+xlab("Year")
      
    })
  
  #topic render
  topic_select3<-reactive({
    constraintTopicYear %>% filter(Topic %in% input$topic3) %>%
      select(c(1:3))
  })
  
  output$constraintGraph3 <- renderPlot(
    {
      ggplot(topic_select3(), aes(x = Year, y = Constraint, color = Topic)) +
        theme_bw() + geom_line(size=2)+
        ylab("Correlation between Regulatory Constraint Index and Topics")+xlab("Years")
      
      
    })
  
  
}
#library(shinyShortcut)
#shinyShortcut(shinyDirectory = getwd(), OS = .Platform$OS.type, gitIgnore = FALSE)


# Run the application 
shinyApp(ui = ui, server = server)

