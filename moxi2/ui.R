
library(shinydashboard)
library(shiny)


## Data input
pick_mic <- selectizeInput("mic", "MIC (mg/L)", choices=c(0.0625, 0.125, 0.25, 0.5, 1, 2),selected=0.5)
pick_pathogen <- radioButtons("target", "Pathogen", choices=list(`Gram Positive` = 30, `Gram Negative` = 100))
pick_dose <- selectizeInput("amt", "Dose (mg)", choices=c(200,400,600,800), selected=400)
pick_load <- selectizeInput("load", "Loading dose (mg)", choices=seq(400,800,100), selected=400)
pick_ht <- sliderInput("ht", "Height (cm)", min=156,max=198, value=c(160,180),step=5)
pick_wt <- sliderInput("wt", "Weight (kg)", min=60, max=170, value=c(70,110),step=5)
pick_fu <- numericInput("fu", "Fraction unbound", min=0.2, max=0.8,step=0.1,value=0.6)

## Data input - upper row
pick_row_1a <- box(pick_dose,pick_load,pick_fu ,width=2)
pick_row_1b <- box(pick_mic,pick_pathogen, width=2)
foot_row_1 <- 'Gram positive: fAUC/MIC target is 30 and Gram negative fAUC/MIC target is 100.'

## Data input - lower row
pick_row_2 <- box(pick_wt, pick_ht,br(), width=2, 
                  footer="Both weight and height are drawn from uniform distirbution.")

## Dashboard Title Row
url <- "https://www.ncbi.nlm.nih.gov/pubmed/25600294"
cite <- "Wicha SG et al. J Clin Pharmacol. 2015 Jun;55(6):639-46. PubMed PMID: 25600294."
link <- a(href=url,target="_blank",cite)
title <- tag("font", list(size="6", "Moxifloxacin PK in Patients with Diabetic Foot Infection"))
row0 <- fluidPage(fluidRow(column(12,title,br(),link,br(),br())))

## Dashboard Row 1
plot1 <- box(title="Free AUC",plotOutput("fauc",height="400px"), width=3)
plot2 <- box(title="Free AUC : MIC Ratio",plotOutput("faucmic", height="400px"),width=3)
plot3 <- box(title="Target Attainment",plotOutput("attain", height="400px"),width=3)
row1 <- fluidRow(plot1,plot2,plot3,pick_row_1a,pick_row_1b)

## Dashboard Row 2
bmiplot <-  box(title="Body Mass Index",plotOutput("bmi",height="250px"),width=3)
ibwplot <- box(title="Ideal Body Weight", plotOutput("ibw",height="250px"), width=3)
wtplot <- box(title="Weight", plotOutput("wt",height="250px"), width=3)
row2 <- fluidRow(wtplot,ibwplot,bmiplot, pick_row_2)



## Assemble pieces for dasyboard page
logo <- tags$img(src='207490_logo_finalwhite.png', width="150px")
head <- dashboardHeader(title=logo)
body <- dashboardBody(fluidPage(row0,row1,row2))
side <- dashboardSidebar(disable=TRUE)


## Send it out
dashboardPage(head,side,body,title="Moxi Model",skin="green")

