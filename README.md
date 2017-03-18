# Developing Interactive Visualization Tools for Model-Supported R&D
  
  


## Details
  - When: Saturday, March 18 2017
  - Where: Omni Shoreham Hotel, Washington, DC
  
## Summary

This tutorial session provides an overview to help you get started creating interactive web apps to visualize 
modeling and simulation based decision-making. In this tutorial, we’ll review the following tools:

  - [Shiny](https://shiny.rstudio.com/) an `R` package from `RStudio` that can be used to create interactive web applications powered by `R`.
  - [mrgsolve](http://mrgsolve.github.io) a free, open-source modeling and simulation platform from `MetrumRG` to support ODE-based PKPD and QSP model development in `R`.
  - [Metworx Envision](http://metrumrg.com/metworx.html) a distributed, interactive cloud-based platform from `MetrumRG` that allows you to develop and deploy Shiny apps.

Shiny apps, which can be further tailored with mrgsolve, can be shared with end users to allow both technical and non-technical users to interact with potentially complicated models through a non-technical interface. This puts the power of your modeling and simulation work directly in the hands of the decision-makers on your development team. During this tutorial, we'll show you how to translate a PKPD model using mrgsolve format, introduce Shiny design code, and show you examples of how Metworx Envision can be used by decision-makers in a drug-development program.

## Outline
  - Introduction to model-based decision making with interactive, distributed apps
  - Case study: build a model-based app starting from a literature publication all the way to deployment to the decision-making team
  - Demonstration of the Metworx Envision platform for sharing apps
  - Hands-on time working with several demonstration apps developed in the drug-development space
  - Important points to consider when developing and deploying apps to drug development teams
  - Discussion / Q&A time

## Content
  - `templates/` a directory with templates you can use for your next project
  - `moxi2/` the moxifloxacin PK dashboard app developed during the tutorial
  - `pkg/` `R` packages used in the tutorial; note: all packages are provided as source code; appropriate compilers
  are required for installing these packages (the same compilers required for installing and using `mrgsolve`)
  - `moxi/` contains Wicha et al. moxifloxacin model files from `DDMoRe` model repository
  - `flexdashboard.Rmd` an `rmarkdown` document with `Shiny` and `mrgsolve` elements
  - `moxi.cpp` A `mrgsolve` translation of the Wicha moxifloxacin model that calculates model 
  compartments in closed-form
  - `moxi.cpp` A `mrgsolve` translation of the Wicha moxifloxacin model that employs ordinary differential 
  equations.  This model also includes AUC from time 0-24 and 48-72 in the simulated output.
  - `pkgSetup.R` and `R` script that installs packages from source 

