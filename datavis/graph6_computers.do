


// first pull in the dataset
cd "${drive}Data Files\"
use UN_DG_IHDI_Hofstede, clear


// then change the directory to where we wish to save out outputs
cd "${drive}datavis\"





#delimit; 
aaplot computers_prim ltowvs, 
	title("Primary Education")
	subtitle(,size(vsmall))
	scheme(plottigblind)
	ytitle(Percent With Computers)
	legend(off) 
	name(primarycomps, replace)
;	
#delimit; 
aaplot computers_low_sec ltowvs, 
	title("Lower Secondary Education")
	subtitle(,size(vsmall))
	scheme(plottigblind)
	ytitle(Percent With Computers)
	legend(off) 
	name(lowseccomps, replace)
;	
#delimit; 
aaplot computers_up_sec ltowvs, 
	title("Upper Secondary Education")
	subtitle(,size(vsmall))
	scheme(plottigblind)
	ytitle(Percent With Computers)
	legend(off) 
	name(upseccomps, replace)
;		
#delimit;
graph combine 
primarycomps lowseccomps upseccomps, 
col(3)
subtitle("Are countries with longer-term orientations more likely to invest in computers in primary education?", size(2))
title("Classroom Computers and Long/Short term Orientation")
; 

graph export lto_comps.png, replace

graph drop primarycomps lowseccomps upseccomps

