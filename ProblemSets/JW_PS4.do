*d

clear
cd "/Users/janetjw/Dropbox (University of Michigan)/STATS506/ProblemSets/"
import delimited "ps4_4 .csv"


describe

*e

gen better = 0 
replace better = 1 if b3 >= 3

*f
svyset caseid [pw=weight_pop]

svy: logit better i.nd2 i.b7_a i.gh1 i.educ_4cat i.ppethm

save ps4_4.dta, replace 




better = better off or no?

nd2 = 5 years from now, do you think that the chance you'll experince a disaster will be higher, lower or same?
1-5 = much higher-much lower

b7_a = 1-4 poor to excellent economic conditions

gh1 = 1 = own home with mortgage/loan, 2 = own home free and clear, 3 = pay rent, 4 = none of above

educ 

ppethm 
