#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Project 2 - By Stephanie Yung
#server.R

#libraries
library(shiny)
library(DT)
library(ggplot2)
library(plotly)
library(dplyr)

shinyServer(function(input, output) {
    #read csv file of graduation ooutcomes
    gradOut = read.csv("GraduationOutcomesByBorough.csv", stringsAsFactors = FALSE)
    
    #borototal plot
    output$borototal <- renderPlot({
        #check if data is null
        if(!is.null(gradOut)){
            
            #set shape number
            shapeNum <- 16
            if(input$shapeOptions == "Triangle"){
                shapeNum <- 17
            }
            if(input$shapeOptions == "Circle"){
                shapeNum <- 16
            }
            if(input$shapeOptions == "Diamond"){
                shapeNum <- 18
            }
            if(input$shapeOptions == "Square"){
                shapeNum <- 15
            }
            
            #get useful data columns
            dataCols <- c("Demographic", "Borough", "Cohort", "TotalCohort")
            data <- gradOut[dataCols] 
            
            #get only all "Borough Total" data
            dataBoroTotal <- data[which(data$Demographic=="Borough Total"),] 

            #get individual borough based on user input
            dataIndividualBoro <- subset(dataBoroTotal, Borough==input$boroTotalOptions)
            
            Borough <- input$boroTotalOptions #set var of chosen boro

            #create title for plot
            boroTotalTitle <- paste("Total Cohort of Students for", input$boroTotalOptions, "between 2001-2006" )
            
            #plot - line chart
            ggp <- ggplot(dataIndividualBoro, aes(x=Cohort , y = TotalCohort, color = Borough)) + geom_line(linetype = input$lineTypeOption, size = 1.3) + geom_point(shape = shapeNum, size = 4, color = "black") 
            ggp + ggtitle(boroTotalTitle) +scale_color_manual(values = c("4821C4")) + theme(plot.title = element_text(size = input$textSizeOption)) + theme(plot.margin= unit(c(1,1,1,1), "cm"))

            
        }
        
    })
    
    #ethnicity enrollment plot
    output$ethnicity_plot <- renderPlot({
        if(!is.null(gradOut)){
            #get useful data columns
            dataCols <- c("Demographic", "Cohort", "StillEnrolledcount", "DroppedOutcount")
            newdata <- gradOut[dataCols]
            
            #get only year selected data
            newdata2 <- newdata[ which(newdata$Cohort==input$yearSelected),]
            
            #get data per ethnicity
            asianData <- newdata2 [which(newdata2$Demographic=="Asian"),]
            asianEnrolledcount <- sum(asianData[, 'StillEnrolledcount'])
            asianDroppedcount <- sum(asianData[, 'DroppedOutcount'])
            
            blackData <- newdata2 [which(newdata2$Demographic=="Black"),]
            blackEnrolledcount <- sum(blackData[, 'StillEnrolledcount'])
            blackDroppedcount <- sum(blackData[, 'DroppedOutcount'])

            hispanicData <- newdata2 [which(newdata2$Demographic=="Hispanic"),]
            hispanicEnrolledcount <- sum(hispanicData[, 'StillEnrolledcount'])
            hispanicDroppedcount <- sum(hispanicData[, 'DroppedOutcount'])
            
            whiteData <- newdata2 [which(newdata2$Demographic=="White"),]
            whiteEnrolledcount <- sum(whiteData[, 'StillEnrolledcount'])
            whiteDroppedcount <- sum(whiteData[, 'DroppedOutcount'])

            #bind data and give enrolled/dropped count a type for plotting
            df2 <- rbind(
                data.frame("Ethnicity" = "Asian", "Count" = asianEnrolledcount, "type"="Enrolled"),
                data.frame("Ethnicity" = "Asian","Count" = asianDroppedcount, "type"="Dropped"),
                data.frame("Ethnicity" = "Black", "Count" = blackEnrolledcount, "type"="Enrolled"),
                data.frame("Ethnicity" = "Black","Count" = blackDroppedcount, "type"="Dropped"),
                data.frame("Ethnicity" = "Hispanic", "Count" = hispanicEnrolledcount, "type"="Enrolled"),
                data.frame("Ethnicity" = "Hispanic","Count" = hispanicDroppedcount, "type"="Dropped"),
                data.frame("Ethnicity" = "White", "Count" = whiteEnrolledcount, "type"="Enrolled"),
                data.frame("Ethnicity" = "White","Count" = whiteDroppedcount, "type"="Dropped")

            )

            #set plot title
            plotTitle = paste("Ethnicity Enrolled vs Dropped for" ,input$yearSelected)
            
            #plot bar chart
            ethnicityggplot <- ggplot(data=df2, aes(x = Ethnicity , y = Count, fill = type)) + geom_bar(stat="identity", position = input$barPosition, color = "black")  + ggtitle(plotTitle) + scale_fill_brewer(palette=input$barEnrollmentPalette) + theme(plot.margin= unit(c(1,1,1,1), "cm")) + theme(plot.title = element_text(size = 25, face = input$fontEnrollmentStyle), axis.title.x = element_text(face = input$fontEnrollmentStyle), axis.title.y = element_text(face = input$fontEnrollmentStyle))
            
            ethnicityggplot
            
        }
    })
    
    #genderlocality plot
    output$locality_plot <- renderPlot({
        if(!is.null(gradOut)){
            #set shapeNum
            shapeNum <- 1
            if(input$pointShape == "Circle"){
                shapeNum <- 1
            }
            if(input$pointShape == "X"){
                shapeNum <- 4
            }
            if(input$pointShape == "Star"){
                shapeNum <- 8
            }
            
            #get useful data columns
            dataCols <- c("Demographic", "Localcount", "AdvancedRegentscount")
            data <- gradOut[dataCols]
            
            #get only gender selected data
            newdata <- data[ which(data$Demographic==input$genderSelected),]
            
            #set plot title
            plotTitle <- paste(input$genderSelected, "Local Count vs Advance Regent Count")
            
            #plot scatter plot with 2d density 
            ggplot(newdata, aes(x=Localcount, y=AdvancedRegentscount)) + geom_point(size = 3, shape = shapeNum) + geom_density_2d(color = input$densityLineColor) + ggtitle(plotTitle) + xlab("Local Count") + ylab("Advanced Regents Count") + theme(plot.margin= unit(c(1,1,1,1), "cm")) + theme(plot.title = element_text(size = 25, family = input$fontFamily), axis.title.x = element_text(family = input$fontFamily), axis.title.y = element_text(family = input$fontFamily))
        }
    })
    
    #education type plot by borough
    output$educationtype_plot <- renderPlot({
        if(!is.null(gradOut)){
            #get useful data columns
            dataCols <- c("Demographic","Borough", "Cohort", "AdvancedRegentspercent", "RegentswithoutAdvancedpercent")
            data <- gradOut[dataCols]
            
            #get selected education type and boro
            dataEducType <- data [ which(data$Demographic==input$educationTypeSelected), ]
            dataEducTypeBoro <- subset(dataEducType, Borough==input$educationTypeBoroSelected)
            
            #bind of percent advanced regents + non advanced regents
            df <- rbind(
                data.frame(dataEducTypeBoro, "Percent" = dataEducTypeBoro$AdvancedRegentspercent, "type" = "Advanced"),
                data.frame(dataEducTypeBoro, "Percent" = dataEducTypeBoro$RegentswithoutAdvancedpercent, "type" = "NonAdvanced")
            )

            #set plot title and line size
            plotTitle <- paste(input$educationTypeSelected, "on Advanced Regents and Non Advanced Regents in", input$educationTypeBoroSelected)
            lineSize = as.numeric(input$lineSizeSelected)
            
            #plot - multi line chart
            ggplot(data=df, aes(x = Cohort, y = Percent, group=type)) + geom_line(aes(linetype=type),size = lineSize , color = "steelblue") + geom_point(size = 4) + ggtitle(plotTitle) + theme(plot.title = element_text(size = 22, color = input$labelColor), axis.title.x = element_text(color = input$labelColor), axis.title.y = element_text(color = input$labelColor))
            
            
        }
    })
    

})
