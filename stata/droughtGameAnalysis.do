





 clear
**************
** Ranchers **
**************
 
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
 
 
 
* HERD 
xtreg herd herdy_1 trt if(year > 2), vce(robust)
est sto r1
xtreg herd herdy_1 trt risk if(year > 2), vce(robust)
est sto r2
xtreg herd herdy_1 trt risk riskXtrt if(year > 2), vce(robust)
est sto r3

* HAY
* baseline hay is the average hay purchase in the first two years when no one had insurance
gen hayDemeaned = hay - baselineHay 
mixed hayDemeaned trt herdy_1 i.year if(year > 2) || simID: trt, vce(robust)
est sto r1
mixed hayDemeaned trt risk herdy_1 i.year if(year > 2) || simID: trt, vce(robust)
est sto r2
mixed hayDemeaned trt risk riskXtrt herdy_1  i.year if(year > 2) || simID: trt,  vce(robust)
est sto r3

import delimited "/Users/tshrum/Projects/drought_decision_model/AEPP/data/mturkers.csv", case(preserve) clear

 gen control = !trt
 gen trtXyear = trt*year
 gen controlXyear = control*year
 xtset simID year
 destring risk, replace force
 destring riskXtrt, replace force
 destring cattleKnowDummy, replace force
 destring droughtImpact, replace force
 destring age, replace force
 destring female, replace force
 destring educ, replace force 
 destring income, replace force
 destring environmentalist, replace force

mixed hay trt herdy_1 i.year, || simID:, vce(robust)
est sto m1
mixed hay trt risk herdy_1 i.year, || simID:, vce(robust)
est sto m2
mixed hay trt risk riskXtrt herdy_1 i.year, || simID:, vce(robust)
est sto m3

esttab r1 m1 r2 m2 r3 m3 using hay.tex, replace f ///
	booktabs b(3) se(3)  ///
	keep(trt risk riskXtrt herdy_1) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	coeflabels(trt "Insurance" risk "Coef. Risk Aversion" riskXtrt "Risk Aversion X Insurance" herdy_1 "Herd Size") ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"')) ///
	mtitles("Ranchers" "MTurkers" "Ranchers" "MTurkers" "Ranchers" "MTurkers") ///
	addnotes("Random effects regression with cluster robust standard errors.")


reg hayDemeaned trt if(year > 2 & risk < 0), vce(cluster simID)
reg hayDemeaned trt if(year > 2 & risk == 0), vce(cluster simID)
reg hayDemeaned trt if(year > 2 & risk == 0.28), vce(cluster simID)
reg hayDemeaned trt if(year > 2 & risk <= 0.545), vce(cluster simID)
reg hayDemeaned trt if(year > 2 & risk > 0.545), vce(cluster simID)



xtreg hayDemeaned trt i.year if(year > 2 & year < 9), vce(robust)
mixed hayDemeaned trt risk riskXtrt herdy_1 i.year if(year > 2 & year < 9), vce(cluster simID)
reg hayDemeaned trt risk riskXtrt herdy_1 i.year if(year > 2 & year < 9), vce(cluster simID)
mixed hayDemeaned trt risk riskXtrt yearsRanching educ ranchingIncome female environmentalist i.year if(year > 2 & year < 9), vce(robust)
mixed hayDemeaned trt risk riskXtrt ranchingIncome environmentalist  i.year if(year > 2 & year < 9), vce(robust)


import delimited "/Users/tshrum/Projects/drought_decision_model/AEPP/data/mturkers.csv", case(preserve) clear

 gen control = !trt
 gen trtXyear = trt*year
 gen controlXyear = control*year
 xtset simID year
 destring risk, replace force
 destring riskXtrt, replace force
 destring cattleKnowDummy, replace force
 destring droughtImpact, replace force
 destring age, replace force
 destring female, replace force
 destring educ, replace force 
 destring income, replace force
 destring environmentalist, replace force
 
xtreg herd herdy_1 trt, vce(robust)
est sto m1
xtreg herd herdy_1 trt risk, vce(robust)
est sto m2
xtreg herd herdy_1 trt risk riskXtrt, vce(robust)
est sto m3

esttab r1 m1 r2 m2 r3 m3 using herd.tex, replace f ///
	booktabs b(3) se(3)  ///
	keep(trt risk riskXtrt) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	coeflabels(trt "Insurance" risk "Coef. Risk Aversion" riskXtrt "Risk Aversion X Insurance") ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"')) ///
	mtitles("Ranchers" "MTurkers" "Ranchers" "MTurkers" "Ranchers" "MTurkers") ///
	addnotes("Random effects regression with cluster robust standard errors.")
	









mixed herd trtXyear controlXyear risk riskXtrt i.year if(year > 2 & year < 9), vce(robust)


