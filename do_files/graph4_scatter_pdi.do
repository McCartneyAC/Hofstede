
// first pull in the dataset
cd "${drive}Data Files\"
use UN_DG_IHDI_Hofstede, clear


// then change the directory to where we wish to save out outputs
cd "${drive}datavis\"



#delimit;
aaplot IA_inc_index pdi,
title("Inequality-Adjusted Income vs. Power-Distance")
	scheme(sj)
;
graph export pdi_IAI.png, replace

