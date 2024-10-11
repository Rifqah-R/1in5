*Stata version
15.1
*** 
************************************************************************
* PART 0: TABLE OF CONTENTS
************************************************************************
clear

* start log 
*capture log close
*log using 

* DHS2016 HIV

* Project: [Multimorbidity in South Africa]
* Creator: [Rifqah Roomaney, rifqah.roomaney@mrc.ac.za, 24/02/2021] 
* Purpose of do-file: Create a subset of all variables of interest
/*
	Outline
	Part 1: Housekeeping & Introduction
	Part 2: Prepare diabetes/anaemia/ BMI dataset using Annibale Cois's code from SA CRA2 
	Part 3: Prepare HIV file
	Part 4: Prepare Mens file for merge
	Part 5: Prepare Womens file for merge
	Part 6: Merge men and women
	Part 7: Merge men and women AND diabetes
	Part 8: Merge men and women and diabetes AND HIV
	Part 9: Clean and label new subset data
*/
************************************************************************
* PART 1: HOUSEKEEPING & INTRODUCTION
************************************************************************
*set more off, permanently //This gives all the output at once without having to click "more"

*Setting file path
global BASE "C:\Users\rroom\OneDrive - South African Medical Research Council\Documents\PhD\Phase 2\SURVEY DATASETS"

* SOURCE FILES DIRECTORIES
global DHS2016 "DHS\DHS2016\Dataset\ZA_2016_DHS_02032019_432_49143"


**************************************************************************************************************
* PART 2: PREPARE BMI/DIAB DATA  - This is a copy of Annibale Cois's do file for preparing diabetes data for the SACRA2***                                                                           *
* WITH ADJUSTMENT FOR DRY BLOOD SPOT (DHS REPORT, pag 271)                                                   *
*                                                                                                            *
* 20191009                                                                                                   *             
**************************************************************************************************************

clear
set more off
			 

**************************************************************************************************************
* EXTRACT AND PREPARE  DIABETES DATA, Anaemia and BP                                                                                       * 
**************************************************************************************************************

use "$BASE/$DHS2016/ZAPR71DT/ZAPR71FL.DTA", clear

* Keep only adults
drop if hv105<15  //drop children

* Subset - keeping diabetes, anaemia and BP

#delimit ; 
keep 
hv001 hv002 hvidx // cluster number & household number & line number
hv104 hv105   // sex & age
ha2 ha3 ha40 sh206a ha54 sh277-sh277l shwhba1c       //weight, height, BMI, hba1c for women
hb2 hb3 hb40 sh306a       sh377-sh377l shmhba1c   //weight, height, BMI, hba1c for men
ha57 hb57 hb56 ha56 //anemia variables in women and men. hb56 is the actual numbers for men
sh221a sh228a sh232a // Women - first, second and third systolic reading
sh321a sh328a sh332a // Men - fist, second and third systolic reading
sh221b sh228b sh232b  // Women - first, second, third diastolic reading 
sh321b sh328b sh332b // Men - first, second, third diastolic reading 
sh324 // Males on medication to lower BP
sh344 // Male BP category
sh224 // Female on medication to lower BP
sh244 ;  // Female - BP category


order
hv001 hv002 hvidx
hv104 hv105 
ha2 ha3 ha40 sh206a ha54 sh277-sh277l shwhba1c
hb2 hb3 hb40 sh306a       sh377-sh377l shmhba1c
ha57 hb57 hb56 ha56  //anemia variables in women and men
sh221a sh228a sh232a // Women - first, second and third systolic reading
sh321a sh328a sh332a // Men - fist, second and third systolic reading
sh221b sh228b sh232b  // Women - first, second, third diastolic reading 
sh321b sh328b sh332b // Men - first, second, third diastolic reading 
sh324 // Males on medication to lower BP
sh344 // Male BP category
sh224 // Female on medication to lower BP
sh244 ;  // Female - BP category 
#delimit cr


rename hvidx hv003 //line number

gsort -hv104

* Eliminate inconclusive values for hba1c (coded as 99995)

replace shwhba1c = . if shwhba1c==99995 //women hba1c
replace shmhba1c = . if shmhba1c==99995   //men hba1c

gen weight_1 =.
gen height_1 =.
gen waist_1 =.
gen bmi =.

gen hba1c =.

gen pregnant =.

replace weight_1 = ha2 if hv104 == 2 
replace height_1 = ha3 if hv104 == 2 
replace waist_1 = sh206a if hv104 == 2 
replace bmi = ha40 if hv104 == 2 
replace hba1c = shwhba1c  if hv104 == 2 
replace pregnant = ha54 if hv104 == 2 

replace weight_1 = hb2 if hv104 == 1 
replace height_1 = hb3 if hv104 == 1 
replace waist_1 = sh306a if hv104 == 1 
replace bmi = hb40 if hv104 == 1 
replace hba1c = shmhba1c  if hv104 == 1 

  * Recode units 

 replace hba1c = hba1c/1000
 replace weight_1 = weight_1/10 
 replace height_1 = height_1/10 
 replace waist_1 = waist_1/10
     
	 
 * ADJUSTEMENT FOR DRYSPOT (DHS 2016 Report, page 271) 
 
