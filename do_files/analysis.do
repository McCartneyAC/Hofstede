// analysis
cd "${drive}Data Files\"
use UN_DG_IHDI_Hofstede, clear


capture ssc install outsum
capture ssc install outreg

cd"${drive}datavis\"
outsum pdi-ivr if year ==2014 using hofstede_sum.txt, ctitle("all")


//before that, let's just summarize Hofstede's vars in a table:
tabstat pdi-ivr if year ==2014, stat(n mean sd min max) 
// needed to pick single year, otherwise would get 24 times the correct result

// Firstly, did their factor analysis do its job and find uncorrelated factors?
pwcorr pdi-ivr
// Sort of? Looks like PDI and IDV are negatively correlated pretty well. 

// define a subset for one year:
gen ia_hdi_2014 = IA_HDI if year == 2014
reg ia_hdi_2014 pdi-ivr
outreg using all_hof, se bdec(3) replace
// that's six hypotheses, so bonferon't forget:
di 0.05/6


// let's test that computers hypothesis as a single regression
egen computers = rowmean(computers*)
reg computers ltowvs
outreg using computers1, se bdec(2) replace
// let's get bigger
egen internet = rowmean(internet*)
egen sss = rowmean(sss*)
egen electricity = rowmean(electricity*)

// let's test some things? 
// this'll be ridiculous but: 
* reg ltowvs computers internet sss electricity // hahahahah! 

// okay let's just say for the sake of argument, you need electricity for a computer
// and you need a computer for the net so... ?
* reg internet computers electricity

// how about this: 
reg computers pdi idv mas uai ltowvs ivr
outreg using computers2, se bdec(2) replace



//// okay let's talk economics
// key variables are econ_parity_literacy and econ_parity_numeracy
cor econ_parity*  // well duh I guess.

reg econ_parity_numeracy pdi IA_inc_index
outreg using ep_numlit, se bdec(2) replace
reg econ_parity_literacy pdi IA_inc_index 
outreg using ep_numlit, se bdec(2) merge

// let's call it a night then. 

cd "${drive}do_files\"
