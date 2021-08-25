
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
gen riskAverseTrt = insured==1 & risk > 0
gen riskAverse = 0
replace riskAverse = 1 if(risk > 0)

gen hayDemeaned = hay - baselineHay 
gen hayPerCow = hay/herdy_1*1000

xtset simID year

* HAY

xtreg hay trt herdy_1 i.year if(year <= 2), vce(robust)
xtreg hay trt risk herdy_1 i.year if(year <= 2), vce(robust)

xtreg hay trt herdy_1 i.year if(year > 2), vce(robust)
xtreg hay trt risk herdy_1 i.year if(year > 2), vce(robust)
xtreg hay trt risk riskXtrt herdy_1  i.year if(year > 2), vce(robust)

* hayDemeaned has the baseline hay subtracted from each hay purchase. Baseline hay is the average hay purchase in the first two years when no one had insurance
xtreg hayDemeaned trt herdy_1 i.year if(year > 2), vce(robust)
est sto r1
xtreg hayDemeaned trt risk herdy_1 i.year if(year > 2), vce(robust)
est sto r2
xtreg hayDemeaned trt risk riskXtrt herdy_1  i.year if(year > 2), vce(robust)
est sto r3
predict yhat
sort risk
twoway lfit yhat risk if trt == 1 || lfit yhat risk if trt == 0

matrix list e(b)
display _b[trt] + _b[risk] + _b[riskXtrt]

predict yhat
sort risk
twoway lfit yhat risk if trt == 1 || lfit yhat risk if trt == 0, ///
	legend(label (1 "Insurance") label(2 "No Insurance")) ///
	xtitle("Risk Aversion Coefficient") ///
	ytitle("Predicted Hay Purchase") ///
	title("b) Ranchers Study", justification(left))

summarize risk, detail
xtreg hayDemeaned trt herdy_1 i.year if(year > 2 & risk <= 0), vce(robust)
xtreg hayDemeaned trt herdy_1 i.year if(year > 2 & risk <= 0.28), vce(robust)
xtreg hayDemeaned trt herdy_1 i.year if(year > 2 & risk <= 0.545), vce(robust)
xtreg hayDemeaned trt herdy_1 i.year if(year > 2 & risk < 0.28), vce(robust)

xtreg hayDemeaned trt herdy_1 L.assetscash i.year if(year > 2), vce(robust)
est sto r1
xtreg hayDemeaned trt risk herdy_1 L.assetscash i.year if(year > 2), vce(robust)
est sto r2
xtreg hayDemeaned trt risk riskXtrt herdy_1 L.assetscash i.year if(year > 2), vce(robust)
est sto r3
predict yhat
sort risk
twoway lfit yhat risk if trt == 1 || lfit yhat risk if trt == 0



xtreg hay trt herdy_1 i.year L.assetscash if(risk <= 0 & (year == 3 | year== 4 | year == 6 | year == 8)), vce(robust)



mixed hayDemeaned trt risk riskXtrt herdy_1  i.year if(year > 2) || simID: trt,  vce(robust)

xtreg hay trt herdy_1 L.revins i.year if(year > 2), vce(robust)


gen riskInsRev = revins*riskAverse

xtreg hay L.revins riskAverse riskInsRev herdy_1 i.year, vce(robust)



xtreg hay trt baselineHay risk riskXtrt herdy_1 L.revins L.assetscash i.year if(year > 2), vce(robust)

xtreg hay trt baselineHay risk riskXtrt herdy_1 L.revins L.assetscash, vce(robust)


tostring risk, gen(riskChar)
encode riskChar, gen(riskCat)
table(riskCat)

tsset simID year
xtdidregress (hay herdy_1 i.year) (insured) if(year < 9 & riskAverse == 1), group(simID) time(year)


xtdidregress (hay L.assetscash herdy_1 i.year) (insured) if(year < 9 & riskAverse == 0), group(simID) time(year)

xtdidregress (hay L.assetscash herdy_1 i.year) (insured) if(riskAverse == 1), group(simID) time(year)
estat trendplots