replace hba1c = (round(hba1c,0.1)-0.228)/0.9866
	 
* Diabetes medication (A10 code)

gen MED=0

#delimit ;
replace MED=1 if 
substr(sh277a,1,3) == "A10" | 
substr(sh277b,1,3) == "A10" | 
substr(sh277c,1,3) == "A10" | 
substr(sh277d,1,3) == "A10" | 
substr(sh277e,1,3) == "A10" | 
substr(sh277f,1,3) == "A10" | 
substr(sh277g,1,3) == "A10" | 
substr(sh277h,1,3) == "A10" | 
substr(sh277i,1,3) == "A10" | 
substr(sh277j,1,3) == "A10" | 
substr(sh277k,1,3) == "A10" | 
substr(sh277l,1,3) == "A10" | 
substr(sh377a,1,3) == "A10" | 
substr(sh377b,1,3) == "A10" | 
substr(sh377c,1,3) == "A10" | 
substr(sh377d,1,3) == "A10" | 
substr(sh377e,1,3) == "A10" | 
substr(sh377f,1,3) == "A10" | 
substr(sh377g,1,3) == "A10" | 
substr(sh377h,1,3) == "A10" | 
substr(sh377i,1,3) == "A10" | 
substr(sh377j,1,3) == "A10" | 
substr(sh377k,1,3) == "A10" | 
substr(sh377l,1,3) == "A10";
#delimit cr

* Generated diabetes prevalences

gen diab_lab = hba1c>=6.5 
replace diab_lab =. if hba1c>=. 

gen diab_med = diab_lab
replace diab_med=1 if MED==1  


* Drop unused

drop ha2- shmhba1c bmi hv104 hv105

save "$BASE\1 My project\Data_temp\DHS2016_Diabetes_21042021.dta", replace


************************************************************************
* PART 2: Prepare HIV file
************************************************************************
use "$BASE/$DHS2016/ZAAR71DT\ZAAR71FL.DTA", clear //Open DHS 2016 HIV data

***Recode and generate new variables*
* NOTE: Rename the HIV variables to match variables in the other dataset

rename hivclust hv001 	
rename hivnumb hv002  	
rename hivline hv003  

count // 6912 observations
save "$BASE/1 My project\Data_temp\DHS2016_HIV_03102021.dta", replace
clear

************************************************************************
* PART 3: CREATE MALE DATA SUBSET WITH STANDARDISED VARIABLES
************************************************************************

***Prepare SADHS 2016 adult men data***
use "$BASE/$DHS2016/ZAAH71DT/ZAAHM71FL.dta", clear //Open DHS 2016 adult males

***Recode and generate new variables*
* NOTE: The purpose here is to create a subset of the male variables that can be used to append to the female dataset to create one adult dataset

gen pid=_n 					// generate N variable
rename mv021 psu 			// rename psu variable
rename mv023 stratum  		// rename stratum variable
rename smweight csweight  	//rename mv005 csweight 
replace csweight = csweight/1000000 	// 

recode mv102 (1=1) (2=0), gen(urban) // generate urban/rural variable
rename mv101 prov 					// rename province variable

rename mv006 month 			// RAR: might not be important to me
gen day = day(mv008a)
rename mv007 year
gen idate=mdy(month, day, year)

recode mv131 (1=1)(2=2)(3=3)(4=4)(5/10000=.), gen(race) //generate and reorder race
rename  mv012 age 			// rename age
gen gender = 1 				// generate gender (all participants in dataset are male)

gen pregn=0 // 

recode mv106 (0/1=1)(2=2)(3=3), gen(educat)	// reorder education level

rename mv190 wealthindex
tab wealthindex 
*Note: other wealth index variables available mv190a (wealth index for urban/rural), mv191a (wealth index factor score for urban/rural),  

rename mv714 employed // currently working
tab employed


* Body shape variables //NOTE:**keep in for now
gen HT1 = .
gen WT1 = .
gen WC1 = .                           
gen HT2 =. 
gen WT2 =.  
gen WC2 =.  
gen HT3 =.  
gen WT3 =.  
gen WC3 =.  

* Diabetes variables
gen HBA1C = .
gen DIAB_LAB = .
gen DIAB_MED = .

* Selfreport diagnosis for variables of interest
recode sm1108f (0=0)(1=1)(8=.), gen(SELFDIAB) 	// diagnosed with diabetes
recode sm1121 (0=0)(1=1)(8=.), gen(SELFDIAB_T) 	//treatment for diabetes
tab sm1108f SELFDIAB, row

recode sm1108g (0=0)(1=1)(8=.), gen(SELFBRONCH) // diagnosed with chronic bronchitis 
recode sm1123 (0=0)(1=1)(8=.), gen(SELFBRONCH_T) // treatment for chronic bronchitis 
tab sm1108g SELFBRONCH, row

