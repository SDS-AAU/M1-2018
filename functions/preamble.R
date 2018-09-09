
### setWD
Sys.setenv(LANG = "en")
require(rstudioapi); setwd(dirname(rstudioapi::getActiveDocumentContext()$path)); getwd()
rm(list=ls())
graphics.off()

# Standard functions
source("C:/Users/Admin/R_functions/base_functions.R"); detachAllPackages(); rm(detachAllPackages)

### Load packages
# Standard
library(plyr)
library(tidyverse)
library(magrittr)
library(data.table)
library(skimr)