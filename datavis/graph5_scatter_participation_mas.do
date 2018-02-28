

// first pull in the dataset
cd "${drive}Data Files\"
use UN_DG_IHDI_Hofstede, clear


// then change the directory to where we wish to save out outputs
cd "${drive}datavis\"





#delimit; 
aaplot any_educ_train_12moFemale mas,
title("Female Participation and Masculinity")
caption("Participation rate of girls and women in formal and non-formal education and training in the previous 12 months", size(2))
	scheme(plottigblind)
	ytitle(Participation Rate)
;
graph export mas_fem_particip.png, replace

