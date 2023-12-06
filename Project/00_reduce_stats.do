#delimit;
clear;
set more off;

cd "/Users/janetjw/Dropbox (University of Michigan)" ;

log using STATS506/Project/00_reducestats.log, t replace ;

set maxvar 32000 ;

use Research/PubPap/00_data/data_clean/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta ;

/* dropping variables that aren't important and most spousal ones */

keep *hhidpn *hhid *cohbyr *awtsamp *aestrat *aehsamp *wthh *wtresp *iwbeg *byear *mstat *agey_* *gender *racem *hispan *cpl *edyrs *edegrm *educ *mstat *mrct *mnev *mwid *mdiv *mend *shlt *hltc *hhresp *jcpen *peninc *ptyp1 *sayret *retwsp *work *samemp *lbrf *inlbrf *retemp *jcten *jcocc *jcind *union *jlten *jloccc *jlocca *jloccb *jlocc *imrc *dlrc *ser7 *bwc20 *smokev *feduc *meduc *itot;

/* 

rename 

rename s*work z*work;
rename s*educ z*educ;
rename s*i* z*i*;
rename s*racem z*racem;  

*/
* rename s*hispan z*hispan;


drop s* ;

*gen racogscore = raimrc + radlrc + raser7 + rabwc20 ; 
*tab racogscore; 

rename r5wtresp weight2000 ;

forval i=2/14 { ;
	
	rename r`i'* wave`i'_r*  ;
	rename h`i'* wave`i'_h*  ;
*	rename z`i'* wave`i'_s*;

	
} ;
	
	rename r1* wave1_r*  ;
	rename h1* wave1_h*  ;
*	rename z1* wave1_s*;

save STATS506/Project/randhrs1992_2018_reduced_edited_stat.dta, replace ;

log close;



