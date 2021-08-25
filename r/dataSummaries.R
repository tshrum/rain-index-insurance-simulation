# Data Summaries for Shrum & Travis 2021

 
# Data Summary of relevant variables

table(rMTurk$herdy_1, rMTurk$yr)

hist(rMTurk$herd)
hist(rRanchers$herd)

hist(rMTurk$risk)
hist(rRanchers$risk)
hist(rMTurk$risk_std)
hist(rRanchers$risk_std)

rRanchers %>% select(risk, trt, simID) %>% mutate(group = "Ranchers") %>% distinct() -> driskR
rMTurk %>% select(risk, trt, simID) %>% mutate(group = "MTurkers") %>% distinct() -> driskM
drisk <- rbind(driskR, driskM)

ggplot(data = drisk, aes(x = risk)) +
  geom_density(color = group)


plot(x = dm$year, y = dm$herd)
dm %>% filter(year == 1) -> x
summary(x$herd)
dm %>% filter(year == 10) -> x
summary(x$herd)
dm %>% filter(year == 9) -> x
summary(x$herd)
dm %>% filter(year == 8) -> x
summary(x$herd)


table(dm1$trt, dm1$risk)
table(dr1$trt, dr1$risk)

#### Participant Summaries ####
dr %>% filter(!duplicated(simID)) -> r
dm %>% filter(!duplicated(simID)) -> m


summary(lm(risk ~ trt, data = m))
summary(lm(risk ~ trt, data = r))



#### Hay Purchases ####
# Create a graph that has
# y = average hay purchases across all years 
# x = risk aversion
# group = trt

dm1 %>% group_by(simID) %>%
  summarize(hayMean = mean(hay)) %>%
  left_join(dm1) %>%
  select(trt, risk, hayMean, simID) %>%
  unique() %>%
  group_by(trt, risk) %>%
  summarize(hayMean = mean(hayMean)) -> mHayData

ggplot(data = mHayData, aes(x = risk, y = hayMean, color = as.factor(trt))) +
  geom_point()


dr1 %>% group_by(simID) %>%
  summarize(hayMean = mean(hay)) %>%
  left_join(dm1) %>%
  select(trt, risk, hayMean, simID) %>%
  unique() %>%
  group_by(trt, risk) %>%
  summarize(hayMean = mean(hayMean)) -> mHayData

ggplot(data = mHayData, aes(x = risk, y = hayMean, color = as.factor(trt))) +
  geom_point()

dr1 %>% group_by(simID) %>%
  summarize(herdMean = mean(herd)) %>%
  left_join(dr1) %>%
  select(trt, risk, herdMean, simID) %>%
  unique() %>%
  group_by(trt, risk) %>%
  summarize(herdMean = mean(herdMean)) -> rHerdData

ggplot(data = rHerdData, aes(x = risk, y = herdMean, color = as.factor(trt))) +
  geom_point()