recode sm1108b (0=0)(1=1)(8=.), gen(SELFHEART) // diagnosed with heart attack 
recode sm1113 (0=0)(1=1)(8=.), gen(SELFHEART_T) // treatment of heart attack 
tab sm1108b SELFHEART, row 

recode sm1108e (0=0)(1=1)(8=.), gen(SELFCHOL) // diagnosed with cholesterol
recode sm1119 (0=0)(1=1)(8=.), gen(SELFCHOL_T) // treatment of cholesterol
tab sm1108e SELFCHOL, row

recode sm1108d (0=0)(1=1)(8=.), gen(SELFSTROKE) // had stroke
recode sm1117 (0=0)(1=1)(8=.), gen(SELFSTROKE_T) // treatment of stroke
tab sm1108d SELFSTROKE, row

recode sm1105 (0=0)(1=1)(8=.), gen(SELFTB_EVER) // Ever had TB
recode sm1106 (0=0)(1=1)(2=0)(8=.), gen(SELFTB_WHEN) // When last you had TB (more or less than 12 months)
recode sm1107 (0=0)(1=1)(8=.), gen(SELFTB_T) // Treated for TB
tab sm1105 SELFTB_EVER, row
tab sm1106 SELFTB_WHEN, row

recode sm1108h (0=0)(1=1)(8=.), gen(SELFASTHMA) // Ever diagnosed asthma
recode sm1125 (0=0)(1=1)(8=.), gen(SELFASTHMA_T) // treatment of asthma
tab sm1108h SELFASTHMA, row

recode sm1108c (0=0)(1=1)(8=.), gen(SELFCANCER) // Ever diagnosed cancer
recode sm1115 (0=0)(1=1)(8=.), gen(SELFCANCER_T) // treatment of cancer
tab sm1108c SELFCANCER, row

recode sm1141 (0=0)(1=1)(8=.), gen(SELFTEETH) // Past 12 months did your teeth or mouth cause pain or discomfort
recode sm1142 (0=0)(1=1)(8=.), gen(SELFTEETH_T) // Treatment for teeth / mouth
tab sm1141 SELFTEETH, row

recode sm1138 (0=0)(1=1)(8=.), gen(SELFPAIN) // currently troubled by pain/ discomfort
recode sm1139 (0=0)(1=1)(8=.), gen(SELFPAIN_3MO) // pain for more than 3 months
tab sm1138 SELFPAIN, row

* Smoking
recode mv463aa (0=0)(1/2=1), gen(CURRSMOK) 
recode mv463ac (0=0)(1=1), gen(EVERSMOK) 
replace CURRSMOK=0 if EVERSMOK==0

* Alcohol
recode sm917 (0=0)(1=1), gen(CURRALC)
recode sm916 (0=0)(1=1), gen(EVERALC)
replace CURRALC=0 if EVERALC==0

* Keep only adults 15+ 
drop if age<15	 //everyone is over 15yrs in this dataset

* rename identifiers 

rename mv001 hv001
rename mv002 hv002
rename mv003 hv003
rename mcaseid caseid

* Select variables
keep pid psu stratum csweight day month year idate prov urban gender age race educat pregn wealthindex employed    ///
	  HT1 HT2 HT3 WT1 WT2 WT3 WC1 WC2 WC3   ///
	  HBA1C DIAB_LAB DIAB_MED  ///
	  SELFDIAB SELFDIAB_T SELFBRONCH SELFBRONCH_T SELFHEART SELFHEART_T SELFCHOL SELFCHOL_T SELFSTROKE SELFSTROKE_T ///
	  SELFTB_EVER SELFTB_WHEN SELFTB_T SELFASTHMA SELFASTHMA_T SELFCANCER SELFCANCER_T SELFTEETH SELFTEETH_T SELFPAIN SELFPAIN_3MO ///	  
	  CURRSMOK EVERSMOK CURRALC EVERALC ///
	  hv001 hv002 hv003 caseid //
	  
	  
* Order
order pid psu stratum csweight day month year idate prov urban gender age race educat pregn     ///
	  SELFDIAB SELFDIAB_T SELFBRONCH SELFBRONCH_T SELFHEART SELFHEART_T SELFCHOL SELFSTROKE SELFSTROKE_T ///
	  SELFTB_EVER SELFTB_WHEN SELFTB_T SELFASTHMA SELFASTHMA_T SELFCANCER SELFCANCER_T SELFTEETH SELFTEETH_T SELFPAIN SELFPAIN_3MO ///	  
	  HT1 HT2 HT3 WT1 WT2 WT3 WC1 WC2 WC3   ///
	  HBA1C DIAB_LAB DIAB_MED  ///	
	  CURRSMOK EVERSMOK CURRALC EVERALC ///
	  hv001 hv002 hv003 caseid
	  
count // 4210 obervations
save "$BASE\1 My project\Data_temp\DHS2016_Men_21042021.dta", replace
clear

************************************************************************
* PART 4: CREATE FEMALE DATA SUBSET
*************************************************************************
*Note: Purpose is to create a Female data subset that can be appended to men dataset

