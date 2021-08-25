* HERD 

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
 
 
xtreg herd herdy_1 trt if(year > 2), vce(robust)
est sto r1
xtreg herd herdy_1 trt risk if(year > 2), vce(robust)
est sto r2
xtreg herd herdy_1 trt risk riskXtrt if(year > 2), vce(robust)
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
 
xtreg herd herdy_1 trt, vce(robust)
est sto m1
xtreg herd herdy_1 trt risk, vce(robust)
est sto m2
xtreg herd herdy_1 trt risk riskXtrt , vce(robust)
est sto m3

esttab m1 r1 m2 r2 m3 r3 using "AEPP/results/herd.tex", replace f ///
	booktabs b(3) se(3) alignment(S S) ///
	keep(trt risk riskXtrt herdy_1 ) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	coeflabels(trt "Insurance Treatment" risk "Coef. Risk Aversion" riskXtrt "Risk Aversion X Treatment" herdy_1 "Previous Year Herd Size") ///
	stats(N N_clust r2_o, fmt(0 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Participants"' `"Overall R$^$2"')) ///
	nomtitles   
 
 