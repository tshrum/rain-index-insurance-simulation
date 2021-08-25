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
 
 
 reg netwrth trt if(year == 10)
 reg netwrth trt risk if(year == 10)
 
* In the six years of insurance from 2001 to 2006, those in the treatment group receive $82,809 in indemnities
* In those six years, they pay $5,655 each year for a total of $33,930 in premium payments
* On net, they get $48,879 more than the control group.

gen subsidy = 48879
replace subsidy = 0 if trt==0
gen netwrth_aftersub = netwrth - subsidy

destring risk_std, replace force

reg netwrth trt if(year == 10)
est sto n1
reg netwrth trt risk if(year == 10)
est sto n2
reg netwrth trt risk riskXtrt  if(year == 10)
est sto n3

esttab n1 n2 n3 using "AEPP/results/netWorth.tex", replace ///
	booktabs b(3) se(3)  ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	coeflabels(trt "Insurance" risk "Coef. Risk Aversion" riskXtrt "Risk Aversion X Insurance") ///
	stats(N ar2, fmt(0) layout("\multicolumn{1}{c}{@}") labels(`"Observations"'))

reg netwrth_aftersub trt if(year == 10)
reg netwrth_aftersub trt risk if(year == 10)
reg netwrth_aftersub trt risk riskXtrt if(year == 10)


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
 destring netwrth, replace force
 
reg netwrth trt if(year == 9)
reg netwrth trt risk if(year == 9)
reg netwrth trt risk riskXtrt if(year == 9)
reg netwrth_aftersub trt if(year == 10)