***Prepare SADHS adult women data***
use "$BASE/$DHS2016/ZAAH71DT/ZAAHW71FL.dta", clear

* Recode and generate new variables

gen pid=_n
rename v021 psu 
rename v023 stratum  
rename sweight csweight                    //rename v005 csweight 
replace csweight = csweight/1000000

recode v102 (1=1) (2=0), gen(urban) 
rename v101 prov

rename v006 month
gen day = day(v008a)
rename v007 year
gen idate=mdy(month, day, year)

recode v131 (1=1)(2=2)(3=3)(4=4)(5/10000=.), gen(race) 
rename  v012 age
gen gender = 2 

gen pregn=0

recode v106 (0/1=1)(2=2)(3=3), gen(educat)

rename v190 wealthindex
tab wealthindex 
*Note: other wealth index variables available mv190a (wealth index for urban/rural), mv191a (wealth index factor score for urban/rural),  

rename v714 employed // currently working
tab employed

* Body shape variables
gen HT1 = .
gen WT1 = .
gen WC1 = .                           
gen HT2 =. 
gen WT2 =.  
gen WC2 =.  
gen HT3 =.  
gen WT3 =.  
gen WC3 =.  

* Diabetes variables
gen HBA1C = .
gen DIAB_LAB = .
gen DIAB_MED = .

* Selfreport diagnosis for variables of interest
recode s1413f (0=0)(1=1)(8=.), gen(SELFDIAB) 	// diagnosed with diabetes
recode s1426 (0=0)(1=1)(8=.), gen(SELFDIAB_T) 	//treatment for diabetes
tab s1413f SELFDIAB, row

recode s1413g (0=0)(1=1)(8=.), gen(SELFBRONCH) // diagnosed with chronic bronchitis 
recode s1428 (0=0)(1=1)(8=.), gen(SELFBRONCH_T) // treatment for chronic bronchitis 
tab s1413g SELFBRONCH, row

recode s1413b (0=0)(1=1)(8=.), gen(SELFHEART) // diagnosed with heart attack 
recode s1418 (0=0)(1=1)(8=.), gen(SELFHEART_T) // treatment of heart attack 
tab s1413b SELFHEART, row 

recode s1413e (0=0)(1=1)(8=.), gen(SELFCHOL) // diagnosed with cholesterol
recode s1424 (0=0)(1=1)(8=.), gen(SELFCHOL_T) // treatment of cholesterol
tab s1413e SELFCHOL, row

recode s1413d (0=0)(1=1)(8=.), gen(SELFSTROKE) // had stroke
recode s1422  (0=0)(1=1)(8=.), gen(SELFSTROKE_T) // treatment of stroke
tab s1413d SELFSTROKE, row

recode s1410 (0=0)(1=1)(8=.), gen(SELFTB_EVER) // Ever had TB
recode s1411  (0=0)(1=1)(2=0)(8=.), gen(SELFTB_WHEN) // When last you had TB (more or less than 12 months)
recode s1412 (0=0)(1=1)(8=.), gen(SELFTB_T) // Treated for TB
tab s1410 SELFTB_EVER, row
tab s1411 SELFTB_WHEN, row

recode s1413h (0=0)(1=1)(8=.), gen(SELFASTHMA) // Ever diagnosed asthma
recode s1430 (0=0)(1=1)(8=.), gen(SELFASTHMA_T) // treatment of asthma
tab s1413h SELFASTHMA, row

recode s1413c (0=0)(1=1)(8=.), gen(SELFCANCER) // Ever diagnosed cancer
recode s1420 (0=0)(1=1)(8=.), gen(SELFCANCER_T) // treatment of cancer
tab s1413c SELFCANCER, row

recode s1446 (0=0)(1=1)(8=.), gen(SELFTEETH) // Past 12 months did your teeth or mouth cause pain or discomfort
recode s1447 (0=0)(1=1)(8=.), gen(SELFTEETH_T) // Treatment for teeth / mouth
tab s1446 SELFTEETH, row

recode s1443 (0=0)(1=1)(8=.), gen(SELFPAIN) // currently troubled by pain/ discomfort
recode s1444 (0=0)(1=1)(8=.), gen(SELFPAIN_3MO) // pain for more than 3 months
tab s1443 SELFPAIN, row

* Smoking
recode v463aa (0=0)(1/2=1), gen(CURRSMOK) 
recode v463ac (0=0)(1=1), gen(EVERSMOK) 
replace CURRSMOK=0 if EVERSMOK==0

* Alcohol
recode s1225 (0=0)(1=1), gen(CURRALC)
recode s1224 (0=0)(1=1), gen(EVERALC)
replace CURRALC=0 if EVERALC==0


* Keep only adults 15+ 
drop if age<15	 //everyone is over 15yrs in this dataset

* rename identifiers 

rename v001 hv001
rename v002 hv002
rename v003 hv003

