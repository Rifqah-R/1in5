version 15.1

************************************************************************
* PART 0: TABLE OF CONTENTS
************************************************************************
* start log 
capture log close
log using "path/do-filename.log", replace

* Project: [Roomaney RA, van Wyk B, Cois A, Pillay-van Wyk V. One in five South Africans are multimorbid: An analysis of the 2016 demographic and health survey. Plos one. 2022 May 26;17(5):e0269081.]
* Creator: [Rifqah Roomaney, rifqah.roomaney@mrc.ac.za, 24/02/2021] 
* Purpose of do-file: Explore data
/*
	Outline
	Part 1: Housekeeping & Introduction
	
	Part 2: Main Analysis  - create MM index variables
	Part 2.1: Tabulations demographics and diseases
	Part 2.2: Multimorbidity index explore
	Part 2.3: Regression 
	
	
*/
************************************************************************
* PART 1: HOUSEKEEPING & INTRODUCTION
************************************************************************
set more off 

*Setting file path
global BASE "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS"

* SOURCE FILES DIRECTORIES
global DHS2016 "DHS\DHS2016\Dataset\ZA_2016_DHS_02032019_432_49143"

*Opening dataset
use "$BASE\1 My project\Data\DHS2016_subset_03052021.dta", replace
*log using "Log files\DHS2016_Explore1.smcl", replace



************************************************************************
* PART 2: MAIN ANALYSIS - CREATE MULTIMORBIDITY VARIABLES
************************************************************************

***Generate disease index count
egen index = rowtotal(hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12) //Doesn't exclude missing data. Adds up "yes" responses for these diseases //try rowmean*9 / rowmissing to see how many missing
label define Indexlabel 0 "No disease" 1 "1 disease" 2 "2 diseases" 3 "3 diseases" 4 "4 diseases" 5 "5 diseases" 6 "6 diseases" 7 "7 diseases" 8 "8 diseases" 9 "9 diseases"
label values index Indexlabel
label variable index "Number of diseases"
tab index
tab index gender, col chi

***Generate multimorbidity index
generate mm_index= index // Generating a multimorbidity variable that puts <2 diseases and >=2 diseases into categories
tab mm_index
recode mm_index 0/1=0 2/9=1
tab mm_index
label define Multimorbidity 0 "No multimorbidity" 1 "Multimorbidity", replace
label values mm_index Multimorbidity
label variable mm_index "Multimorbidity "
tab mm_index gender, col chi

**age categories
recode age(15/24= 1 "15-24") (25/34=2 "25-34") (35/44=3 "35-44") (45/54=4 "45-54") (55/64=5 "55-64") (65/200=6 "65+"), generate(age_cat)
tabstat age, stat (n, mean, median, sd, p25, p75, min, max)
tab age_cat


***************************************
* SURVEY set
*****************************************
svyset psu[pweight=csweight], strata(stratum) vce(linearized) singleunit(certainty) 
svydescribe

************************************************************************
*Part 2.1: Tabulations demographics and diseases
************************************************************************
describe //lists variables in the dataset
count // 10 336 participants

tab age
summarize age, detail
by gender, sort : summarize age, detail  //summarize age by gender
histogram age, normal
swilk age //not normally distributed
graph box age, over(gender)
ranksum age, by(gender) porder  //test for difference in age between males and females - wilcoxon rank
kwallis age, by(gender)

tab gender
graph pie, over(gender)

tab race

tab urban
tab urban gender, col chi 
svy linearized : proportion urban
svy linearized : proportion urban, over(gender)

tab prov
tab prov gender, col chi
svy linearized : proportion prov
svy linearized : proportion prov, over(gender)

tab educat
tab educat gender, col exp chi
svy linearized : proportion educat
svy linearized : proportion educat, over(gender)

tab wealthindex
tab wealthindex  gender, col chi
svy linearized : proportion wealthindex
svy linearized : proportion wealthindex, over(gender)

tab employed
tab employed  gender, col chi



