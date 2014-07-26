shinyUI(fluidPage(
  titlePanel("Emotional Engagement Data and Costing"),
  
  sidebarLayout(position = "left",
        sidebarPanel( 
                h4("This app will share the Emotional Engagement results of a customer base that were exposed to four different types of product and other stimuli during an interview setting. The goal was to determine which product is best, as identified by the total amount of emotional engagement."),
                br(),
                
                h4("Follow the steps below and then click 'Show Me'"),
                br(),
                
                radioButtons(inputId = "upr",
                            label = h4("Please select the data point you would 
                                       like displayed to the right of your screen."),
                            choices = c("Events by Stimuli" = 
                                                "Events by Stimuli", 
                                        "Total Emotional Engagement" = 
                                                "Total Emotional Engagement",
                                        "Emotional Engagement by Stimuli" = 
                                                "Emotional Engagement by Stimuli", 
                                        "Emotion Mark" = 
                                                "Emotion Mark")),
                br(),

                h4("Want to know how much this costs?  Fill in the information below to receive an estimate."),
                br(),
                
                numericInput("nRes", label = h4("Respondents (how many people?): "), 
                            value = 0, min= 0),
                br(),

                numericInput("nSti", label = h4("Stimuli (how many items to view?): "),
                          value = 0, min=0), 
                br(),
                
                numericInput("secs", label = h4("Engagement Period (seconds)- (how long will they look at it?):"),
                          value = 0, min=0),
                br(),
                
                actionButton("run", "Show Me!")
                
        ),
        
        mainPanel(                
                uiOutput("txt"), 
                br(),
                plotOutput("bnplot"),
                br(),
                uiOutput("cost")
        ))
  
))