* Select variables
keep pid psu stratum csweight day month year idate prov urban gender age race educat pregn wealthindex employed    ///
	  HT1 HT2 HT3 WT1 WT2 WT3 WC1 WC2 WC3   ///
	  HBA1C DIAB_LAB DIAB_MED  ///
	  SELFDIAB SELFDIAB_T SELFBRONCH SELFBRONCH_T SELFHEART SELFHEART_T SELFCHOL SELFCHOL_T SELFSTROKE SELFSTROKE_T ///
	  SELFTB_EVER SELFTB_WHEN SELFTB_T SELFASTHMA SELFASTHMA_T SELFCANCER SELFCANCER_T SELFTEETH SELFTEETH_T SELFPAIN SELFPAIN_3MO ///
	  CURRSMOK EVERSMOK CURRALC EVERALC ///
	  hv001 hv002 hv003 caseid //
	  
	  
* Order
order pid psu stratum csweight day month year idate prov urban gender age race educat pregn     ///
	  SELFDIAB SELFDIAB_T SELFBRONCH SELFBRONCH_T SELFHEART SELFHEART_T SELFCHOL SELFCHOL_T SELFSTROKE SELFSTROKE_T ///
	  SELFTB_EVER SELFTB_WHEN SELFTB_T SELFASTHMA SELFASTHMA_T SELFCANCER SELFCANCER_T SELFTEETH SELFTEETH_T SELFPAIN SELFPAIN_3MO ///	  
	  HT1 HT2 HT3 WT1 WT2 WT3 WC1 WC2 WC3   ///
	  HBA1C DIAB_LAB DIAB_MED  ///	
	  CURRSMOK EVERSMOK CURRALC EVERALC ///
	  hv001 hv002 hv003 caseid
	  
count //6126 women
save "$BASE\1 My project\Data_temp\DHS2016_Women_21042021.dta", replace



************************************************************************
* PART 5: CREATE A JOINED FEMALE AND MALE DATASET WITH VARIABLES OF INTEREST
************************************************************************

**Append women to men to create one dataset for adults***
use "$BASE\1 My project\Data_temp\DHS2016_Women_21042021.dta"
append using "$BASE\1 My project\Data_temp\DHS2016_Men_21042021.dta"
count //10336 men and women

save "$BASE\1 My project\Data_temp\DHS2016_MergedWomenMen_21042021.dta", replace

************************************************************************
* PART 6: MERGE DIABETES DATASET
************************************************************************
*** Merge BMI data & diabetes data (from household questionnaire)
  
use "$BASE\1 My project\Data_temp\DHS2016_MergedWomenMen_21042021.dta" 
  merge 1:1 hv001 hv002 hv003 using "$BASE\1 My project\Data_temp\DHS2016_Diabetes_21042021.dta"
  
  drop if _merge==2

  replace pregn=pregnant
  replace WT1=weight_1
  replace HT1=height_1
 replace WC1=waist_1 
  
  replace HBA1C = hba1c
  
  replace DIAB_LAB = diab_lab
  replace DIAB_MED = diab_med
      
  drop caseid waist_1 weight_1 height_1 pregnant _merge hba1c diab_lab diab_med
  
  
**Clean anaemia data    //Notes: The adjusted Hb values were used (smoking and altitude).The odd recoding is due to the egen function. It's neccesary to distinguish between 0 and missing.
tab hb56 if hb56>=130 //Men who are not anaemic have hemoglobin >=13
egen anaemia_m = cut(hb56), at(0,130,250) icodes
list anaemia_m hb56
recode anaemia_m (1=2) (0=1)

tab ha56 if ha56>=120 //Women who are not anaemic have hemoglobin >=12
egen anaemia_w = cut(ha56), at(0,120,250) icodes
list anaemia_w ha56
recode anaemia_w (1=2) (0=1)


