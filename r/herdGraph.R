# Herd Graph

dr$groupByYear <- NA
dr$groupByYear <- ifelse(dr$trt == 1, 
                         paste(as.character(dr$year), "trt", sep = ""), 
                         paste(as.character(dr$year), "control", sep = "")) 
dr %>%
  select(year, trt, herd, hay) %>%
  filter(trt == 1) -> drTrt
dr %>%
  select(year, trt, herd, hay) %>%
  filter(trt == 0) -> drCtl
table(dr$groupByYear, dr$trt)
drTrt %>% 
  group_by(year) %>%
  summarize(herdMean = mean(herd)) %>%
  mutate (group = "Insurance", experiment = "Ranchers") -> rAvgHerdOverTimeTrt
drCtl %>% 
  group_by(year) %>%
  summarize(herdMean = mean(herd))  %>%
  mutate (group = "Control", experiment = "Ranchers") -> rAvgHerdOverTimeCtl
rAvgHerdOverTime <- rbind(rAvgHerdOverTimeTrt, rAvgHerdOverTimeCtl)

ggplot(data = rAvgHerdOverTime, aes(x = year, y = herdMean, color = group)) +
  geom_line()

dm$groupByYear <- NA
dm$groupByYear <- ifelse(dm$trt == 1, 
                         paste(as.character(dm$year), "trt", sep = ""), 
                         paste(as.character(dm$year), "control", sep = "")) 
dm %>%
  select(year, trt, herd, hay) %>%
  filter(trt == 1) -> dmTrt
dm %>%
  select(year, trt, herd, hay) %>%
  filter(trt == 0) -> dmCtl
table(dm$groupByYear, dm$trt)
dmTrt %>% 
  group_by(year) %>%
  summarize(herdMean = mean(herd)) %>%
  mutate (group = "Insurance", experiment = "MTurkers") -> mAvgHerdOverTimeTrt
dmCtl %>% 
  group_by(year) %>%
  summarize(herdMean = mean(herd))  %>%
  mutate (group = "Control", experiment = "MTurkers") -> mAvgHerdOverTimeCtl
mAvgHerdOverTime <- rbind(mAvgHerdOverTimeTrt, mAvgHerdOverTimeCtl)

ggplot(data = rAvgHerdOverTime, aes(x = year, y = herdMean, color = group)) +
  geom_line() +
  geom_line(data = mAvgHerdOverTime, aes(x = year, y = herdMean, color = group)) +
  annotate(geom = "text", x=8.5, y=450, label="MTurkers", size = 6) +
  annotate(geom = "text", x=8.5, y=590, label="Ranchers", size = 6) +
  labs(color='Treatment Group') +
  ylab("Average Herd Size") +
  xlab("Year") + 
  theme(text = element_text(size = 20))
