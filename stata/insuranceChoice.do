 import delimited "/Users/tshrum/Projects/drought_decision_model/AEPP/data/ranchers.csv", case(preserve) numericcols(2 13 15 77 88 89 91 93 94 95) clear 
  
 gen control = !trt
 gen trtXyear = trt*year
 gen controlXyear = control*year
 xtset simID year
 destring ranchingIncome, replace force
 destring risk, replace force
 destring riskXtrt, replace force
 destring droughtSeverity, replace force
 destring usdm, replace force

* Insurance choice (in game)
xtlogit insured risk i.year if(year > 8), vce(robust) 
xtlogit insured trt i.year if(year > 8), vce(robust) 
xtlogit insured trt risk i.year if(year > 8), vce(robust) 
xtlogit insured trt risk riskXtrt i.year if(year > 8), vce(robust) 
logit insured trt if(year == 9)
est sto i9_1
display exp
logit insured trt if(year == 10)
est sto i10_1
logit insured trt risk if(year == 9)
est sto i9_2
logit insured trt risk if(year == 10)
est sto i10_2
logit insured trt risk riskXtrt if(year == 9)
est sto i9_3
logit insured trt risk riskXtrt if(year == 10)
est sto i10_3
tab insured if(year == 9 & trt == 1 | year == 10 & trt == 1)
tab insured if(year == 10 & trt == 1)
tab insured if(year == 9 & trt == 0 | year == 10 & trt == 0)
tab insured if(year == 9 & trt == 0)
tab insured if(year == 10 & trt == 0)

esttab i9_1 i10_1 i9_2 i10_2 i9_3  i10_3 using "AEPP/results/gameInsPurchase.tex", f replace ///
	booktabs b(3) se(3)  ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	coeflabels(trt "Insurance Treatment" risk "Coef. Risk Aversion" riskXtrt "Risk Aversion X Treatment" _cons "Constant") ///
	stats(N r2_p, fmt(0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Pseudo R2"')) ///
	mtitles("Year 9" "Year 10" "Year 9" "Year 10" "Year 9" "Year 10")

logistic insured trt if(year == 9)
logistic insured trt if(year == 10)
logistic insured trt risk riskXtrt if(year == 9)
logistic insured trt risk riskXtrt if(year == 10)

logit insured risk if(year == 9)
logit insured risk if(year == 10)

  
* Insurance purchase likelihood
reg likelihoodPRF trt if(year == 10)
est sto insL1  
reg likelihoodPRF trt risk if(year == 10)
est sto insL2
reg likelihoodPRF trt risk trtXrisk if(year == 10)
est sto insL3

reg likelihoodPRF trt if(risk > 0 & year == 10)
reg likelihoodPRF trt if(risk <= 0 & year == 10)

reg likelihoodPRF trt if(risk > 0.28 & year == 10)
reg likelihoodPRF trt if(risk <= 0.28 & year == 10)

reg likelihoodPRF trt if(risk > 0.545 & year == 10)
reg likelihoodPRF trt if(risk <= 0.545 & year == 10)



esttab insL1 insL2 insL3 using "AEPP/results/insuranceLikelihood.tex", replace ///
	booktabs b(3) se(3)  ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	coeflabels(trt "Insurance" risk "Coef. Risk Aversion" riskXtrt "Risk Aversion X Insurance") ///
	stats(N ar2, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"'))
