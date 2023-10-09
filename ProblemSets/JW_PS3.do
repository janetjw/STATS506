
cd "/Users/janetjw/Dropbox (University of Michigan)/STATS506/ProblemSets/"

import sasxport5 "VIX_D.XPT"

tempfile vix_d
save `vix_d'
	
import sasxport5 "DEMO_D.XPT"
save `deno_d'

use `vix_d'
	
merge 1:1 using `seqn'

count
