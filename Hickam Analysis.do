// Survey Data 
// Hickams Project

capture log close

* Data processing
clear

//cd "C:\Users\reblo\Box\Residency Personal Files\Scholarly Work\Locke Research Projects\Hickams Dictum Paper\Data" //PC version
cd "/Users/blocke/Box Sync/Residency Personal Files/Scholarly Work/Locke Research Projects/Hickams Dictum Paper/Data" //Mac version

program define datetime 
end

capture mkdir "Results and Figures"
capture mkdir "Results and Figures/$S_DATE/" //make new folder for figure output if needed
capture mkdir "Results and Figures/$S_DATE/Logs/" //new folder for stata logs
local a1=substr(c(current_time),1,2)
local a2=substr(c(current_time),4,2)
local a3=substr(c(current_time),7,2)
local b = "Hickam Analysis.do" // do file name
copy "`b'" "Results and Figures/$S_DATE/Logs/(`a1'_`a2'_`a3')`b'"

set scheme cleanplots
graph set window fontface "Helvetica"
log using temp.log, replace

import excel "Data_Multiple_diagnoses_final.xlsx", sheet("Sheet") firstrow

// Data cleaning

drop RespondentID CollectorID StartDate EndDate
drop in 1

rename ConsentThisisananonymousre answer
rename HowmanyyearshasitbeenPGY pgy_cat
rename Whatbestdescribesyourareaof specialty

destring answer pgy_cat specialty, replace

label define specialty_lab 1 "General Internal Medicine/Hospitalist/Family Practice" 2 "IM subspecialty" 3 "Emergency" 4 "Other"
label values specialty specialty_lab

label define pgy_cat_lab 1 "Layperson/Allied Health" 2 "Medical Student" 3 "PA/DNP" 4 "PGY1" 5 "PGY2-3" 6 "PGY4-5" 7 "PGY6-10" 8 "PGY 11-20" 9 "PGY 21+"
label values pgy_cat pgy_cat_lab
label variable pgy_cat "Training"

label define pgy_binary_lab 0 "PGY 0-9" 1 "PGY 10+"
recode answer (1 = 0) (2 = 0) (3 = 0) (4 = 1), generate(answer_correct)
label variable answer_correct "Correct Responses"

label define binary_lab 0 "Incorrect" 1 "Correct"
label values answer_correct binary_lab

label define pgy_groupings 0 "Pre" 1 "PGY 0-5" 2 "PGY 6+"
recode pgy_cat (0 = .) (1 = 0) (2 = 0) (3 = 0) (4 = 1) (5 = 1) (6 = 1) (7 = 2) (8 = 2) (9= 2), generate(trainee_status_cat)
label variable trainee_status_cat "Trainee Status"
label values trainee_status_cat pgy_groupings

recode pgy_cat (0 = .) (1 = 0) (2 = 0) (3 = 0) (4 = 0) (5 = 0) (6 = 0) (7 = 0) (8 = 1) (9 = 1), generate(pgy_binary) 
label values pgy_binary pgy_binary_lab

//Regressions

//Trainee year
logistic answer_correct ib5.pgy_cat, or base
estimates store pgy_cat_reg

//Specialty
logistic answer_correct ib1.specialty, or base
estimates store spec_reg

//Account for both trainee year and specialty
logistic answer_correct ib1.specialty ib5.pgy_cat, or base
estimates store both_reg

//Just internal medicine
logistic answer_correct ib5.pgy_cat if specialty < 3, or base
estimates store im_pgy_cat_reg


//Visualizations 

 //Specialty - count and proportion
catplot answer_correct, over(pgy_cat) ///
 stack ///
 asyvars ///
 var1opts(label(angle(45))) ///
 recast(hbar) ///
 bar(1, color(gs4)) bar(2, color(gs12)) ///
 legend(pos(2) ring(0) rows(1) size(small) title("Answer", size(small)) symplacement(center))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/PGY Count.png", as(png) name("Graph") replace

catplot answer_correct, over(pgy_cat) ///
 stack ///
 asyvars ///
 percent(pgy_cat) ///
 ytitle("Proportion") /// 
 blabel(count, position(center) color(black)) ///
 recast(hbar) ///
 bar(1, color(gs4)) bar(2, color(gs12)) ///
 legend(pos(6) rows(1) size(small) title("Accuracy", size(small)) symplacement(center))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/PGY Proportion.png", as(png) name("Graph") replace

 
 //Specialty - count and proportion
