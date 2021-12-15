#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


#Project 2 - By Stephanie Yung
#ui.R

#libraries
library(shiny)
library(shinydashboard)

# Define UI
shinyUI(
  #Set up dashboard
  dashboardPage( skin = "purple",
      dashboardHeader(title = "Project 2"),
          dashboardSidebar(
              #Menu Tabs
               sidebarMenu(
                   menuItem("About", tabName = "about", icon = icon("info-circle")),
                   menuItem("Total Cohort", tabName = "borototal", icon = icon("chart-line")),
                   menuItem("Ethnicity Enrollment", tabName = "enrollment", icon = icon("chart-bar")),
                   menuItem("Gender Locality", tabName = "genderlocalality", icon = icon("chart-bar")),
                   menuItem("Education Type", tabName = "educationtype", icon = icon("chart-line"))
               )
             ),
             #Set Dashboard Body UI elements for each tab
             dashboardBody(
               
                 tabItems(
                     #About / Resources tab 
                     tabItem(tabName = "about",
                         fluidRow(
                             h1("Project 2 - By Stephanie Yung", style ="padding-left: 15px"),
                             h2("About:", style ="padding-left: 15px"),
                             h3("I have utilized the skills I've learned in CSCI 39579: Data Visualization to create an RShiny App containing four different visualizations. I used ggplot to create a bar chart, a scatter plot, and line charts . All plots revolve around NYC graduation outcomes for graduates between 2005-2010. Therefore, the data provided looks at the cohorts between the years of 2001-2006. Users can utilize the different UI elements I have provided to modify the data in which they would like to view for each plot.", style ="padding: 15px"),
                             h2("Resources:", style ="padding-left: 15px"),
                             h3("• https://data.cityofnewyork.us/Education/2005-2010-Graduation-Outcomes-By-Borough/avir-tzek/data", style = "padding-left: 15px"),
                             h3("• https://www.datanovia.com/en/blog/how-to-create-a-ggplot-with-multiple-lines/", style = "padding-left: 15px"),
                             h3("• http://www.sthda.com/english/wiki/ggplot2-line-plot-quick-start-guide-r-software-and-data-visualization", style = "padding-left: 15px"),
                             h3("• http://www.sthda.com/english/wiki/ggplot2-barplots-quick-start-guide-r-software-and-data-visualization", style = "padding-left: 15px"),
                             h3("• http://www.sthda.com/english/wiki/ggplot2-scatter-plots-quick-start-guide-r-software-and-data-visualization", style = "padding-left: 15px"),
                             h3("• http://www.sthda.com/english/wiki/ggplot2-title-main-axis-and-legend-titles", style = "padding-left: 15px"),
                             h3("• https://www.statmethods.net/management/subset.html", style = "padding-left: 15px")
                             
                         )
                     ),
                     
                     #Total Cohort Tab
                     tabItem(
                       tabName = "borototal",
                       h2("Total Cohort by Borough"),
                       
                       fluidRow(
                           #Input Boxes
                           box(selectInput("boroTotalOptions", "Boroughs: ",
                               c("Manhattan", "Brooklyn", "Queens", "Bronx", "Staten Island")), width = 3),
                           
                           box(selectInput("shapeOptions", "Shapes: ",
                               c( "Circle","Triangle", "Square", "Diamond", "")), width = 3),
                           
                           box(selectInput("lineTypeOption", "Line Type:",
                               c("solid","twodash","longdash", "dotted")), width = 3),
                           
                           box(selectInput("textSizeOption", "Title Text Size:",
                               c(20,30,40)), width = 3),
                           
                           #Output plot
                           plotOutput("borototal")
                       )
                     ),
                     
                     #Ethnicity Enrollment Tab
                     tabItem(
                       tabName = "enrollment",
                       h2("Ethnicity Enrollment by Year"),
                       fluidRow(
                           #Input Boxes
                           box(selectInput("yearSelected", "Year: ",
                               c("2001", "2002", "2003","2004", "2005", "2006")), width = 3),
                           
                           box(selectInput("barPosition", "Bar Position: ",
                               c("stack", "dodge")), width = 3),
                           
                           box(selectInput("barEnrollmentPalette", "Color Palette:",
                               c("Set1","Set3","Accent", "Paired", "Spectral")), width = 3),
                           
                           box(selectInput("fontEnrollmentStyle", "Font Style:",
                               c("plain","bold","italic","bold.italic")), width = 3),
                           
                           #Output Plot
                           plotOutput("ethnicity_plot")
                       )
                     ),
                     
                     #Gender Local count vs Advance Regents count
                     tabItem(
                       tabName = "genderlocalality",
                       h2("Gender's Locality affect on Advance Regents Count"),
                       fluidRow(
                           #Input Boxes
                           box(selectInput("genderSelected", "Gender: ",
                                           c("Female", "Male")), width = 3),
                           
                           box(selectInput("densityLineColor", "Density Line Color: ",
                                           c("lightskyblue", "darkviolet", "firebrick1", "palegreen4")), width = 3),
                           box(selectInput("pointShape", "Point Shape: ",
                                           c("Circle", "X", "Star")), width = 3),
                           
                           box(selectInput("fontFamily", "Font Family:",
                                           c("sans", "serif", "mono")
                                           ), width = 3),
                           
                           #Output plot
                           plotOutput("locality_plot")
                       )
                     ),
                     
                     #Education Type on Regents by Borough
                     tabItem(
                       tabName = "educationtype",
                       h2("Education Type on Advanced Regents and Non Advanced Regents By Borough"),
                       
                       #Input boxes
                       box(selectInput("educationTypeSelected", "Education Type: ", c("General Education", "Special Education", "English Language Learners", "English Proficient Students")), width = 3),
                       box(selectInput("educationTypeBoroSelected", "Borough: ", c("Manhattan", "Brooklyn", "Queens", "Bronx", "Staten Island")), width = 3),
                       box(selectInput("lineSizeSelected", "Line Size", c(1.0,1.5,2.0)),  width = 3),
                       
                       box(selectInput("labelColor", "Label Color:", c("black", "slateblue", "orangered3", "purple4")),  width = 3),
                       
                       #Output plot
                       plotOutput("educationtype_plot")
                     )
                     
                 ) #End of tabItems
             ) #End of dashboard body
    ) #End of dashboard page
) #End of Shiny UI