tabstat age, statistics( p50 p25 p75 ) by(SELFHEART ) //Median age of people who have heart disease
tabstat age, statistics( p50 p25 p75 ) by(SELFSTROKE) // Median age of people with stroke
tabstat age, statistics( p50 p25 p75 ) by(SELFCHOL) // Median age of people with high cholesterol
tabstat age, statistics( p50 p25 p75 ) by(SELFDIAB) // Median age of people with diabetes
tabstat age, statistics( p50 p25 p75 ) by(SELFBRONCH) // Median age of people with COPD

** Self reported disease tabulations 
tab SELFDIAB
tab SELFDIAB gender, col chi
logistic SELFDIAB gender
svy linearized : proportion SELFDIAB
svy linearized : proportion SELFDIAB, over(gender)

svy linearized : proportion SELFDIAB, over(age_cat)
svy linearized : proportion SELFDIAB, over(age_10)
svy linearized, subpop(if gender==1) : proportion SELFDIAB, over(age_10)
svy linearized, subpop(if gender==2) : proportion SELFDIAB, over(age_10)


tabulate SELFBRONCH
tab SELFBRONCH gender, col  chi
logistic SELFBRONCH gender
svy linearized : proportion SELFBRONCH
svy linearized : proportion SELFBRONCH, over(gender)

svy linearized, subpop(if gender==1) : proportion SELFBRONCH, over(age_10)
svy linearized, subpop(if gender==2) : proportion SELFBRONCH, over(age_10)
svy linearized : proportion SELFBRONCH, over(age_10)



tabulate SELFHEART
tab SELFHEART gender, col  chi
logistic SELFHEART gender
svy linearized : proportion SELFHEART
svy linearized : proportion SELFHEART, over(gender)

svy linearized, subpop(if gender==1) : proportion SELFHEART, over(age_10)
svy linearized, subpop(if gender==2) : proportion SELFHEART, over(age_10)
svy linearized : proportion SELFHEART, over(age_10)

tabulate SELFCHOL
tab SELFCHOL gender, col chi
logistic SELFCHOL gender
svy linearized : proportion SELFCHOL
svy linearized : proportion SELFCHOL, over(gender)

tabulate SELFSTROKE
tab SELFSTROKE gender, col  chi
logistic SELFSTROKE gender
svy linearized : proportion SELFSTROKE
svy linearized : proportion SELFSTROKE, over(gender)

tabulate SELFTB12
tab SELFTB12 gender, col  chi
logistic SELFTB12 gender
svy linearized : proportion SELFTB12
svy linearized : proportion SELFTB12, over(gender)


tabulate hiv 
tab hiv gender, col exp chi
logistic hiv gender
svy linearized : proportion hiv 
svy linearized : proportion hiv , over(gender)


tabulate htn 
tab htn gender, col  chi
logistic htn gender
svy linearized : proportion htn 
svy linearized : proportion htn , over(gender)


tabulate anaemia
tab anaemia gender, col  chi
logistic anaemia gender
svy linearized : proportion anaemia 
svy linearized : proportion anaemia , over(gender)

tabulate DIAB_MED
tab DIAB_MED gender, col  chi
logistic DIAB_MED gender
svy linearized : proportion DIAB_MED 
svy linearized : proportion DIAB_MED , over(gender)

*biological and self-report
tabulate diabetes 
tab diabetes gender, col exp chi
logistic diabetes gender
svy linearized : proportion diabetes 
svy linearized : proportion diabetes , over(gender)
  

*associations with diabetes

tabulate SELFDIAB SELFBRONCH , row exp chi
logistic SELFDIAB SELFBRONCH

tabulate SELFDIAB SELFHEART , row exp chi
logistic SELFDIAB SELFHEART

tabulate SELFDIAB SELFCHOL , row exp chi
logistic SELFDIAB SELFCHOL

tabulate SELFDIAB SELFSTROKE , row exp chi
logistic SELFDIAB SELFSTROKE

tabulate SELFDIAB SELFTB12 , row exp chi //no association
logistic SELFDIAB SELFTB12

* associations with bronchitis