egen  anaemia= rowtotal(anaemia_m anaemia_w) //combining male and female seperate variables for anaemia
recode anaemia 0=.  
recode anaemia (2=0) 
	

  
* Adjust weights for population proportion males/females (refs: statsSA mid-yer estimates 2016 - 15+. Source: https://www.statssa.gov.za/publications/P0302/P03022016.pdf) 

sum csweight if gender==1
replace csweight=csweight/r(N)*18888275 if gender==1   

sum csweight if gender==2
replace csweight=csweight/r(N)*20213349 if gender==2

save "$BASE\1 My project\Data\DHS2016_cleaned_03052021.dta", replace 

************************************************************************
* PART 6: MERGE HIV DATASET
************************************************************************
*** Merge HIV & diabetes data (from household questionnaire)

**Merge files
use "$BASE\1 My project\Data\DHS2016_cleaned_03052021.dta"

merge 1:1 hv001 hv002 hv003 using "$BASE/1 My project\Data_temp\DHS2016_HIV_03102021.dta"

save "$BASE\1 My project\Data_temp\DHS2016_MergedHIV_03052021.dta", replace


************************************************************************
* PART 7: Clean subset of data
************************************************************************

use "$BASE\1 My project\Data_temp\DHS2016_MergedHIV_03052021.dta", replace

label drop _all

label def yesno 1 "Yes" 0 "No", replace
label def gender 2 "Female" 1 "Male", replace
label def race 1 "Black" 2 "White" 3 "Coloured" 4 "Asian"
label def urban 1 "Urban" 0 "Rural"
label def prov 1 "Western Cape" 2 "Eastern Cape" 3 "Northern Cape" 4 "Free State" 5 "Kwa-Zulu Natal"  ///
               6 "North West" 7 "Gauteng" 8 "Mpumalanga" 9 "Limpopo"     
label def educ 1 "None/Primary" 2 "Secondary" 3 "Tertiary"	
label def tbwhen 1 "Last 12mo" 0 "More than 12mo", replace
label def wealthindex 1 "Poorest" 2 "Poorer" 3 "Middle" 4 "Richer" 5 "Richest"
label def bpcat 1 "normal(optimal)" 2 "normal(mildly high)" 3 "normal(moderately high)" 4 "abnormal(mildly elevated)" 5 "abnormal(moderately elevated)" 6 "abnormal(severely elevated)" 

label val gender gender
label val race race
label val urban urban
label val prov prov
label val wealthindex wealthindex
label val pregn employed anaemia DIAB_LAB DIAB_MED SELFDIAB MED SELFDIAB SELFDIAB_T SELFBRONCH SELFBRONCH_T SELFHEART SELFHEART_T SELFCHOL SELFSTROKE SELFSTROKE_T SELFTB_EVER SELFTB_T SELFASTHMA SELFASTHMA_T SELFCANCER SELFTEETH SELFTEETH_T SELFPAIN SELFPAIN_3MO yesno
label val SELFTB_WHEN tbwhen
label val educat educ
label val sh324 sh224 yesno //BP meds
label val sh344 sh244 bpcat 
label val CURRSMOK EVERSMOK CURRALC EVERALC  yesno
label val anaemia yesno


label var psu "Primary sampling unit"
label var csweight "Sampling weight - individual"		   
label var stratum "Stratum"  
label var gender "Gender"
label var race "Race"
label var prov "Province"	 
label var urban "geotype"
label var age "Age"	 
label var day "Day of interview"
label var month "Month of interview"
label var year "Year of interview"	 
label var idate "Date of interview"
label var pregn "Current pregnancy"

label var educat "Education"
label var MED "Use of medication"

label var sh221a "F 1st systolic reading"
label var sh228a "F 2nd systolic reading"
label var sh232a "F 3rd systolic reading"


label var sh321a "M 1st systolic reading"
label var sh328a "M 2nd systolic reading"
label var sh332a "M 3rd systolic reading"

label var sh221b "F 1st diastolic reading"
label var sh228b "F 2nd diastolic reading"
label var sh232b "F 3rd diastolic reading"

label var sh321b "M 1st diastolic reading"
label var sh328b "M 2nd diastolic reading"
label var sh332b "M 3rd diastolic reading"

label var sh324 "M BP meds" // Males on medication to lower BP
label var sh224 "F BP meds" // Female on medication to lower BP

label var sh344 "M BP cat_DHS" // Male BP category
label var sh244 "F BP cat_DHS"  // Female - BP category
 
label var HT1 "Height 1"
label var HT2 "Height 2"
label var HT3 "Height 3"

label var WT1 "Weight 1"
label var WT2 "Weight 2"
label var WT3 "Weight 3"

label var WC1 "Waist 1"
label var WC2 "Waist 2"
label var WC3 "Waist 3"

label var HBA1C "HBA1C %"
label var DIAB_LAB "Uncontrolled diabetes"
label var DIAB_MED "Diabetes"

label var CURRSMOK "Current smoking"
label var EVERSMOK "Ever smoking"
label var CURRALC "Current alcohol use"
label var EVERALC "Ever alcohol use"

label var SELFDIAB "Self-reported diagnosis of diabetes"
label var SELFDIAB_T "Treatment for self-reported diabetes"
label var SELFBRONCH "Self-reported bronchitis or COPD"
label var SELFBRONCH_T "Treatment for self-reported bronchitis"
label var SELFHEART "Self-reported heart attack and angina"
label var SELFHEART_T  "Treatment for self-reported heart attack"
label var SELFCHOL  "Self-reported high blood cholesterol"
label var SELFCHOL_T  "Self-reported high blood cholesterol"
label var SELFSTROKE  "Self-reported stroke"
label var SELFSTROKE_T  "Treatment for self-reported stroke"
label var SELFTB_EVER  "Self-reported ever diagnosed with TB"
label var SELFTB_WHEN  "When were you diagnosed with TB"
label var SELFTB_T  "Treatment for self-reported TB"
label var SELFASTHMA  "Self-reported ever diagnosed with asthma"
label var SELFASTHMA_T  " Treatment self-reported ever asthma"
label var SELFCANCER  "Self-reported ever diagnosed with cancer"
label var SELFCANCER_T  "Treatment self-reported cancer"
label var SELFTEETH  "Self-reported pain from teeth mouth in past 12mo"
label var SELFTEETH_T "Treatment self-reported teeth/mouth pain"
label var SELFPAIN "Currently troubled by pain"
label var SELFPAIN_3MO  "Chronic pain"


**Generate 10 year age group
recode age (15/19= 1 "15-19") (20/29=2 "20-29") (30/39=3 "30-39") (40/49=4 "40-49") (50/59=5 "50-59") (60/69=6 "60-69") (70/79=7 "70-79") (80/100=8 "80+") ,generate(age_10)
tabstat age, stat (n, mean, median, sd, p25, p75, min, max)
tab age_10

************************************************************************
* PART 1.1: MAIN ANALYSIS - ADDITIONAL CLEANING / to be moved into the "previous" do-file eventually
************************************************************************
gen id= _n //The PID is not unique as it was the ID for males and females 
list pid if _merge==2
drop if _merge==2 //328 observations deleted that came from the HIV dataset with no other information

**Generate TB variable for those that never had TB and had TB more than 12 months ago
gen SELFTB12 = cond( SELFTB_WHEN == 1, 1, cond( SELFTB_EVER == 0 | SELFTB_WHEN == 2, 0, .)) //This variable shows who had TB in the past 12 months 
recode SELFTB12 .=0
label values SELFTB12 yesno
label variable SELFTB12 "Self-reported TB in last 12 months"

*****Generate BMI //Cut offs based on CRA-2 BMI paper - Bradshaw et al (2021)
drop HT2 HT3 WT2 WT3 WC2 WC3  //DHS2016 ony had one measurement
// there are 1987 HT1 variables coded as 999

*Clean height for men
gen height_m = HT1 if gender == 1 //men and women have different cut-off points for height
replace height_m =. if (height_m < 130) //men height lower limit= 130cm (3 changes)
replace height_m =. if (height_m > 229) //men height upper limit = 229cm (911 changes - includes missing)
*hist height_m  //check

*Clean height for women
gen height_w = HT1 if gender == 2 //men and women have different cut-off points for height
replace height_w =. if (height_w < 110)  //women height lower limit= 110cm (0 changes)
replace height_w =. if (height_w > 210) // women height upper limit = 210cm (1076 changes - includes missing)
*hist height_w  //check for outliers

*Merge height variable and divide be 100 to convert to metres
egen height_p= rowtotal(height_w height_m)  // adds up two variables but no variable has values for man and woman- it is either / or
recode height_p 0=.  
*hist height_p
gen height= height_p/100  //convert to metres
drop height_m height_w height_p

***Clean weight for men
gen weight_m = WT1 if gender == 1 //men and women have different cut-off points for weight
replace weight_m =. if (weight_m < 35)  //men weight lower limit= 35 kg (5 changes)
replace weight_m =. if (weight_m > 300) //men weight upper limit = 300kg (929 changes - includes missing)
  
*Clean weight for women
gen weight_w = WT1 if gender == 2 //men and women have different cut-off points for weight
replace weight_w =. if (weight_w < 25) //women weight lower limit= 25kg (0 changes)
replace weight_w =. if (weight_w > 300) //women weight upper limit = 300kg (1099 changes - includes missing)
*hist weight_w

*Merge weight variable 
egen weight= rowtotal(weight_w weight_m)  //Not the most elegant solution - adds up two variables but no variable has values for man and woman- it is either / or
recode weight 0=.  
*hist weight
drop weight_m weight_w 

***Create BMI variable
bmi BMI , ht(height) wt(weight) metric 
summarize BMI
replace BMI =. if (BMI > 60) //upper limit is 60 (3 changes)
replace BMI =. if (BMI < 14) // lower limit is 14 (2 changes)
egen bmi_cat = cut(BMI), at(14,18.5,25,30,35,40,61) icodes  //Cut offs for each category of BMI. Note: The BMI for underweight is 15 to 18.5. I've included 11 vales at BMI =14.
label define BMI_Cat 0 "Underweight" 1 "Normal weight" 2 "Overweight" 3 "Obesity grade 1" 4 "Obesity grade 2" 5 "Obesity grade 3"
label values bmi_cat BMI_Cat
*list BMI bmicat2 if BMI>55
catplot bmi_cat

summarize BMI
*graph box BMI


** Clean anaemia
drop ha57 hb57  //drops the variables (male anaemia / female anaemia) used to create anaemia

**Clean HIV
tab hiv06
gen hiv = hiv06
label val hiv yesno
tab hiv


***Clean Hypertension data **categories from email AC
drop sh221a sh321a sh221b sh321b  // drop the first systolic and diastolic measurements for men and women

**merge men and women for 2nd systolic reading
egen systolic2 = rowtotal(sh228a sh328a)  //creates one variable for men and women for the 2nd systolic reading
*browse sh228a sh328a systolic2 gender
recode systolic2 0=.  //egen rowtotal creates 0s where there was no data so replace the 0 with missing
*remove implausible values
replace systolic2 =. if (systolic2 > 270) //upper limit is 270 (4 changes)
replace systolic2 =. if (systolic2 < 70) // lower limit is 70 (1 change)

**merge men and women for 3rd systolic reading
egen systolic3 = rowtotal(sh232a sh332a)  //creates one variable for men and women for the 2nd systolic reading
*browse sh232a sh332a systolic3 gender
recode systolic3 0=.  //egen rowtotal creates 0s where there was no data so replace the 0 with missing
*remove implausible values
replace systolic3 =. if (systolic3 > 270) //upper limit is 270 (9 changes)
replace systolic3 =. if (systolic3 < 70) // lower limit is 70 (0 change)

**create average systolic reading
egen systolic_check = rowmean(systolic2 systolic3)  //creates average between the readings (but ignores if one is missing)
gen systolic= (systolic2 + systolic3)/2 // This makes sure that one person had two readings
*browse systolic systolic2 systolic3
replace systolic =. if (systolic > 270) //upper limit is 270 (0 changes) 
replace systolic =. if (systolic < 70) // lower limit is 70 (0 changes)

**merge men and women for 2nd diastolic reading **categories email AC
egen diastolic2 = rowtotal(sh228b sh328b )  //creates one variable for men and women for the 2nd diastolic reading
*browse sh228b sh328b diastolic2 gender
recode diastolic2 0=.  //egen rowtotal creates 0s where there was no data so replace the 0 with missing
*remove implausible values
replace diastolic2 =. if (diastolic2 > 150) //upper limit is 150 (7 changes)
replace diastolic2 =. if (diastolic2 < 30) // lower limit is 30 (0 changes)

**merge men and women for 3rd diastolic reading **categories email AC
egen diastolic3 = rowtotal(sh232b sh332b)  //creates one variable for men and women for the 2nd diastolic reading
browse sh232b sh332b diastolic3 gender
recode diastolic3 0=.  //egen rowtotal creates 0s where there was no data so replace the 0 with missing
*remove implausible values
replace diastolic3 =. if (diastolic3 > 150) //upper limit is 150 (12 changes)
replace diastolic3 =. if (diastolic3 < 30) // lower limit is 30 (0 changes)

**create average systolic reading **categories email AC
egen diastolic_check = rowmean(diastolic2 diastolic3)  //creates an average of the two readings but ignores missing
gen diastolic= (diastolic2 + diastolic3)/2 // This makes sure that one person had two readings
browse diastolic diastolic2 diastolic3
replace diastolic =. if (diastolic > 150) //upper limit is 150 (0 changes)
replace diastolic =. if (diastolic < 30) // lower limit is 30 (0 change)

*create hypertension variable  **The categories are from Chobanian et al in Annibale Cois thesis page 26
gen byte htn_cat = .
replace htn_cat =0 if systolic<120 & diastolic<80
replace htn_cat = 1 if inrange(systolic,120,139) | inrange(diastolic, 80,89)
replace htn_cat = 2 if inrange(systolic,140,159) | inrange(diastolic,90,99)
replace htn_cat = 3 if (systolic>=160 & systolic<.) | (diastolic>=100 & diastolic<.)
label define htn_cat 0 "normal" 1 "pre-hypertension" 2 "stage 1 hypertension" 3 "stage 2 hypertension", replace
la val htn_cat htn_cat
tab htn_cat
*make it binary
gen htn = htn_cat
replace htn = 0 if htn_cat==0 | htn_cat==1
replace htn = 1 if htn_cat==2 | htn_cat==3
label val htn yesno
tab htn


drop systolic2 systolic3 diastolic2 diastolic3 sh228a sh232a sh328a sh332a sh228b sh232b sh328b sh332b diastolic_check systolic_check

*people on medication for hypertension
*create male and female variable
egen bp_meds = rowtotal(sh224 sh324) //Add up the males and females on medication for BP 
tab bp_meds
tab bp_meds htn, missing  // Put into has hypertension
replace htn = 1 if bp_meds==1
tab htn, missing


**Create diabetes variable if people answered self-reported diabetes or if they have high HBa1c
gen byte diabetes = .
replace diabetes = 1 if SELFDIAB==1
replace diabetes = 0 if SELFDIAB==0
replace diabetes = 1 if DIAB_MED==1
label val diabetes yesno
browse diabetes DIAB_MED SELFDIAB


drop HT1 WT1 WC1 HBA1C hb56 ha56 sh324 sh344 sh224 sh244 anaemia_m anaemia_w hiv07 hiv08 height weight systolic diastolic bp_meds
drop DIAB_LAB MED hiv01 hiv02 hiv03 hiv05 hiv06
drop SELFTB_EVER SELFTB_WHEN _merge


order id pid psu stratum csweight day month year idate prov urban gender age age_10 race educat pregn wealthindex employed ///
	hv001 hv002 hv003 /// 	
	SELFDIAB SELFBRONCH SELFHEART SELFCHOL SELFSTROKE DIAB_MED SELFTB12 ///
	anaemia hiv htn htn_cat diabetes BMI bmi_cat ///



save "$BASE\1 My project\Data\DHS2016_subset_03052021.dta", replace


