// Survey Data 
// Hickams Project

capture log close

* Data processing
clear

cd "C:\Users\reblo\Box\Residency Personal Files\Scholarly Work\Locke Research Projects\Hickams Dictum Paper\Data" //PC version
//cd "/Users/blocke/Box Sync/Residency Personal Files/Scholarly Work/Locke Research Projects/Hickams Dictum Paper/Data" //Mac version

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


/* --------------
Manually analyzed results from the review of Hickam Cases
Visualization not currently used
---------------*/

clear
set obs 84
generate answer = . //manually simulate the observed answers
replace answer = 1 in 1/22
replace answer = 2 in 23/46
replace answer = 3 in 47/81
replace answer = 4 in 82/84
label variable answer "Answer"
label define answer_lab 1 "Incidentaloma" 2 "Pre-existing" 3 "Causally-Related" 4 "Coincident/Unrelated/Symptomatic"
label values answer answer_lab

graph pie, angle(110) over(answer) ///
	pie(1,color(erose%50)) pie(2,color(erose%65)) ///
	pie(3,color(erose%80)) pie(4, explode color(ebg%90)) ///
	plabel(_all percent, format(%2.0f) gap(-5) size(medium)) ///
	plabel(_all name, gap((5)) textsize(large)) ///  
	line(lcolor(white) lwidth(medium)) ///
	legend(off) xsize(7) ysize(7)
graph export "Results and Figures/$S_DATE/Cases Pie.png", as(png) name("Graph") replace
clear

/* --------------
Analysis of Survey Results
---------------*/

import excel "Survey_Responses.xlsx", sheet("Sheet") firstrow

// Data cleaning

drop RespondentID CollectorID StartDate EndDate
drop in 1

rename ConsentThisisananonymousre answer
rename HowmanyyearshasitbeenPGY pgy_cat
rename Whatbestdescribesyourareaof specialty

destring answer pgy_cat specialty, replace

label define specialty_lab 1 "Gen IM/Hosp./Family" 2 "IM subspecialty" 3 "Emergency" 4 "Other"
label values specialty specialty_lab

label define pgy_cat_lab 1 "Layperson/Allied Health" 2 "Medical Student" 3 "PA/DNP" 4 "PGY1" 5 "PGY2-3" 6 "PGY4-5" 7 "PGY6-10" 8 "PGY 11-20" 9 "PGY 21+"
label values pgy_cat pgy_cat_lab
label variable pgy_cat "Training"

recode answer (1 = 0) (2 = 0) (3 = 0) (4 = 1), generate(answer_correct)
label variable answer_correct "Intended Response"
label define binary_lab 0 "Vignettes 1, 2, or 3" 1 "Vignette 4"
label values answer_correct binary_lab

label variable answer "Answer"
label define answer_lab 1 "Vignette 1" 2 "Vignette 2" 3 "Vignette 3" 4 "Vignette 4"
label values answer answer_lab


label define pgy_groupings 0 "Pre" 1 "PGY 0-5" 2 "PGY 6+"
recode pgy_cat (0 = .) (1 = .) (2 = 0) (3 = .) (4 = 1) (5 = 1) (6 = 1) (7 = 2) (8 = 2) (9= 2), generate(trainee_status_cat)
label variable trainee_status_cat "Trainee Status"
label values trainee_status_cat pgy_groupings


/*
Summarization
*/

//Marginal responses 
proportion answer
proportion answer_correct //dichotomized

//by exposure
table1_mc, by(pgy_cat) ///
	vars( ///
	answer cat %4.1f \ ///
	answer_correct bin %4.1f \ ///
	specialty cat %4.1f \ ///
	) ///
percent_n percsign("%") iqrmiddle(",") sdleft(" (±") sdright(")") missing onecol total(before) saving("Results and Figures/$S_DATE/Answers by Training.xlsx", replace)

//by outcome: 
/* Table 2 in Manuscript */
table1_mc, by(answer_correct) ///
	vars( ///
	pgy_cat cat %4.1f \ ///
	specialty cat %4.1f \ ///
	) ///
percent_n percsign("%") iqrmiddle(",") sdleft(" (±") sdright(")") missing onecol catrowperc statistic saving("Results and Figures/$S_DATE/Table 2 - training and specialty by correct.xlsx", replace)

table1_mc, by(answer) ///   //not dichotomized
	vars( ///
	pgy_cat cat %4.1f \ ///
	specialty cat %4.1f \ ///
	) ///
percent_n percsign("%") iqrmiddle(",") sdleft(" (±") sdright(")") missing onecol catrowperc statistic saving("Results and Figures/$S_DATE/training and specialty by answer.xlsx", replace)


// Cochrane Armitage test for trend; dichotomized 
nptrend answer_correct, group(pgy_cat) carm
nptrend answer_correct, group(trainee_status_cat) carm
//Note: Chi2 (not testing for trend) reported in tables above

//Cochrane Armitage test for trend among only MD and MD trainees; dichotomized 
preserve 
drop if pgy_cat == 1	//laypeople
drop if pgy_cat == 3	//PA
nptrend answer_correct, group(pgy_cat) carm
restore

