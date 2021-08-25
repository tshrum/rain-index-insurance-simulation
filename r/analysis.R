# Analysis for Manuscript for Submission to AAEP

# Data checks
table(rMTurk$insured, rMTurk$yr)
table(rRanchers$insured, rRanchers$yr)
table(rMTurk$trt, rMTurk$yr)
table(rRanchers$trt, rRanchers$yr)
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



# Fixed effects model with individual and year dummies and cluster robust errors

# MTurk
fe_MTurk <- lm(herd ~ 1 + ins + factor(simID) + factor(yr), data = rMTurk)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = rMTurk$simID, test = "naive-t")[1:2,]

fe_MTurk <- lm(herd ~ 1 + ins + herdy_1 + factor(simID) + factor(yr), data = rMTurk)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = rMTurk$simID, test = "naive-t")[1:3,]

fe_MTurk <- lm(herd ~ 1 + ins + risk_std + herdy_1 + factor(simID) + factor(yr), data = rMTurk)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = rMTurk$simID, test = "naive-t")[1:4,]

fe_MTurk <- lm(herd ~ 1 + ins + risk_std + trtXrisk + herdy_1 + factor(simID) + factor(yr), data = rMTurk)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = rMTurk$simID, test = "naive-t")[1:4,]


fe_MTurk <- lm(herd ~ 1 + ins + risk_std + trtXrisk + herdy_1 + factor(simID) + factor(yr), data = rMTurk)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = rMTurk$simID, test = "naive-t")[1:4,]

fe_MTurk <- lm(herd ~ 1 + ins + risk_std + trtXrisk + herdy_1 + factor(simID) + factor(yr), data = rMTurk2)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = rMTurk2$simID, test = "naive-t")[1:4,]



# Ranchers
fe_Ranchers <- lm(herd ~ 1 + trt + factor(simID) + factor(yr), data = rRanchers)
summary(fe_Ranchers)
coef_test(fe_Ranchers, vcov = "CR1", 
          cluster = rRanchers$simID, test = "naive-t")[1:3,]

fe_Ranchers <- lm(herd ~ 1 + trt + risk_std + factor(simID) + factor(yr), data = rRanchers)
summary(fe_Ranchers)
coef_test(fe_Ranchers, vcov = "CR1", 
          cluster = rRanchers$simID, test = "naive-t")[1:3,]

fe_Ranchers <- lm(herd ~ 1 + trt + risk_std + trtXrisk + factor(simID) + factor(yr), data = rRanchers)
summary(fe_Ranchers)
coef_test(fe_Ranchers, vcov = "CR1", 
          cluster = rRanchers$simID, test = "naive-t")[1:4,]

