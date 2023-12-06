#delimit;
clear;
set more off;


cd "/Users/janetjw/Dropbox (University of Michigan)" ;

log using STATS506/Project/02_analysis.log, t replace ;

use STATS506/Project/clean_hrs.dta ;

fvset base 2 rmainocc ;
fvset base 2 myeduc ;
fvset base 1 raracem ;
fvset base 1 ragender ;
fvset base 1 mypeduc ;
fvset base 1 rlbrfsimp ;
fvset base 1 rmainocc ;
replace age = age - 50 ; 

count if personweight == . ;

svyset raehsamp [weight=personweight], strata(raestrat) ;


stset year, failure(cogimp) id(rahhidpn);
sts graph, na ;

 
disp `testing assumptions' ;

stcox c.age i.rmainocc i.myeduc i.raracem i.ragender i.mypeduc i.poorhealth i.rsmokev i.rlbrfsimp , tvc(age poorhealth rsmokev rlbrfsimp) ;

quietly stcox c.age i.rmainocc i.myeduc i.raracem i.ragender i.mypeduc i.poorhealth i.rsmokev i.rlbrfsimp, schoenfeld(sch*) scaledsch(sca*) ;
stphtest, detail;
stphtest, plot(age) msym(oh);

disp `final model' ;

svy: stcox c.age i.rmainocc i.myeduc i.raracem i.ragender i.mypeduc i.poorhealth i.rsmokev i.rlbrfsimp ;
outreg2 using STATS506/Project/stcox_results, excel replace ctitle(cox model results) dec(3) pdec(3) alpha(0.001, 0.01, 0.05) eform ;

disp `postestimation' ;

/*
margins i.rmainocc, at(age=(0 5 10 15 20 25 30 35 40)) ;
mplotoffset,  title("Predicted hazard ratios by main occupation", size(medium)) 
xtitle(Age) xlab(0 "50" 5 "55" 10 "60" 15 "65" 20 "70" 25 "75" 30 "80" 35 "85" 40 "90", angle(45))
ytitle(Predicted Hazard Ratios) ylabel(1 3 5 7 9 11 13 15) ysize(10) xsize(16) legend(position(6) size(small)) ; 
graph export STATS506/Project/marginsplot.png,replace ;
*/

putdocx clear;
putdocx begin ;
contrast  rmainocc ;
pwcompare rmainocc, effects ;

putdocx table pairwise = etable ;
putdocx save STATS506/Project/pwdiffs.docx , replace ;

pwcompare rmainocc, effects ;

matrix pw = r(table_vs)' ;
svmat pw ;
generate hr = exp(pw1); // hazard ratio
generate lb = exp(pw5); // Lower bound of 95% CI
generate ub = exp(pw6); // Upper bound of 95% CI
list pw1 pw5 pw6 hr lb ub in 1/3;

log close;
