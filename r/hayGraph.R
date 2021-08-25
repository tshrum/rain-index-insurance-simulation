# Hay Graph

dr$hayPerCow <- dr$hay/dr$herdy_1

dr %>%
  select(hay, herd, hayPerCow, risk, trt, insured, year) -> x

x %>%
  group_by(trt, year) %>%
  summarize(meanHayPerCow = mean(hayPerCow)*1000) -> y

y$trt <- as.factor(y$trt)

ggplot(data = y, aes(x = year, y = meanHayPerCow, fill = trt)) +
  geom_bar(stat = "identity", position='dodge')

x %>%
  filter(!is.na(risk)) %>%
  group_by(risk, year) %>%
  summarize(meanHayPerCow = mean(hayPerCow)*1000) -> y

y$trt <- as.factor(y$trt)
y$risk <- as.factor(y$risk)
ggplot(data = y, aes(x = year, y = meanHayPerCow, fill = risk)) +
  geom_bar(stat = "identity", position='dodge')

x %>%
  filter(!is.na(risk)) %>%
  group_by(trt, risk, year) %>%
  summarize(meanHayPerCow = mean(hayPerCow)*1000) -> y

y$trt <- as.factor(y$trt)
y$risk <- as.factor(y$risk)
ggplot(data = y, aes(x = year, y = meanHayPerCow, fill = trt)) +
  geom_bar(stat = "identity", position='dodge') +
  facet_wrap(~risk)

