# Varaiables used for analysis in for Shrum & Travis 2021

# abbreviating dataframes
dm <- rMTurk 
dr <- rRanchers

# adding variable "year" to use a number instead of the actual year
dm$year <- dm$yr_num - 1998
dr$year <- dr$yr_num - 1998 
table(dm$year, dm$year)
table(dr$year, dr$year)

# "trt" indicates that they are in the treatment group with insurance
# for the ranchers, insurance availability varied: in years 1-2, no one had insurance; in years 
table(dm$trt, dm$year)
table(dr$trt, dr$year)

# "insured" indicates that they have insurance in that year
# for the ranchers, insurance availability varied: in years 1-2, no one had insurance; in years 
table(dm$insured, dm$year)
table(dr$insured, dr$year)

# dropping "ins" variable with duplicates "trt" and is ambiguous with "insured"
dm %>% select(-ins) -> dm
#dr %>% select(-ins) -> dr

# "risk" is coefficient for risk aversion, measured with Holt & Laury 2002 methods. 
# higher number is more risk averse, lower number is less risk averse
table(dm$risk)
table(dr$risk)

# "riskXtrt" is an interaction term between risk and trt. 
dm$riskXtrt <- dm$risk * dm$trt
dr$riskXtrt <- dr$risk * dr$trt

# "herd" is the number of cattle in the herd in each year. 
hist(dm$herd)
hist(dr$herd)
summary(dr$herd)

# "herdy_1" is the number of cattle in the previous year; "herdy_2" is the number of cattle two years prior (this number is a factor in the calf birth rate). In year 1, this is assumed to be 600, the starting herd size
plot(x = dm$herdy_1, y = dm$herd)
plot(x = dm$herdy_2, y = dm$herd)

# "hay" is the amount of money spent on hay in each year (Units?)
hist(dm$hay)
hist(dr$hay)

# "payoffPerceptionPRF": "even" = 0, "gain" = 1, "lose" = -1
dr$payoffPerceptionPRF <- NA
dr$payoffPerceptionPRF <- ifelse(dr$paysOffPRF == "even", 0, dr$payoffPerceptionPRF)
dr$payoffPerceptionPRF <- ifelse(dr$paysOffPRF == "gain", 1, dr$payoffPerceptionPRF)
dr$payoffPerceptionPRF <- ifelse(dr$paysOffPRF == "lose", -1, dr$payoffPerceptionPRF)
dr$prfPerceptionLoss <- ifelse(dr$paysOffPRF == "lose", 1, 0)

# "female" 
dr$female <- NA
dr$female <- ifelse(dr$gender == "Male", 0, dr$female)
dr$female <- ifelse(dr$gender == "Female", 1, dr$female)

dm$female <- NA
dm$female <- ifelse(dm$gender == "Male", 0, dm$female)
dm$female <- ifelse(dm$gender == "Other", 0, dm$female)
dm$female <- ifelse(dm$gender == "Female", 1, dm$female)

# "usesUSDM"
dr$usdm <- NA
dr$usdm <- ifelse(dr$droughtInfo_USDM == "Heard of it, but not used", 0, dr$usdm)
dr$usdm <- ifelse(dr$droughtInfo_USDM == "Use occasionally", 1, dr$usdm)
dr$usdm <- ifelse(dr$droughtInfo_USDM == "Use regularly", 2, dr$usdm)
table(dr$usdm, dr$droughtInfo_USDM)

# "droughtSeverity" 
dr$droughtSeverity <- as.numeric(dr$droughtSeverity)

# There isn't enough variation in baseline herd to make this meaningful
dr %>% filter(year < 3) %>%
  group_by(simID) %>%
  summarize(baselineHerd = mean(herd)) -> x

# Baseline hay does have variation
dr %>% filter(year < 3) %>%
  group_by(simID) %>%
  summarize(baselineHay = mean(hay)) %>%
  full_join(dr, by = "simID") -> dr

# educ
dr$educ <- as.numeric(dr$education) 
table(dr$educ, dr$education)

dm$educ <- as.numeric(dm$education) 
table(dm$educ, dm$education)

# ranching income
dr$ranchingIncome <- dr$ranchingIncome/10000

# likelihoodPRF
dr$likelihoodPRF <- NA
dr$likelihoodPRF <- ifelse(dr$likelyToPurchasePRF == "Extremely Likely", 6, dr$likelihoodPRF)
dr$likelihoodPRF <- ifelse(dr$likelyToPurchasePRF == "Moderately likely", 5, dr$likelihoodPRF)
dr$likelihoodPRF <- ifelse(dr$likelyToPurchasePRF == "Slightly likely", 4, dr$likelihoodPRF)
dr$likelihoodPRF <- ifelse(dr$likelyToPurchasePRF == "Neither likely nor unlikely", 3, dr$likelihoodPRF)
dr$likelihoodPRF <- ifelse(dr$likelyToPurchasePRF == "Slightly unlikely", 2, dr$likelihoodPRF)
dr$likelihoodPRF <- ifelse(dr$likelyToPurchasePRF == "Extremely unlikely", 1, dr$likelihoodPRF)
dr$likelihoodPRF <- scale(dr$likelihoodPRF)

# Lagged Cash Assets
table(dr$cash_1, dr$year)
