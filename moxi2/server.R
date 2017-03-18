library(shiny)
library(mrgsolve)
library(ggplot2)
library(dplyr)
library(parallel)
library(tidyr)
library(dmutate)

options(mc.cores=4)
mod <- mread_cache("moxi_ode")

IBW <- function(HT,SEX) {
  50 + 2.3*(HT/2.54 - 60) - 0.5*(SEX==1)
}

BMI <- function(HT,WGT) WGT/(HT/100)^2

cov1 <- covset(WGT ~ runif(wtmin,wtmax),
               SEX ~ rbinomial(0.5),
               HT ~ runif(htmin,htmax),
               IBW ~ expr(IBW(HT,SEX)),
               BMI ~ expr(BMI(HT,WGT)))

gr <- function() "#00A65A"

scale_fill_mine <- function(...) {
  scale_fill_manual(...,labels=c("Day 1", "Day 3"), 
                    values=rev(c(gr(), "darkslateblue")))
}

alpha <- function() 0.7

popcolor <- function() "darkgrey"

n <- 1000

shinyServer(function(input,output,session) {

  ##' Reactive expressions to get WT
  get_wt <- reactive({
    return(as.numeric(input[["wt"]]))
  })
  get_wt_d <- debounce(get_wt,500)
  
  ##' Reactive expression to generate the popultion
  make_pop <- reactive({
    wt <- get_wt_d()
    ht <- as.numeric(input[["ht"]])
    wtmin <- wt[1]
    wtmax <- wt[2]
    htmin <- ht[1]
    htmax <- ht[2]
    idata <- mutate_random(data_frame(ID=1:n),cov1,envir=environment())
    return(idata)
  })
  
  ##' Plot of BMI distribution
  output$bmi <- renderPlot({
    df <- make_pop()
    med <- signif(median(df$BMI),2)
    p1 <- 
      ggplot(data=make_pop()) + ylim(0,100) + 
      geom_density(aes(x=BMI,y=..count..),alpha=1,fill=popcolor(), color=0)  +  
      scale_x_continuous(limits=c(10,70), breaks=seq(10,70,10), name="BMI (kg/m2))") + 
      geom_text(data=data_frame(),aes(x=med, label=med),color="black",y=4)
    return(p1)
  })
  
  ##' Plot of IBW distribution
  output$ibw <- renderPlot({
    df <- make_pop()
    med <- signif(median(df$IBW),2)
    p1 <- 
      ggplot(data=make_pop()) + ylim(0,100) + 
      geom_density(aes(x=IBW,y=..count..),alpha=1,fill=popcolor(), color=0)  +  
      scale_x_continuous(limits=c(50,100), breaks=seq(50,100,10), name="IBW (kg)") + 
      geom_text(data=data_frame(),aes(x=med, label=med),color="black",y=4)
    return(p1)
  })
  
  ##' Plot of WGT distirbution
  output$wt <- renderPlot({
    df <- make_pop()
    med <- signif(median(df$WGT),2)
    p1 <- 
      ggplot(data=make_pop()) + ylim(0,100) + 
      geom_density(aes(x=WGT,y=..count..),alpha=1,fill=popcolor(), color=0)  +  
      scale_x_continuous(limits=c(60,170), breaks=seq(60,170,20), name="WGT (kg)") + 
      geom_text(data=data_frame(),aes(x=med, label=med),color="black",y=4)
    return(p1)
  })

  ##' The main simulation sequence
  ##' - Get loading and maintenance dose from `input`
  ##' - Create an events object
  ##' - Create a population with `make_pop`
  ##' - Update `fu` from `input`
  ##' - Return sims as `tibble` (`data.frame`)
  sim <- reactive({
    
    amt1 <- as.numeric(input[["load"]])
    amt2 <- as.numeric(input[["amt"]])
    e <- ev(amt=amt1) + ev(amt=amt2,ii=24,addl=1, time=24)
  
    out <- 
      mrgsim(mod,events=e, 
             idata=make_pop(), 
             delta=2, 
             end=72,
             param=list(fu=input[["fu"]]))
    return(as.tbl(out))
  })

  ##' Day 1/3 distribution of fAUC
  output$fauc <- renderPlot({
    sims <- sim()
    sims <- filter(sims,time==72)
    sims <- gather(sims,variable,value,fAUC24,fAUC72)
    p1 <- 
      ggplot(data=sims) + 
      geom_density(aes(x=value,y=..count..,group=variable,fill=variable),
                   alpha=alpha(), color=0) + 
      scale_fill_mine(name="") + xlab("Free AUC (mg*hr/L)") + 
      xlim(0,80)  + theme(legend.position="bottom")
    return(p1)
  })
  
  ##' Day 1/3 distribution of fAUC/MIC
  output$faucmic <- renderPlot({
    sims <- sim()
    sims <- filter(sims, time==72)
    sims <- gather(sims,variable,value,fAUC24,fAUC72)
    sims <- mutate(sims, value = value/as.numeric(input[["mic"]]))
    tar <- as.numeric(input[["target"]])
    if(tar==30) {
       limits <- c(0,140)
       breaks <- seq(0,140,20)
    } else {
      limits <- c(0,300)
      breaks <- seq(0,300,40)
    }
    p1 <- 
      ggplot(data=sims) + 
      geom_density(aes(x=value,y=..count..,group=variable,fill=variable),alpha=alpha(), color=0) + 
      scale_fill_mine(name="") + xlab("Free AUC (mg*hr/L) / MIC")  + 
      theme(legend.position="bottom") + 
      scale_x_continuous(limits=limits, breaks=breaks) + 
      geom_vline(xintercept=tar,lty=2,lwd=1.5)
    return(p1)
  })
  
  
  ##' Day 1/3 target attainment results
  output$attain <- renderPlot({
    sims <- sim()
    sims <- filter(sims,time==72)
    mic <- as.numeric(input[["mic"]])
    target <- as.numeric(input[["target"]])
    summ <- summarise(sims, 
                      PR24 = mean(fAUC24/mic > target), 
                      PR72 = mean(fAUC72/mic > target))
    summ <- gather(summ,variable,value, PR24:PR72)
    p1 <- 
      ggplot(data=summ,aes(variable,value,fill=factor(variable))) + 
      scale_y_continuous(limits=c(0,1), breaks=seq(0,1,0.2)) +
      geom_bar(stat="identity",alpha=alpha()) +
      scale_fill_mine(name="") + 
      ylab("Probability of target attainment") + xlab("") + 
      theme(legend.position="bottom")  +
      geom_text(aes(x=variable,y=(value-0.05),label=signif(value,2)),
                color="white",fontface=2)
    return(p1)
  })
})



