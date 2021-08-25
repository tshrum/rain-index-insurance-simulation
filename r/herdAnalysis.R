# Herd Size Analysis

#### Fixed effects model with individual and year dummies, lagged year terms, and cluster robust errors ###

# Treatment Variable Only
fe_MTurk <- lm(herd ~ 1 + trt + herdy_1 + herdy_2 + factor(simID) + factor(year), data = dm)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = dm$simID, test = "naive-t")[1:4,]

fe_MTurk <- lm(herd ~ 1 + trt + herdy_1 + herdy_2 + factor(year), data = dm)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = dm$simID, test = "naive-t")[1:4,]

fe_MTurk1 <- lm(herd ~ 1 + trt + herdy_1 + herdy_2 + factor(simID) + factor(year), data = dm1)
summary(fe_MTurk1)
coef_test(fe_MTurk1, vcov = "CR1", 
          cluster = dm1$simID, test = "naive-t")[1:4,]

fe_Ranchers <- lm(herd ~ 1 + trt + herdy_1 + herdy_2 +  factor(simID) + factor(year), data = dr)
summary(fe_Ranchers)
coef_test(fe_Ranchers, vcov = "CR1", 
          cluster = dr$simID, test = "naive-t")[1:4,]

fe_Ranchers1 <- lm(herd ~ 1 + trt + herdy_1 + herdy_2 +  factor(simID) + factor(year), data = dr1)
summary(fe_Ranchers1)
coef_test(fe_Ranchers1, vcov = "CR1", 
          cluster = dr1$simID, test = "naive-t")[1:4,]



# Risk Aversion and Treatment with an interaction term
fe_MTurk <- lm(herd ~ 1 + trt + risk + riskXtrt + herdy_1 + herdy_2 + factor(simID) + factor(year), data = dm)
summary(fe_MTurk)
coef_test(fe_MTurk, vcov = "CR1", 
          cluster = dm$simID, test = "naive-t")[1:6,]

fe_MTurk1 <- lm(herd ~ 1 + trt + risk + riskXtrt +  herdy_1 + herdy_2 + factor(simID) + factor(year), data = dm1)
summary(fe_MTurk1)
coef_test(fe_MTurk1, vcov = "CR1", 
          cluster = dm1$simID, test = "naive-t")[1:6,]

fe_Ranchers <- lm(herd ~ 1 + trt + risk + riskXtrt + herdy_1 + herdy_2 +  factor(simID) + factor(year), data = dr)
summary(fe_Ranchers)
coef_test(fe_Ranchers, vcov = "CR1", 
          cluster = dr$simID, test = "naive-t")[1:4,]

fe_Ranchers1 <- lm(herd ~ 1 + trt + risk + riskXtrt + herdy_1 + herdy_2 +  factor(simID) + factor(year), data = dr1)
summary(fe_Ranchers1)
coef_test(fe_Ranchers1, vcov = "CR1", 
          cluster = dr1$simID, test = "naive-t")[1:4,]

fe_Ranchers1 <- lm(herd ~ 1 + trt + risk + herdy_1 + herdy_2 +  factor(simID) + factor(year), data = dr1)
summary(fe_Ranchers1)
coef_test(fe_Ranchers1, vcov = "CR1", 
          cluster = dr1$simID, test = "naive-t")[1:4,]


fe_RanchersHighRisk <- lm(herd ~ 1 + trt + herdy_1 + herdy_2 +  factor(simID) + factor(year), data = drHighRiskAv)
summary(fe_RanchersHighRisk)
coef_test(fe_RanchersHighRisk, vcov = "CR1", 
          cluster = drHighRiskAv$simID, test = "naive-t")[1:4,]

fe_RanchersLowRisk <- lm(herd ~ 1 + trt + risk + herdy_1 + herdy_2 +  factor(simID) + factor(year), data = drLowRiskAv)
summary(fe_RanchersLowRisk)
coef_test(fe_RanchersLowRisk, vcov = "CR1", 
          cluster = drLowRiskAv$simID, test = "naive-t")[1:4,]

fe_RanchersLowRisk <- lm(herd ~ 1 + trt + risk + riskXtrt + herdy_1 + herdy_2 +  factor(simID) + factor(year), data = drRiskBalance)
summary(fe_RanchersLowRisk)
coef_test(fe_RanchersLowRisk, vcov = "CR1", 
          cluster = drRiskBalance$simID, test = "naive-t")[1:4,]


# Think more about this model
# GLMM with Poisson distribution, year fixed effects, and individual random effects
rep <- lme4::lmer(herd ~ 1 +  trt + risk + riskXtrt + factor(year) + (1 | simID), data = dr1)
summary(rep)