xtdidregress (hay L.assetscash herdy_1 i.year) (insured) if(riskAverse == 0), group(simID) time(year)



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

xtreg hay trt herdy_1 i.year, vce(robust)
est sto m1
xtreg hay trt risk herdy_1 i.year, vce(robust)
est sto m2
xtreg hay trt risk riskXtrt herdy_1 i.year, vce(robust)
est sto m3

esttab r1 m1 r2 m2 r3 m3 using hay.tex, replace f ///
	booktabs b(3) se(3)  ///
	keep(trt risk riskXtrt herdy_1) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	coeflabels(trt "Insurance" risk "Coef. Risk Aversion" riskXtrt "Risk Aversion X Insurance" herdy_1 "Herd Size") ///
	stats(N, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"')) ///
	mtitles("Ranchers" "MTurkers" "Ranchers" "MTurkers" "Ranchers" "MTurkers") ///
	addnotes("Random effects regression with cluster robust standard errors.")
	
predict yhat
sort risk
twoway lfit yhat risk if trt == 1 || lfit yhat risk if trt == 0, ///
	legend(label (1 "Insurance") label(2 "No Insurance")) ///
	xtitle("Risk Aversion Coefficient") ///
	ytitle("Predicted Hay Purchase") ///
	title("a) MTurkers Study", justification(left))
	
xtreg hay trt herdy_1 L.assetscash i.year, vce(robust)
xtreg hay trt risk herdy_1 L.assetscash i.year, vce(robust)
xtreg hay trt risk riskXtrt herdy_1 L.assetscash i.year, vce(robust)

reg hayDemeaned trt if(year > 2 & risk < 0), vce(cluster simID)
reg hayDemeaned trt if(year > 2 & risk == 0), vce(cluster simID)
reg hayDemeaned trt if(year > 2 & risk == 0.28), vce(cluster simID)
reg hayDemeaned trt if(year > 2 & risk <= 0.545), vce(cluster simID)
reg hayDemeaned trt if(year > 2 & risk > 0.545), vce(cluster simID)

xtreg hay trt herdy_1 i.year L.assetscash if(risk <= 0.28 & (year == 2 | year == 3 | year== 4 | year == 6 | year == 8)), vce(robust)


xtreg hay trt risk riskXtrt herdy_1 revins L.revins L.assetscash i.year, vce(robust)

import delimited "/Users/tshrum/Projects/drought_decision_model/AEPP/data/combined.csv", case(preserve) clear
xtset simID year
 destring risk, replace force
 destring riskXtrt, replace force
 gen ranchers = 0
 replace ranchers = 1 if study == "Ranchers"

 summarize risk, detail

xtreg hay trt herdy_1 i.year L.assetscash if(risk <= 0.28 & year > 2), vce(robust)
xtreg hay trt herdy_1 i.year if(risk <= 0), vce(robust)

xtreg hay trt herdy_1 i.year ranchers if(risk <= 0.28), vce(robust)
xtreg hay trt herdy_1 i.year if(risk <= 0.545), vce(robust)

** These combined 

xtreg hay trt risk riskXtrt herdy_1 L.assetscash ranchers if(year == 3 | year== 4 | year == 6 | year == 8), vce(robust)

xtreg hay trt herdy_1 i.year L.assetscash ranchers if(risk <= 0.28 & (year == 3 | year== 4 | year == 6 | year == 8)), vce(robust)
xtreg hay trt herdy_1 i.year L.assetscash ranchers if(risk > 0.28 & (year == 3 | year== 4 | year == 6 | year == 8)), vce(robust)

xtreg hay trt herdy_1 i.year L.assetscash if(risk <= 0.28 & (year == 3 | year== 4 | year == 6 | year == 8) & ranchers == 1), vce(robust)
xtreg hay trt herdy_1 i.year L.assetscash if(risk <= 0.28 & (year == 3 | year== 4 | year == 6 | year == 8) & ranchers == 0), vce(robust)