catplot answer_correct, over(specialty) ///
 stack ///
 asyvars ///
 ytitle("Count") ///
 blabel(bar, angle(45)) /// 
 recast(bar) ///
 b1title("Specialty") ///
 bar(1, color(gs4)) bar(2, color(gs12)) ///
 legend(pos(6) rows(1) size(small) title("Accuracy", size(small)) symplacement(center))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/Specialty Count.png", as(png) name("Graph") replace
 
catplot answer_correct, over(specialty) ///
 stack ///
 asyvars ///
 percent(specialty) ///
 ytitle("Proportion") ///
 blabel(bar, angle(45)) /// 
 recast(bar) ///
 b1title("Specialty") ///
 bar(1, color(gs4)) bar(2, color(gs12)) ///
 legend(pos(6) rows(1) size(small) title("Accuracy", size(small)) symplacement(center))  ///
 xsize(8) ysize(5) 
graph export "Results and Figures/$S_DATE/Specialty Proportion.png", as(png) name("Graph") replace
 
//Regression plots: 

//Trainee category
coefplot pgy_cat_reg, baselevels drop(_cons) eform xscale(log) ///
 xline(1) ///
 xlabel(0.125 0.25 0.5 1 2 4 8 16 32) ///
 xscale(extend) xtitle("Odds Ratio of Correct Answer" , size(small)) yscale(extend) ciopts(recast(rcap) lwidth(thick)) ///
 mlabel(string(@b,"%9.2f") + " [ " + string(@ll,"%9.2f") + " - " + string(@ul,"%9.2f") + " ] " + cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) mlabsize(medsmall) mlabposition(12) mlabgap(*1) ///
 scheme(white_tableau) ///
 text(3 0.11 "More likely" "incorrect" 3 9.9 "More likely" "correct", size(small) color(gs9))
graph export "Results and Figures/$S_DATE/Fig 1 - By Cat.png", as(png) name("Graph") replace

//Specialty
coefplot spec_reg, baselevels drop(_cons) eform xscale(log) ///
 xline(1) ///
 xlabel( 1 2 4 8 16 32) ///
 xscale(extend) xtitle("Odds Ratio of Correct Answer" , size(small)) yscale(extend) ciopts(recast(rcap) lwidth(thick)) ///
 mlabel(string(@b,"%9.2f") + " [ " + string(@ll,"%9.2f") + " - " + string(@ul,"%9.2f") + " ] " + cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) mlabsize(medsmall) mlabposition(12) mlabgap(*1) ///
 scheme(white_tableau) ///
 text(3.5 0.5 "More likely" "incorrect" 3.5 8 "More likely" "correct", size(small) color(gs9))
graph export "Results and Figures/$S_DATE/Fig 1 - By Cat.png", as(png) name("Graph") replace

//both 
coefplot both_reg, baselevels drop(_cons) eform xscale(log) ///
 xline(1) ///
 xlabel(0.125 0.25 0.5 1 2 4 8 16 32) ///
 xscale(extend) xtitle("Odds Ratio of Correct Answer" , size(small)) yscale(extend) ciopts(recast(rcap) lwidth(thick)) ///
 mlabel(string(@b,"%9.2f") + " [ " + string(@ll,"%9.2f") + " - " + string(@ul,"%9.2f") + " ] " + cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) mlabsize(medsmall) mlabposition(12) mlabgap(*1) ///
 scheme(white_tableau) ///
 text(3.5 0.25 "More likely" "incorrect" 3.5 16 "More likely" "correct", size(small) color(gs9))
graph export "Results and Figures/$S_DATE/Regression Coeffs by PGY and Spec.png", as(png) name("Graph") replace

//just IM
coefplot im_pgy_cat_reg, baselevels drop(_cons) eform xscale(log) ///
 title("Among internists only") ///
 xline(1) ///
 xlabel(0.125 0.25 0.5 1 2 4 8 16 32) ///
 xscale(extend) xtitle("Odds Ratio of Correct Answer" , size(small)) yscale(extend) ciopts(recast(rcap) lwidth(thick)) ///
 mlabel(string(@b,"%9.2f") + " [ " + string(@ll,"%9.2f") + " - " + string(@ul,"%9.2f") + " ] " + cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) mlabsize(medsmall) mlabposition(12) mlabgap(*1) ///
 scheme(white_tableau) ///
 text(3.5 0.5 "More likely" "incorrect" 3.5 8 "More likely" "correct", size(small) color(gs9))
graph export "Results and Figures/$S_DATE/IM Only Regression Coefs by PGY.png", as(png) name("Graph") replace

//TODO: p value for trend?


//Spearman rank test; nptrend
preserve 
drop if pgy_cat == 1	//laypeople
drop if pgy_cat == 3	//PA
nptrend answer_correct, group(pgy_cat) carm
restore


nptrend answer_correct, group(trainee_status_cat) carm