/*
Regressions
*/
// By Trainee year
logistic answer_correct ib5.pgy_cat, or base
estimates store pgy_cat_reg
mlogit answer ib5.pgy_cat, base(4) rrr //non-dichotomized estimates

// By Specialty
logistic answer_correct ib1.specialty, or base
estimates store spec_reg
mlogit answer ib1.specialty, base(4) rrr //non-dichotomized estimates

//Account for both trainee year and specialty
logistic answer_correct ib1.specialty ib5.pgy_cat, or base
estimates store both_reg
/* Assess how well knowing specialty and training allows you to descriminate correct vs not */ 
predict model_pr , pr  //on entire sample
pmcalplot model_pr answer_correct
bootstrap r(cstat), reps(50) size(255) seed(999) : pmcalplot model_pr answer_correct

mlogit answer ib1.specialty ib5.pgy_cat, base(4) rrr //non-dichotomized estimates

//Just internal medicine
logistic answer_correct ib5.pgy_cat if specialty < 3, or base
estimates store im_pgy_cat_reg
mlogit answer ib1.specialty ib5.pgy_cat if specialty < 3, base(4) rrr //non-dichotomized estimates

/*
Visualizations 
*/

// Frequency of Answers
/* Figure 1 in Manuscript */ 
graph pie, over(answer) ///
	pie(1,color(erose%50)) pie(2,color(erose%65)) ///
	pie(3,color(erose%80)) pie(4, explode color(ebg%90)) ///
	plabel(_all percent, format(%2.0f) gap(5) size(large)) ///
	plabel(_all name, gap(21.5) size(medlarge)) ///
	line(lcolor(white) lwidth(medium)) ///
	legend(off) xsize(7) ysize(7)
graph export "Results and Figures/$S_DATE/Fig 1 - Overall Pie.png", as(png) name("Graph") replace
		
 //PGY Category - count and proportion
catplot answer_correct, over(pgy_cat) ///
 stack ///
 asyvars ///
 var1opts(label(angle(45))) ///
 recast(hbar) ///
 ytitle("Number of Responses") ///
 bar(1, color(gs4)) bar(2, color(gs12)) ///
 legend(pos(2) ring(0) rows(2) size(med) symplacement(center) title("Least Likely Vignette"))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/PGY Count.png", as(png) name("Graph") replace

/* Figure 2 in Revised Manuscript */ 
preserve 
label variable answer " "  //hack to eliminate the extra label 
catplot answer, over(pgy_cat) ///
 stack ///
 asyvars ///
 var1opts(label(angle(45))) ///
 recast(hbar) ///
 ytitle("Number of Responses") ///
 bar(1, color(erose%50)) bar(2, color(erose%65)) bar(3, color(erose%80)) bar(4, color(ebg%90)) ///
 legend(pos(2) ring(0) rows(4) size(med) symplacement(center) title("Least Likely Vignette"))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/Fig 2 - PGY Count all answers.png", as(png) name("Graph") replace
restore

//Proportional Versions 
catplot answer_correct, over(pgy_cat) ///
 stack ///
 asyvars ///
 percent(pgy_cat) ///
 ytitle("Proportion") /// 
 blabel(count, position(center) color(black)) ///
 recast(hbar) ///
 bar(1, color(gs4)) bar(2, color(gs12)) ///
 legend(pos(6) rows(1) size(med) title("Accuracy", size(med)) symplacement(center))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/Correct - PGY Proportion.png", as(png) name("Graph") replace

catplot answer, over(pgy_cat) ///
 stack ///
 asyvars ///
 percent(pgy_cat) ///
 ytitle("Proportion") /// 
 blabel(count, position(center) color(black)) ///
 recast(hbar) ///
 bar(1, color(erose%50)) bar(2, color(erose%65)) bar(3, color(erose%80)) bar(4, color(ebg%90)) ///
 legend(pos(6) rows(1) size(med) title("Accuracy", size(med)) symplacement(center))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/Answers - PGY Proportion.png", as(png) name("Graph") replace

 //Specialty - count and proportion
catplot answer_correct, over(specialty) ///
 stack ///
 asyvars ///
 ytitle("Count") ///
 blabel(bar, angle(45) size(med)) /// 
 recast(bar) ///
 b1title("Specialty") ///
 bar(1, color(gs4)) bar(2, color(gs12)) ///
 legend(pos(2) rows(1) ring(0) size(med) title("Answer", size(med)) symplacement(center))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/Correct Specialty Count.png", as(png) name("Graph") replace
 
catplot answer, over(specialty) ///
 stack ///
 asyvars ///
 ytitle("Count") ///
 recast(bar) ///
 b1title("Specialty") ///
 bar(1, color(erose%50)) bar(2, color(erose%65)) bar(3, color(erose%80)) bar(4, color(ebg%90)) ///
 legend(pos(2) rows(1) ring(0) size(med) title("Answer", size(med)) symplacement(center))  ///
 xsize(8) ysize(5)