mixed herd risk riskXtrt trt#i.year if(year > 2 & year < 9), vce(robust)

xtreg herd trt risk riskXtrt trt#i.year if(year > 2 & year < 9), fe


mixed herd trt herdy_1 i.year i.simID if(year > 2 & year < 9)
mixed herd trt herdy_1 i.year if(year > 2 & year < 9) || simID:, 
mixed herd trt herdy_1 i.year if(year > 2 & year < 9) || simID: trt, 

mixed herd trt risk riskXtrt herdy_1 i.year if(year > 2 & year < 9), vce(robust)
mixed herd trt risk riskXtrt herdy_1 i.year i.simID if(year > 2 & year < 9), vce(robust)
mixed herd trt risk riskXtrt herdy_1 i.year if(year > 2 & year < 9) || simID:, 
mixed herd trt risk riskXtrt herdy_1 i.year if(year > 2 & year < 9) || simID: trt


mixed herd trt control trtXyear controlXyear i.year if(year > 2 & year < 10), nocons vce(robust) 
mixed herd trt control trtXyear controlXyear risk riskXtrt i.year if(year > 2 & year < 10), nocons vce(robust) 
mixed herd trt control trtXyear controlXyear risk riskXtrt yearsRanching educ ranchingIncome female environmentalist i.year if(year > 2 & year < 10), nocons vce(robust) 
mixed herd trt control trtXyear controlXyear risk riskXtrt age educ female yearsRanching ranchingIncome droughtSeverity usdm prfPerceptionLoss i.year if(year > 2 & year < 10), nocons vce(robust) 

 
mixed herd trtXyear year i.year i.simID if(year > 2 & year < 10), vce(robust) 
mixed herd trtXyear year i.year if(year > 2 & year < 10) || simID: trtXyear




* Insurance choice (in game)
xtlogit insured trt i.year if(year > 8), vce(robust) 
xtlogit insured trt risk i.year if(year > 8), vce(robust) 
xtlogit insured trt risk riskXtrt i.year if(year > 8), vce(robust) 
logit insured trt if(year == 9)
logit insured trt if(year == 10)
logit insured trt risk if(year == 9)
logit insured trt risk if(year == 10)
logit insured trt risk riskXtrt if(year == 9)
logit insured trt risk riskXtrt if(year == 10)
tab insured if(year == 9 & trt == 1 | year == 10 & trt == 1)
tab insured if(year == 10 & trt == 1)
tab insured if(year == 9 & trt == 0 | year == 10 & trt == 0)
tab insured if(year == 9 & trt == 0)
tab insured if(year == 10 & trt == 0)
  
* Insurance purchase likelihood
reg likelihoodPRF trt
reg likelihoodPRF trt risk
reg likelihoodPRF trt risk trtXrisk
 
 
**************
** MTurkers **
**************
clear 
import delimited "/Users/tshrum/Projects/drought_decision_model/AEPP/data/mturkers.csv", case(preserve) clear

 gen control = !trt
 gen trtXyear = trt*year
 gen controlXyear = control*year
 xtset simID year
 destring risk, replace force
 destring riskXtrt, replace force
 destring cattleKnowDummy, replace force
 destring droughtImpact, replace force
 destring age, replace force
 destring female, replace force
 destring educ, replace force 
 destring income, replace force
 destring environmentalist, replace force


* HERD 
graph twoway (line herd year, connect(ascending)), by(trt)
mixed herd trt control trtXyear controlXyear i.year, nocons vce(robust)
test trtXyear = controlXyear
mixed herd trt control trtXyear controlXyear risk riskXtrt i.year, nocons vce(robust)

*** I like this one...
mixed herd trtXyear controlXyear risk riskXtrt i.year if(year < 9), vce(robust)


mixed herd trt risk riskXtrt herdy_1 i.year if(year < 9), vce(robust)

mixed herd trt control trtXyear controlXyear risk riskXtrt i.year, nocons ///
	|| simID: trt trtXyear,  nocons ///
	|| simID: control controlXyear, nocons 
mixed herd trt herdy_1 trtXyear risk riskXtrt i.year cattleKnowDummy attentionFail age female educ income environmentalist droughtImpact, vce(robust)


* HAY
* RE model - 
mixed hay trt herdy_1 i.year, || simID:, vce(robust)
mixed hay trt risk herdy_1 i.year, || simID:, vce(robust)
mixed hay trt risk riskXtrt herdy_1 i.year, || simID:, vce(robust)
mixed hay trt risk riskXtrt herdy_1 i.year cattleKnowDummy age female educ income environmentalist droughtImpact, || simID:, vce(robust)


reg hay herdy_1 trt if(risk <= 0.545), vce(cluster simID)
reg hay herdy_1 trt if(risk >= 0.852), vce(cluster simID)





