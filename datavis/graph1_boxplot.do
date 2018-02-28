// first pull in the dataset
cd "${drive}Data Files\"
use UN_DG_IHDI_Hofstede, clear


// then change the directory to where we wish to save out outputs
cd "${drive}datavis\"



** First things first, let's describe the cultural variables:
#delimit;
graph box pdi-ivr,
	title("Distributions of Hofstede's Cultural Dimensions")
	caption("Scale is 0-100, though Hofstede's index occasionally allows for values above 100")
	legend(size(*0.5))
;
graph export dimensions.png, replace