graph export "Results and Figures/$S_DATE/Answer Specialty Count.png", as(png) name("Graph") replace
  
catplot answer_correct, over(specialty) ///
 stack ///
 asyvars ///
 percent(specialty) ///
 ytitle("Proportion") ///
 blabel(bar, angle(45)) /// 
 recast(bar) ///
 b1title("Specialty") ///
 bar(1, color(gs4)) bar(2, color(gs12)) ///
 legend(pos(6) rows(1) size(small) title("Answer", size(small)) symplacement(center))  ///
 xsize(8) ysize(5) 
graph export "Results and Figures/$S_DATE/Correct Specialty Proportion.png", as(png) name("Graph") replace
 
catplot answer, over(specialty) ///
 stack ///
 asyvars ///
 percent(specialty) ///
 ytitle("Proportion") ///
 recast(bar) ///
 b1title("Specialty") ///
 bar(1, color(erose%50)) bar(2, color(erose%65)) bar(3, color(erose%80)) bar(4, color(ebg%90)) ///
 legend(pos(6) rows(1) size(small) title("Answer", size(small)) symplacement(center))  ///
 xsize(8) ysize(5) 
graph export "Results and Figures/$S_DATE/Answer Specialty Proportion.png", as(png) name("Graph") replace
 
//Regression plots: 

//Trainee category
coefplot pgy_cat_reg, baselevels drop(_cons) eform xscale(log) ///
 xline(1) ///
 xlabel(0.125 0.25 0.5 1 2 4 8 16 32) ///
 xscale(extend) xtitle("Odds Ratio of Selecting Answer 4" , size(small)) yscale(extend) ciopts(recast(rcap) lwidth(thick)) ///
 mlabel(string(@b,"%9.2f") + " [ " + string(@ll,"%9.2f") + " - " + string(@ul,"%9.2f") + " ] " + cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) mlabsize(medsmall) mlabposition(12) mlabgap(*1) ///
 scheme(white_tableau) ///
 text(3 0.175 "More likely" "1, 2, or 3" 3 9.9 "More likely" "4", size(small) color(gs9))
graph export "Results and Figures/$S_DATE/Fig 1 - By Cat.png", as(png) name("Graph") replace

//Specialty
coefplot spec_reg, baselevels drop(_cons) eform xscale(log) ///
 xline(1) ///
 xlabel( 1 2 4 8 16 32) ///
 xscale(extend) xtitle("Odds Ratio of Selecting Answer 4" , size(small)) yscale(extend) ciopts(recast(rcap) lwidth(thick)) ///
 mlabel(string(@b,"%9.2f") + " [ " + string(@ll,"%9.2f") + " - " + string(@ul,"%9.2f") + " ] " + cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) mlabsize(medsmall) mlabposition(12) mlabgap(*1) ///
 scheme(white_tableau) ///
 text(3.5 0.5 "More likely" "1, 2, or 3" 3.5 8 "More likely" "4", size(small) color(gs9))
graph export "Results and Figures/$S_DATE/Fig 1 - By Cat.png", as(png) name("Graph") replace

//both 
coefplot both_reg, baselevels drop(_cons) eform xscale(log) ///
 xline(1) ///
 xlabel(0.125 0.25 0.5 1 2 4 8 16 32) ///
 xscale(extend) xtitle("Odds Ratio of Selecting Answer 4" , size(small)) yscale(extend) ciopts(recast(rcap) lwidth(thick)) ///
 mlabel(string(@b,"%9.2f") + " [ " + string(@ll,"%9.2f") + " - " + string(@ul,"%9.2f") + " ] " + cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) mlabsize(medsmall) mlabposition(12) mlabgap(*1) ///
 scheme(white_tableau) ///
 text(3.5 0.25 "More likely" "1, 2, or 3" 3.5 16 "More likely" "4", size(small) color(gs9))
graph export "Results and Figures/$S_DATE/Regression Coeffs by PGY and Spec.png", as(png) name("Graph") replace

//just IM. Note - intern's excluded because there was no variation in answer (all correct)
coefplot im_pgy_cat_reg, baselevels drop(_cons) eform xscale(log) ///
 title("Among internists only") ///
 xline(1) ///
 xlabel(0.125 0.25 0.5 1 2 4 8 16 32) ///
 xscale(extend) xtitle("Odds Ratio of Selecting Answer 4" , size(small)) yscale(extend) ciopts(recast(rcap) lwidth(thick)) ///
 mlabel(string(@b,"%9.2f") + " [ " + string(@ll,"%9.2f") + " - " + string(@ul,"%9.2f") + " ] " + cond(@pval<.001, "***", cond(@pval<.01, "**", cond(@pval<.05, "*", "")))) mlabsize(medsmall) mlabposition(12) mlabgap(*1) ///
 scheme(white_tableau) ///
 text(3.5 0.5 "More likely" "1, 2, or 3" 3.5 8 "More likely" "4", size(small) color(gs9))
graph export "Results and Figures/$S_DATE/IM Only Regression Coefs by PGY.png", as(png) name("Graph") replace




	