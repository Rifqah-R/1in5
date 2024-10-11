**STATA LCA (31 Aug 2021)
***Latent Class Analysis of DHS 2016 
***Note: To run this file you need tp download ado file: https://www.latentclassanalysis.com/software/
***************************************************************

*Data cleaing to prepare the file
set matsize 800   //Enlarge matrix

use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_regression_18052021.dta"

tab index
drop if mm_index==0  //drop people with 0 or 1 diseases 

label def yesno1 2 "Yes" 1 "No", replace  //recode as the ado doesnt seem to work with 0 code

tab hiv
tab hiv, nol
recode hiv 0=1 1=2
label val hiv yesno1
tab hiv


recode diabetes 0=1 1=2
recode htn 0=1 1=2
recode anaemia 0=1 1=2
recode SELFBRONCH 0=1 1=2
recode SELFHEART 0=1 1=2
recode SELFCHOL 0=1 1=2
recode SELFSTROKE 0=1 1=2
recode SELFTB12 0=1 1=2
label val diabetes htn anaemia SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12 yesno1

save "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta", replace

****Check for how many classes are appropriate without covariates***

*2 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(2)					///
	  id(id)                	///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  seed(123456789) 			///
	  seeddraws(100000) 		///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)               
return list
matrix list r(gamma)
matrix list r(gammaSTD)	

*3 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(3)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)				///
	  clusters(psu)					///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0) 
	  
return list
matrix list r(gamma)
matrix list r(gammaSTD)	

*4 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(4)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)				///
	  clusters(psu)					///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)
return list
matrix list r(gamma)
matrix list r(gammaSTD)
matrix list r(rho)
matrix list r(rhoSTD)



**5 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(5)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)				///
	  clusters(psu)					///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0) 
	  
return list
matrix list r(gamma)
matrix list r(gammaSTD)	
matrix list r(rho)
matrix list r(rhoSTD)

*6 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(6)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)				///
	  clusters(psu)					///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0) 
	
return list
matrix list r(gamma)
matrix list r(gammaSTD)	

*7 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(7)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)				///
	  clusters(psu)					///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0) 
	
return list
matrix list r(gamma)
matrix list r(gammaSTD)	

*8 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(8)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)				///
	  clusters(psu)					///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0) 
	
return list
matrix list r(gamma)
matrix list r(gammaSTD)	

**Note: Model with 4 or 5 classes most appropriate

*********Covariate model (gender age_cat urban educat wealthindex  employed CURRALC CURRSMOK bmi_cat) - using Stata 13
set matsize 11000
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021_13.dta"

**Create dummy variables
recode age_cat 1/2=1 3/4=2 5/6=3
label def age_cat1 1 "15-34" 2 "35-54" 3 "55+", replace
label val  age_cat age_cat1
tabulate age_cat, gen(age_groups)

tabulate educat, gen(edu)
tabulate wealthindex, gen(wealth)

recode bmi_cat 0=1 1=2 2/3=3 4/5=3
label def bmi_cat1 1 "Underweight" 2 "Normal weight" 3 "Overweight", replace
label val bmi_cat bmi_cat1
tabulate bmi_cat, gen(bmi_groups)


cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(4)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  covariates(gender age_groups2 age_groups3 urban edu2 edu3 employed wealth2 wealth3 wealth4 wealth5 CURRALC CURRSMOK bmi_groups1 bmi_groups3) 	///
	  reference(1)				///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2)	///
	  criterion(0.000001)  		///
	  rhoprior(1.0) ///
	  betaprior(1)
return list
matrix list r(gamma)
matrix list r(rho)
matrix list r(rhoSTD)
matrix list r(beta)	
matrix list r(betaSTD) 

**model without redundant covariates (removing employment, alcohol and smoking)
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021_13.dta"

**Create dummy variables
recode age_cat 1/2=1 3/4=2 5/6=3
label def age_cat1 1 "15-34" 2 "35-54" 3 "55+", replace
label val  age_cat age_cat1
tabulate age_cat, gen(age_groups)

tabulate educat, gen(edu)

recode wealthindex 1/2=1 3=2 4/5=3
label def wealthindex1 1 "Poorer" 2 "Middle" 3 "Richer", replace
label val  wealthindex wealthindex1
tabulate wealthindex, gen(wealth)

recode bmi_cat 0=1 1=2 2/3=3 4/5=3
label def bmi_cat1 1 "Underweight" 2 "Normal weight" 3 "Overweight", replace
label val bmi_cat bmi_cat1
tabulate bmi_cat, gen(bmi_groups)


cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(4)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)			///
	  clusters(psu)				///
	  covariates(gender age_groups2 age_groups3 urban edu2 edu3 CURRSMOK CURRALC bmi_groups1 bmi_groups3) 	///
	  reference(2)				///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2)	///
	  criterion(0.000001)  		///
	  rhoprior(1.0) ///
	  betaprior(1)
return list
matrix list r(gamma)
matrix list r(gammaSTD)	

matrix list r(rho)
matrix list r(rhoSTD)
matrix list r(beta)	
matrix list r(betaSTD) 

***Summary stats for classes
*4 class model
drop _all
use "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS\1 My project\Data\DHS2016_LCA_clean30082021.dta"

cd C:\ado\plus\Release64-1.3.2-2002ph7\Release64-1.3.2 
doLCA hiv diabetes htn anaemia  SELFBRONCH SELFHEART SELFCHOL SELFSTROKE SELFTB12,  ///
      nclass(4)					///
	  id(id)                 ///
	  maxiter(5000)  			///
	  weight(csweight)				///
	  clusters(psu)					///
	  seed(123456789) 			///
	  seeddraws(100000) ///
	  categories(2 2 2 2 2 2 2 2 2 )	///
	  criterion(0.000001)  		///
	  rhoprior(1.0)
return list
matrix list r(gamma)
matrix list r(gammaSTD)
matrix list r(rho)
matrix list r(rhoSTD)

svyset psu[pweight=csweight], strata(stratum) vce(linearized) singleunit(certainty) 

svy linearized : proportion _Best_Index, over(gender)
svy linearized : mean age, over( _Best_Index)
