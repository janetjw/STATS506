*a

clear
cd "/Users/janetjw/Dropbox (University of Michigan)/STATS506/ProblemSets/"
import sasxport5 "VIX_D.XPT"
tempfile vix_d
save `vix_d'
import sasxport5 "DEMO_D.XPT"
merge 1:1 _n using `vix_d', keep (match) nogenerate
count


*b

gen agecat = .
replace agecat = 0 if ridageyr <= 9
replace agecat = 1 if ridageyr>= 10 & ridageyr <= 19
replace agecat = 2 if ridageyr>= 20 & ridageyr <= 29
replace agecat = 3 if ridageyr>= 30 & ridageyr <= 39
replace agecat = 4 if ridageyr>= 40 & ridageyr <= 49
replace agecat = 5 if ridageyr>= 50 & ridageyr <= 59
replace agecat = 6 if ridageyr>= 60 & ridageyr <= 69
replace agecat = 7 if ridageyr>= 70 & ridageyr <= 79
replace agecat = 8 if ridageyr>= 80

label define agecatl 0 "0-9" 1 "10-19" 2 "20-29" 3 "30-39" 4 "40-49" 5 "50-59" 6 "60-69" 7 "70-79" 8 "80+" 
label values agecat agecatl  

label define viq220l 1 "Yes" 2 "No" 9 "Don't know" 
label values viq220 viq220l  

tab agecat viq220 , missing r


*c

drop if viq220 == 9 
replace viq220 = 0 if viq220 == 2

logit viq220 ridageyr, or
estat ic

logit viq220 ridageyr ridreth1 riagendr, or
estat ic

logit viq220 ridageyr ridreth1 riagendr indfmpir, or
estat ic

*d
ztest viq220, by(riagendr)


