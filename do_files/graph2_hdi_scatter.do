// first pull in the dataset
cd "${drive}Data Files\"
use UN_DG_IHDI_Hofstede, clear


// then change the directory to where we wish to save out outputs
cd "${drive}datavis\"


// Let's see girls' participation in primary school and human development
#delimit; // can this be faceted by year? sure but why would you want to?
twoway (scatter pr_en_girls HDI)(qfit pr_en_girls HDI), 
xscale(log)
	title("Girls' Primary Education and Human Development")
	scheme(s1mono)
;
graph export girl_prim_HDI.png, replace 