tabulate SELFBRONCH SELFHEART , row exp chi
logistic SELFBRONCH SELFHEART

tabulate SELFBRONCH SELFCHOL , row exp chi
logistic SELFBRONCH SELFCHOL

tabulate SELFBRONCH SELFSTROKE , row exp chi
logistic SELFBRONCH SELFSTROKE

tabulate SELFBRONCH SELFTB12 , row exp chi //no association
logistic SELFBRONCH SELFTB12

** Association with Heart disease 

tabulate SELFHEART SELFCHOL , row exp chi
logistic SELFHEART SELFCHOL

tabulate SELFHEART SELFSTROKE , row exp chi
logistic SELFHEART SELFSTROKE

tabulate SELFHEART SELFTB12 , row exp chi 
logistic SELFHEART SELFTB12

**Association with  Cholesterol

tabulate SELFCHOL SELFSTROKE , row exp chi
logistic SELFCHOL SELFSTROKE

tabulate SELFCHOL SELFTB12 , row exp chi 
logistic SELFCHOL SELFTB12

**Association with Stroke

tabulate SELFSTROKE SELFTB12 , row exp chi 
logistic SELFSTROKE SELFTB12

**age and disease
tab age_10 diabetes, row //
tab age_10 hiv, row  //high prev in young
tab age_10 htn, row // fairly high in young people
tab age_10 anaemia, row //high in young
tab age_10 SELFBRONCH, row
tab age_10 SELFHEART, row
tab age_10 SELFCHOL, row
tab age_10 SELFSTROKE, row
tab age_10 SELFTB12, row
tab age_10 mm_index, row

tab htn hiv if age_10==2, row col //hiv and hypertension in people 20 -29
tab htn hiv if age_10==1|2, row col //hiv and hypertension in under 30s

tab htn hiv if age_10  //hiv and hypertension in under 30s

svy linearized, subpop(if hiv==1) : proportion htn, over(age_10)

svy linearized : proportion htn, over(age_10)
tab htn age_10, col

recode age(15/29= 1 "15-29") (30/44=2 "30-44") (45/60=3 "45-60") (60/200=4 ">60"), generate(age_r)
tab htn hiv if age_r==1, col
svy linearized, subpop(if hiv==1) : proportion htn, over(age_r)

***************************************
* SURVEY set
*****************************************
svyset psu[pweight=csweight], strata(stratum) vce(linearized) singleunit(certainty) 
svydescribe

tabulate SELFDIAB 
svy: tabulate SELFDIAB 

tabulate SELFBRONCH
svy: tabulate SELFBRONCH

tabulate SELFHEART
svy: tabulate SELFHEART

tabulate SELFCHOL
svy: tabulate SELFCHOL

tabulate SELFSTROKE
svy: tabulate SELFSTROKE

tabulate SELFTB12
svy: tabulate SELFTB12

tab mm_index
svy: tabulate mm_index  

************************************************************************
* Part 2.2: Multimorbidity index explore
************************************************************************
tab index
tab index gender, col chi
svy: tabulate index
svy linearized : proportion index 
svy linearized : proportion index , over(gender)
svy: tabulate index gender
svy: tabulate mm_index gender


generate index0= index 
recode index0 0=0 1/6=1
svy linearized : proportion index0 
svy linearized : proportion index0 , over(gender)
svy: tabulate index0 gender

generate index1= index 
recode index1 1=0 0=1 2/6=1
svy: tabulate index1 gender

generate index2= index 
recode index2 2=1 0/1=0 3/6=0
svy: tabulate index2 gender

generate index3= index 
recode index3 3/6=3
svy: tabulate index3
svy linearized : proportion index3 
svy linearized : proportion index3, over(gender) 

svy: tabulate index3 gender


tab mm_index gender, col chi
svy: tabulate mm_index
svy linearized : proportion mm_index 
svy linearized : proportion mm_index , over(gender)

svy linearized : proportion mm_index , over(age_10)
svy linearized, subpop(if gender==1) : proportion mm_index, over(age_10)
svy linearized, subpop(if gender==2) : proportion mm_index, over(age_10)


