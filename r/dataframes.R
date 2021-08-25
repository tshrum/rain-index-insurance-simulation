# Dataframes for Analysis
# Note: I am using different dataframes instead of subsetting the same dataframe because it works better
# with my cluster robust error code

# MTurk Study - Primary Data for Analysis
# dm1 is the main dataframe for analysis that is passed to Stata. 
    # It excludes year 10 of the game and removes participants who reduced their herd size below 300 or over 1200 at any point in the simulation.

# Rancher Study - there were no outliers, so no data was removed prior to analysis


# Creating dataframes that limit outliers from MTurk
# Removing outliers from MTurk who have herds more than double the recommended level or less than half the recommended level
dm %>% filter(year < 10) -> dm_9yrs
dm_9yrs %>% 
  filter(herd > 1200) %>% 
  select(simID, herd) %>% 
  group_by(simID) %>%
  filter(herd == max(herd)) -> bigHerdOutliers

dm_9yrs %>% 
  filter(herd < 300) %>% 
  select(simID, herd) %>% 
  group_by(simID) %>%
  filter(herd == min(herd)) %>%
  distinct(simID, herd) -> smallHerdOutliers

outliers <- rbind(bigHerdOutliers, smallHerdOutliers)

dm_9yrs %>% filter(!(simID %in% outliers$simID)) -> dm1


# Dataframe of ranchers only for Insurance Required for treatment group years 
dr %>% filter(year > 2 & year < 9) -> dr1
dr %>% filter(year > 2) -> dr2
dr %>% filter(year > 8) -> drFinalYears

dr1 %>% filter(risk < 0.545) -> drLowRiskAv
dr1 %>% filter(risk > .5) -> drHighRiskAv

table(dr1$risk, dr1$trt)
dr1 %>% filter(risk >= 0) -> drRiskBalance



write_csv(dr, file = "data/ranchers.csv")
write_csv(dm1, file = "data/mturkers.csv")

dr %>% select(simID, trt, hay, herd, risk, riskXtrt, herdy_1, year, assets.cash) %>%
  mutate(study = "Ranchers") -> d
dm %>% select(simID, trt, hay, herd, risk, riskXtrt, herdy_1, year, assets.cash) %>%
  mutate(study = "MTurkers") -> d1
dBoth <- rbind(d, d1)
write_csv(dBoth, file = "data/combined.csv")


