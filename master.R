# Master Script
# Experiments in Ranching: Rain-Index Insurance and Investment in Production and Drought Risk Management
# Shrum & Travis 2021
# Code for manuscript submitted to Applied Economic Perspectives & Policy

# Load required packages (Note: Not all of these packages are required. Consider paring down the list if just running analysis without rerunning the full model.)
source("r/loadPackages.R")

# Load ranch game data
load("data/droughtGame_MTurk.RData")
load("data/droughtGame_Ranchers.RData")

# Data Variables (summary and additional changes)
source("r/vars.R")

# Creating dataframes with subsets of data
source("r/dataframes.R")


# Analysis: see stata folder for analysis code