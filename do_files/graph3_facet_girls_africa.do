// first pull in the dataset
cd "${drive}Data Files\"
use UN_DG_IHDI_Hofstede, clear


// then change the directory to where we wish to save out outputs
cd "${drive}datavis\"





// let's do this for just a few countries of interest: 
local nation "Angola Benin Botswana Burundi Cameroon Chad Gambia Lesotho Liberia Malawi Rwanda Sudan Tunisia Uganda Zambia"
foreach q in `nation' {
		 twoway (scatter pr_en_girls year)(qfit pr_en_girls year) if countryorarea == "`q'", name(`q'_scatter, replace) legend(off) title("`q'")
}
#delimit;
graph combine 
Angola_scatter Benin_scatter Botswana_scatter Burundi_scatter 
Cameroon_scatter Chad_scatter Gambia_scatter Lesotho_scatter 
Liberia_scatter  Rwanda_scatter  
Tunisia_scatter Uganda_scatter Zambia_scatter,
	col(4) 
	title("Primary Enrollment of Girls")
	subtitle("For select African Nations, 1990-2014")
	scheme(s1mono)
;
graph export african_nations_girls.png, replace

graph drop _all

