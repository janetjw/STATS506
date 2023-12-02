#delimit;
clear;
set more off;

cd "/Users/janetjw/Dropbox (University of Michigan)/Research/PubPap" ;

log using 00_data/data_clean/logs/00_reduction.log, t replace ;

set maxvar 32000 ;

use 00_data/data_clean/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta ;

/* dropping variables that aren't important and most spousal ones */

keep *hhidpn *hhid *cohbyr *wthh *wtresp *iwbeg *byear *mstat *agey_* *gender *racem *hispan *cpl *edyrs *edegrm *educ *mstat *mrct *mnev *mwid *mdiv *mend *shlt *hltc *atotf *atotb *atotw *atotn *iearn *icap *ipena *issdi *isret *unwc *igxfr *iothr *itot *inpov *hhresp *jcpen *peninc *ptyp1 *sayret *retwsp *work *samemp *lbrf *inlbrf *retemp *jhours *jhour2 *jweeks *wgihr *wgiwk *wgfhr *wgfwk *jphys *jstres *jcten *jcocc *jcind *union *jlten *jlocc *jlind *jjobs *jyears *year *ptyp1 *jcpen  ;

rename s*work z*work;
rename s*educ z*educ;
rename s*i* z*i*;
rename s*racem z*racem;
* rename s*hispan z*hispan;


drop s* ;

*gen year = rabyear - ragey_b ; 
*tab year; 

rename r*ptyp1 r*ptypone ;

forval i=2/14 { ;
	
	rename r`i'* wave`i'_r*  ;
	rename h`i'* wave`i'_h*  ;
	rename z`i'* wave`i'_s*  ;

	
} ;
	
	rename r1* wave1_r*  ;
	rename h1* wave1_h*  ;
	rename z1* wave1_s*  ;

save 00_data/derived/randhrs1992_2018_reduced_edited3.dta, replace ;

*erase 00_data/data_clean/randhrs1992_2018v1_STATA/randhrs1992_2018v1.dta ; 


log close;



