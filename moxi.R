library(mrgsolve)
library(dplyr)
library(ggplot2)
library(dmutate)

# Load moxi_ode model
mod <- mread("moxi_ode") %>% update(end=272)


# Just check out the model with 400 mg IV Qd x 10

# First, event object
e <- ev(amt=400, ii=24, addl=9)

# Simulate
out <- 
  mod %>%
  ev(amt=400, ii=24, addl=9) %>% 
  mrgsim(end=272)

# plot
plot(out)

plot(out, IPRED ~.)

# Generate population of 25 individuals (reference covariates)
idata <- data_frame(ID=1:25)

# and simulate

mod %>%
  ev(e) %>%
  idata_set(idata) %>%
  mrgsim %>% plot(IPRED ~.)

# Simulate some covariates (covset)

cov <- covset(WT[40,150] ~ rlnorm(log(80),0.5),
              SEX ~ rbinomial(0.5))

idata <- 
  data_frame(ID=1:250) %>%
  mutate_random(cov)

out <- 
  mod %>% 
  ev(e) %>% idata_set(idata) %>%
  mrgsim(delta=0.25, end=72) 

plot(out,log(IPRED) ~., subset=time <=72)