graph box age, over(index)
graph box age, over(mm_index)
graph box age [pw = csweight ], by(mm_index)

by mm_index, sort : summarize age, detail

tabulate age_10 mm_index, row exp chi
tabulate mm_index gender, row exp chi

tabulate age_10 mm_index if gender ==1, row col
tabulate age_10 mm_index if gender ==2, row col
tabulate age_10 mm_index

*For comparison paper
recode age_10 (8=7)
svy linearized : proportion mm_index , over(age_10)
svy linearized, subpop(if gender==1) : proportion mm_index, over(age_10)
svy linearized, subpop(if gender==2) : proportion mm_index, over(age_10)

************************************************************************
* Part 2.3: Regression 
************************************************************************
save "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_regression_18052021.dta"
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_regression_18052021.dta"
svyset psu[pweight=csweight], strata(stratum) vce(linearized) singleunit(certainty) 


**Unadjusted odds ratios 
graph box age, over(mm_index)
logistic mm_index i.age_cat //age signifcantly associated
svy: logistic mm_index i.age_cat 

tab mm_index gender //checking numbers in each cell
logistic mm_index gender // gender significantly associated
svy: logistic mm_index gender 

tab mm_index urban //checking numbers in each cell
logistic mm_index urban // living in urban area sig assoc
svy: logistic mm_index urban 

tab mm_index educat, col //checking numbers in each cell
logistic mm_index ib(3).educat // sets the default to tertiary. doesn't make sense
logistic mm_index i.educat // lower odds if you have secondary education but not significant for tertiary (small sample of 30)
svy: logistic mm_index i.educat 

tab mm_index wealthindex, col //checking numbers in each cell
logistic mm_index i.wealthindex // richer people more likely to have multimorbidity
svy: logistic mm_index i.wealthindex  

tab mm_index employed, col //checking numbers in each cell
logistic mm_index employed //less likely to have multimorbidity if employed
svy: logistic mm_index employed  

tab mm_index bmi_cat, col //checking numbers in each cell
logistic mm_index i.bmi_cat
graph box BMI, over(mm_index) 
logistic mm_index BMI // increase of BMI and increase in MM
tabstat BMI, statistics( p50 p25 p75 ) by( mm_index )
svy: logistic mm_index i.bmi_cat 

tab mm_index CURRALC, col //checking numbers in each cell
logistic mm_index CURRALC
svy: logistic mm_index CURRALC 

tab mm_index CURRSMOK, col //checking numbers in each cell
logistic mm_index CURRSMOK
svy: logistic mm_index CURRSMOK 

tab mm_index race //checking numbers in each cell
logistic mm_index ib(2).race // race is not significant
svy: logistic mm_index i.race 

***Logistic regression 

*Model 1A
logistic mm_index i.age_cat gender
estat gof, table group(10)
*Model 1B
svy: logistic mm_index i.age_cat gender
linktest
svylogitgof

*Model 2a
logistic mm_index i.age_cat gender urban i.educat i.wealthindex employed 
estat gof, table group(10)
*Model 2B
svy: logistic mm_index i.age_cat gender urban i.educat i.wealthindex employed 
svylogitgof

*Model 3a
logistic mm_index i.age_cat gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK
estat gof, table group(10)


******************************************************************************************************************************************************
* Model checking                                                                                                                                     *
* Annibale, 18/05/2021                                                                                                                               *
******************************************************************************************************************************************************

use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_regression_18052021.dta"


svyset psu[pweight=csweight], strata(stratum) vce(linearized) singleunit(certainty) 


*Model 3B
svy: logistic mm_index i.age_cat gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK 
linktest

* Linktest significant, try adding interaction terms.
* I have added age*geneder, as for many diseases (especaily CVD) the trajectories are very different for males and females

*Model 3B_1
svy: logistic mm_index i.age_cat gender i.age_cat#gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK 
linktest

* some interaction tersm are significant, and the linktest becomes not significant. This suggests that we should keep teh intercation term.
* Results suggests that young females have a higher risk of comorbidity comapred to males, but the difference tends to disappear after 35 years

