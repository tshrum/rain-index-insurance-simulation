# Summary Stats
library(vtable)
library(dplyr)
library(stargazer)


m <- dm[!duplicated(dm$simID),]
r <- dr[!duplicated(dr$simID),]

r$risk <- as.factor(r$risk)
m$risk <- as.factor(m$risk)

r %>% select(gender, age, education, vote, environmentalist, risk, ranchingIncomePercent, yearsRanching, privateLand, 
             droughtInfo_USDM, purchasedPRF, purchaseFreqPRF, paysOffPRF, accuratePRF,
             acres, herdSize, droughtResponseBuyFeed, state) -> r

m %>% select(gender, age, education, vote, environmentalist, risk, cattleKnowledge, droughtKnowledge, veggieOrVegan) -> m


stargazer(r, type = "text")

st(r,
   out = 'latex',
   file='results/rancherSumStats.tex')

stargazer(m, type = "text")

st(m,
   out = 'latex',
   file='results/mturkSumStats.tex')


r %>% select(risk) -> r1
