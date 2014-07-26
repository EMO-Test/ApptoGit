library(shiny)
library(ggplot2)

## BEGIN Function Def

edit.plt = function(p) {
        ## this function prettifies p
        ## p: ggplot2 object
        ## output: ggplot2 object
        bold.text = element_text(face='bold')
        format.x = element_text(size=13, angle=30)
        format.y = element_text(size=13)
        
        p = p + theme_bw() + 
                theme(axis.text.x=format.x, axis.text.y=format.y) + 
                labs(x="", y="", title="")
        p
}

## END Function Def

## BEGIN Path Setup, Data Loading, Function Sourcing

load("plt.lst.rda")
source("multiplot.R")

## END Path Setup, Data Loading, Function Sourcing

## BEGIN Server Logic
shinyServer(function(input, output) {
        
        process <- reactive({
                if(input$run==0) return(NULL)
                
                ## get input parameters
                plt.idx = isolate(switch(input$upr, 
                                         "Events by Stimuli" = 
                                                 "plt.eventCnt.by.stimuli", 
                                         "Total Emotional Engagement" = 
                                                 "plt.intensity.by.stimuli",
                                         "Emotional Engagement by Stimuli" = 
                                                 "plt.avg.intensity.by.stimuli.left.right",
                                         "Emotion Mark" = 
                                                 "plt.pct.normed.emo.by.stimuli"))
                
                ## return
                plt.idx
        })
        
        output$txt <- renderUI({
                if(input$run==0) return(NULL)
                
                ## call process()
                plt.idx = process()
                print(plt.idx)
                if (plt.idx == "plt.eventCnt.by.stimuli")
                        out = "This is the first step of the data exploratory to 
                        depict the instances of emotion to each stimulus. It answers the question of how many times did the stimulus evoke a reaction. make the product experience memorable. 
                        Experiences with positive emotions will produce memories 
                        with more contextual details."
                if (plt.idx == "plt.intensity.by.stimuli")
                        out = "This is the second step in the analysis and it shows 
                          which product stimuli had more emotional engagement.
                          Emotional engagement is the strength of the elicited 
                          emotion, and emotional engagement has been proven to 
                          correlate with preference, likeability and purchase 
                          intent."
                if (plt.idx == "plt.avg.intensity.by.stimuli.left.right")
                        out = "Normalizing these values removes any skewness from 
                          the sample distribution. The algorithm to produce this 
                          chart helps to ensure that no single respondent can 
                          unfairly elevate the result for any stimuli. These 
                          results also help predict the sustainability of success 
                          for the stimuli/ product(s) will have in the market."
                if (plt.idx == "plt.pct.normed.emo.by.stimuli")
                        out = "Outliers to the Normalized Emotional Engagement data 
                          can be better understood by evaluating the Emotion 
                          Mark of each stimulus or product. The Emotion Mark is 
                          the emotion composition of the engagement that is 
                          quantified. Each Emotion Mark is unique to the 
                          stimulus and can aid in the understanding of why the 
                          stimulus is engaging. Emotion Marks should mirror the 
                          profile of why the product/stimuli is selected or 
                          created. When products fail to mirror the anticipated 
                          Emotion Mark, understanding qualitative feedback 
                          becomes more important."
                HTML(paste("<h4>", out, "</h4>"))
        })
        
        output$bnplot = renderPlot({
                if(input$run==0) return(NULL)
                
                ## call process()
                plt.idx = process()
                plt = plt.lst[[plt.idx]]
                
                ## plot
                if (plt.idx == "plt.avg.intensity.by.stimuli.left.right") {
                        plt.l = edit.plt(plt$left)
                        plt.r = edit.plt(plt$right)
                        multiplot(plt.l, plt.r,
                                  layout=matrix(1:2,nrow=1,ncol=2,byrow=T))
                } else {
                        print(edit.plt(plt))
                }

        })
      
        output$cost = renderUI({
                if(input$run==0) return(NULL)
                
                ## get input parameters
                secs = isolate(input$secs)
                nSti = isolate(input$nSti)
                nRes = isolate(input$nRes)
                
                ## cost = 
                ## engagement period times 1.75, 
                ## times the amount of stimuli, 
                ## times the amount of respondents, 
                ## times $0.1528568  
                ## plus  $2400
                cost = round(secs*1.75*nSti*nRes*0.1528568+2400,2)                
                cost = paste0("$", cost)                
                 
                HTML(paste("<h3>The total cost for", 
                           span(nRes, style = "color:green"), "respondents", 
                           span(nSti, style = "color:green"), "stimuli and", 
                           span(secs, style = "color:green"), 
                           "seconds of engagement is", 
                           span(cost, style = "color:green"), "</h3>",
                           sep=" ",collapse=""))
        })
})

## END Server Logic