* Compare the fit of the two models (Wald test: LR test/BIC do not work for svy data)

svy: logistic mm_index i.age_cat gender i.age_cat#gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK 

testparm i.age_cat#gender        // p = 0.0001 -> the mdoel with intercation fist significantly better than the model without
svylogitgof                      // p = 0.836 -> confirma the good fit 

*Model checking*******
logistic mm_index i.age_cat gender i.age_cat#gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK
capture drop p stdres
predict p
predict stdres, rstand
scatter stdres p, mlabel(id) ylab(-4(2) 16) yline(0)

list id mm_index age_cat gender urban educat wealthindex employed bmi_cat CURRALC CURRSMOK  if (stdres >4 & stdres <.)

scatter stdres id, mlab(id) ylab(-4(2) 16) yline(0)
predict dv, dev
scatter dv p, mlab(id) yline(0)
scatter dv id, mlab(id)
predict hat, hat
scatter hat p, mlab(id)  yline(0)
scatter hat id, mlab(id)

predict dx2, dx2
predict dd, dd
scatter dx2 id, mlab(id)
scatter dd id, mlab(id)

predict dbeta, dbeta
scatter dbeta id, mlab(id)


* Exclude outliers

preserve 
drop if id == 602 | id == 3337 | id == 6067 | id ==  6469 | id == 6905 | id == 6067 | id == 6949 

logistic mm_index i.age_cat gender i.age_cat#gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK 
predict p1
predict stdres1, rstand
scatter stdres1 p1, mlabel(id) ylab(-4(2) 16) yline(0) 
qnorm stdres1


svy: logistic mm_index i.age_cat gender i.age_cat#gender urban i.educat i.wealthindex employed i.bmi_cat CURRALC CURRSMOK 






*****LCA

**please see: https://www.latentclassanalysis.com/software/lca-stata-plugin/
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_regression_18052021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 /*CHANGE THIS PATH TO MATCH THE FILE LOCATION ON YOUR MACHINE!*/

drop if mm_index==0

recode hiv 0=1 1=2
recode diabetes 0=1 1=2
recode htn 0=1 1=2
recode anaemia 0=1 1=2
recode SELFBRONCH 0=1 1=2
recode SELFHEART 0=1 1=2
recode SELFCHOL 0=1 1=2
recode SELFSTROKE 0=1 1=2
recode SELFTB12 0=1 1=2




doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12, ///
      nclass(5) ///
	  seed(100000) ///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2)  ///
	  criterion(0.000001)  ///
	  rhoprior(1.0)
	  
return list
matrix list r(gamma)
matrix list r(gammaSTD)
matrix list r(rho)
//matrix list r(rhoSTD)

doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12, ///
      nclass(4) ///
	  seed(100000) ///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2)  ///
	  criterion(0.000001)  ///
	  rhoprior(1.0)
	  
return list
matrix list r(gamma)
matrix list r(gammaSTD)
matrix list r(rho)
matrix list r(rhoSTD)

**option2

use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_regression_18052021.dta"

drop if mm_index==0

recode hiv 0=1 1=2
recode diabetes 0=1 1=2
recode htn 0=1 1=2
recode anaemia 0=1 1=2
recode SELFBRONCH 0=1 1=2
recode SELFHEART 0=1 1=2
recode SELFCHOL 0=1 1=2
recode SELFSTROKE 0=1 1=2
recode SELFTB12 0=1 1=2

recode urban 0=1 1=2
recode employed 0=1 1=2
recode bmi_cat 0=1 1=2 2=3 3=4 4=5 5=6
recode CURRALC 0=1 1=2
recode CURRSMOK 0=1 1=2


*drop _all
cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(5)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  groups (gender) 				///
	  groupnames("male female") ///
	  measurement("groups") 		///
	  covariates(CURRALC CURRSMOK) 	///
	  reference(1)				///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0) ///
	  betaprior(1)
return list
matrix list r(gamma)
matrix list r(gammaSTD)	
