// name:  Data Management Final Project 2017
// purpose: Merge Multiple Secondary Data Sets, glean new insights? 
// author: Andrew McCartney
// date: 11-25-2017

cd "${drive}Data Files\UN Data Main\"

// display this at the end to summarize what has been merged for the reader. 
capture program drop myprog 
program myprog 
	di "The data set contains " _N " observations of " c(k) " variables."
	di "Type 'Browse', 'describe', or 'codebook' for more information."
end 

// This section begins the lengthy task of merging all three data sets. 

// the data sets are in three parts, in the following order: 
*1A 10 Data sets from the UN charting the Education piece of the Millennium
*1A Development goals. 

*1B 31 Data sets from the UN charting various education data used to assess progress
*1B on the Sustainable Development goals. 

*2 UN Data regarding the Inequality-Adjusted Human Development Index and other
*2 Income-Adjusted country-level metrics

*3 Hofstede's data on cultural dimensions (5-6 parameters for ~100 countries

// Once joined, these will comprise a final data set that can be explored for
// the purposes of this project. 

//////////////////// Begin part one

*1A Get the 11 MDG data sets to merge. 

// first we must import all .csvs and convert them to dta files:

//starting with the MDG data sets
forvalues i=1(1)10 {
import delimited "UNdata_Export_MDG`i'.csv", clear
save UNdata_Export_MDG`i', replace
}

// And then doing the same for the SDG Data sets: 
forvalues i=1(1)31 {
import delimited "UNdata_Export_SDG`i'.csv", clear
save UNdata_Export_SDG`i', replace
} 




// now import each MDG data set one by one and rename the "VALUE" variable appropriately. 
local mdgnames "pr_enr_both_sex pr_enr_boys pr_en_girls pr_comp_both_sex pr_comp_boys pr_comp_girls adult_lit_both_sex adult_lit_men adult_lit_women w_to_m_lit_parity"
local n : word count `mdgnames'
forvalues k = 1(1)`n' {
	use "UNdata_Export_MDG`k'", clear
		local a: word `k' of `mdgnames'
	rename value `a' 
	save UNdata_Export_MDG`k'_renamed, replace
}
// Parallel locals, locals WITHIN locals
// this is my true accomplishment. 


// now merge all ten of those newly minted data sets
use "UNdata_Export_MDG1_renamed", clear
forvalues i=2(1)10 {
merge 1:1 countryorarea year using UNdata_Export_MDG`i'_renamed
drop _merge
}



/*
#delimit; 
local mdglabels
 "totalnetenrolmentratioinprimary 
 totalnetenrolmentratioinprimarye 
 totalnetenrolmentratioinprimarye 
 primarycompletionratebothsexes 
 primarycompletionrateboys 
 primarycompletionrategirls 
 literacyratesof1524yearsoldboths 
 literacyratesof1524yearsoldmenpe 
 literacyratesof1524yearsoldwomen 
 womentomenparityindexasratioofli"
;

label var pr_enr_both_sex-w_to_m_lit_parity `mdglabels'
*/ // not sure why this code didn't work as written, but fixing it is just as much
   // work as doing this: 

   
   
// re-label the variables for ease of use.   
label var pr_enr_both_sex 		"primary enrollment total"
label var pr_enr_boys  			"primary enrollment boys"
label var pr_en_girls 			"primary enrollment girls"
label var pr_comp_both_sex  	"primary completion total"
label var pr_comp_boys   		"primary completion boys"
label var pr_comp_girls 		"primary completion girls"
label var adult_lit_both_sex 	"Adult literacy both sexes"
label var adult_lit_men 		"Adult literacy men"
label var adult_lit_women 		"Adult literacy women"
label var w_to_m_lit_parity		"Women-to-men literacy parity"


// save this merged MDG data set for a later larger merge. 
save UNdata_Export_MDG_merged, replace


// Before we can begin doing the same for the SDGs, variable names and 
// observation names must be standardized. 

forvalues i=1(1)31 {
	use "UNdata_Export_SDG`i'", clear
		rename referencearea countryorarea 
		rename timeperiod year
		replace countryorarea = "Korea, Republic of" if countryorarea == "Republic of Korea"
		replace countryorarea = "Czech Republic" if countryorarea == "Czechia" 
		replace countryorarea = "Bolivia" if countryorarea == "Bolivia (Plurinational State of)"
		replace countryorarea = "Micronesia, Federated States of" if countryorarea == "Micronesia (Federated States of)" 
		replace countryorarea = "United Kingdom" if countryorarea == "United Kingdom of Great Britain and Northern Ireland" 
		replace countryorarea = "United States" if countryorarea ==	"United States of America" 
		replace countryorarea = "Venezuela"	if countryorarea ==	"Venezuela (Bolivarian Republic of)" 
		replace countryorarea = "Cape Verde" if countryorarea == "Cabo Verde" 
		replace countryorarea = "Republic of Moldova" if countryorarea == "Moldova (Republic of)" 
		capture replace countryorarea = "Republic of Moldova" if countryorarea == "Moldova"
	save UNdata_Export_SDG`i'_m, replace
	* just appending an _m to remind myself 
}

* Technically I think I'm actually going backward in time here. Czechia is now
* the proper English name of the country and certainly I'm shortening the 
* names of the UK and the US, but I think it's easier to do it this way than
* to run two loops on two different sets just for the sake of not hurting 
* Czech feelings. 


// once again, bringing each one in individually to rename its "value" variable
// however, this time we are also widening any data set that has "gender" as a
// factor, roughly 32% of them. 
local sdgnames "low_sec_profic_math low_sec_profic_read prim_profic_math prim_profic_math pre_prim_particip any_educ_train_12mo gender_parity_numeracy gender_parity_literacy econ_parity_literacy econ_parity_numeracy gend_parity_tch_train_pre_prim gend_parity_tch_train_prim gend_parity_tch_train_up_sec computers_low_sec electricity_low_sec drinking_h20_low_sec internet_low_sec sss_low_sec computers_prim electricity_prim drinking_h20_prim internet_prim sss_prim computers_up_sec electricity_up_sec internet_up_sec sss_up_sec tch_trn_low_sec tch_trn_pre_prim tch_trn_prim tch_trn_up_sec"
local m : word count `sdgnames'
forvalues p = 1(1)`m' {
	use "UNdata_Export_SDG`p'_m", clear
		local b: word `p' of `sdgnames'
	rename value `b' 
	capture reshape wide `b', i(countryorarea year) j(sex) string
	save UNdata_Export_SDG`p'_renamed, replace
}
// I'm pretty proud of this one I'm not gonna lie. 


// then merge all 31 of these together. 
use "UNdata_Export_SDG1_renamed", clear
forvalues i=2(1)31 {
merge 1:1 countryorarea year using UNdata_Export_SDG`i'_renamed
drop _merge
}



// The variable names must now be relabeled. The trick with the Local does not 
// seem to be working here either, so I just eliminated all the extra business
// around these from when the code was longer and left their essence: 
label variable low_sec_profic_mathFemale  	"Proportion of girls at the end of lower secondary achieving at least a minimum proficiency level in mathematics"
label variable low_sec_profic_mathMale 		"Proportion of boys at the end of lower secondary achieving at least a minimum proficiency level in mathematics"
label variable low_sec_profic_mathTotal 	"Proportion of all children at the end of lower secondary achieving at least a minimum proficiency level in mathematics"
label variable low_sec_profic_readFemale  	"Proportion of girls at the end of lower secondary achieving at least a minimum proficiency level in reading"
label variable low_sec_profic_readMale 		"Proportion of boys at the end of lower secondary achieving at least a minimum proficiency level in reading"
label variable low_sec_profic_readTotal		"Proportion of all children at the end of lower secondary achieving at least a minimum proficiency level in reading"
label variable prim_profic_mathFemale 	"Proportion of girls at the end of primary achieving at least a minimum proficiency level in mathematics"
label variable prim_profic_mathMale 	"Proportion of boys at the end of primary achieving at least a minimum proficiency level in mathematics"
label variable prim_profic_mathTotal 	"Proportion of children at the end of primary achieving at least a minimum proficiency level in mathematics"
label variable prim_profic_mathFemale  	"Proportion of girls at the end of primary achieving at least a minimum proficiency level in reading"
label variable prim_profic_mathMale 	"Proportion of boys at the end of primary achieving at least a minimum proficiency level in reading"
label variable prim_profic_mathTotal 	"Proportion of children at the end of primary achieving at least a minimum proficiency level in reading"
label variable pre_prim_participMale 	"boys' Participation rate in organized learning (one year before the official primary entry age)"
label variable pre_prim_participFemale 	"girls' Participation rate in organized learning (one year before the official primary entry age)"
label variable pre_prim_participTotal 	"total Participation rate in organized learning (one year before the official primary entry age)"
label variable any_educ_train_12moFemale 	"Participation rate of girls and women in formal and non-formal education and training in the previous 12 months"
label variable any_educ_train_12moMale   	"Participation rate of boys and men in formal and non-formal education and training in the previous 12 months"
label variable any_educ_train_12moTotal		"Participation rate of all youth and adults in formal and non-formal education and training in the previous 12 months"        
label variable gender_parity_numeracy			"gender parity in numeracy at fixed age level"
label variable gender_parity_literacy 			"gender parity in literacy at fixed age level"
label variable econ_parity_literacy				"low-high economic parity in numeracy at fixed age level"
label variable econ_parity_numeracy				"low-high economic parity in literacy at fixed age level"
label variable gend_parity_tch_train_pre_prim 			"Gender parity index of teachers in pre-primary education who are trained"
label variable gend_parity_tch_train_prim			"Gender parity index of teachers in primary education who are trained"
label variable gend_parity_tch_train_up_sec			"Gender parity index of teachers in upper-secondary education who are trained"
label variable computers_low_sec			"pct of schools with computers for pedagogical purposes, lower secondary"
label variable electricity_low_sec			"pct of schools with electricity, lower secondary"
label variable drinking_h20_low_sec			"pct of schools with basic drinking water, lower secondary"
label variable internet_low_sec			"pct of schools with internet for pedagogical purposes lower secondary"
label variable sss_low_sec			"pct of schools with single-sex sanitation, lower secondary"
label variable computers_prim			"pct of schools with computers for pedagogical purposes, primary"
label variable electricity_prim			"pct of schools with electricity,primary"
label variable  drinking_h20_prim			"pct of schools with basic drinking water,primary"
label variable internet_prim			"pct of schools with internet for pedagogical purposes,primary"
label variable sss_prim			"pct of schools with single-sex sanitation,primary"
label variable computers_up_sec			"pct of schools with computers for pedagogical purposes, upper secondary"
label variable electricity_up_sec			"pct of schools with electricity, upper secondary"
label variable internet_up_sec			"pct of schools with internet for pedagogical purposes, upper secondary"
label variable sss_up_sec			"pct of schools with single-sex sanitation, upper secondary"
label variable tch_trn_low_secFemale  	"Proportion of female teachers in lower secondary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"
label variable tch_trn_low_secMale 	"Proportion of male teachers in lower secondary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"	
label variable tch_trn_low_secTotal 	"Proportion of all teachers in lower secondary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"
label variable tch_trn_pre_primFemale	"Proportion of female teachers in pre-primary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"
label variable tch_trn_pre_primMale  	"Proportion of male teachers in pre-primary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"	
label variable tch_trn_pre_primTotal 	"Proportion of all teachers in pre-primary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"
label variable tch_trn_primFemale	"Proportion of female teachers in primary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"
label variable tch_trn_primMale 	"Proportion of male teachers in primary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country" 	
label variable tch_trn_primTotal 	"Proportion of all teachers in primary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"
label variable tch_trn_up_secFemale	"Proportion of female teachers in upper secondary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"
label variable tch_trn_up_secMale	"Proportion of male teachers in upper secondary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"
label variable tch_trn_up_secTotal	"Proportion of all teachers in upper secondary education who have received at least the minimum organized teacher training (e.g. pedagogical training) pre-service or in-service required for teaching at the relevant level in a given country"

// save the product
save UNdata_Export_SDG_merged, replace
// then...

// merge it to the MDGs to make one big Development Goal Dataset. 
use UNdata_Export_MDG_merged, replace
merge 1:1 countryorarea year using UNdata_Export_SDG_merged
sort countryorarea year // ah much better. 
drop _merge

// we now have a dataset that contains data on the education related millennium-
// Development Goals and Sustainable Development Goals and tracks from 1990 to 
// 2016 for 228 nations (and a few sub-national regions that I didn't care 
// to excise. 


save UNdata_MDG_SDG, replace





* Now to do some one-to-many-merges, starting with the IHDI. 
import delimited "Inequality-adjusted Human Development Index.csv", clear
rename ïcountry countryorarea // <-- Check that out. 
rename humandevelopmentindexhdi HDI
rename inequalityadjustedhdiihdi IA_HDI
rename inequalityadjustedlifeexpectancy IA_life_exp
rename inequalityadjustededucationindex IA_Ed_index
rename inequalityadjustedincomeindex IA_inc_index
rename ginicoefficient gini_coeff

// again, country names are often ... inconsistent 
replace countryorarea = "Bolivia" if countryorarea == "Bolivia (Plurinational State of)"
replace countryorarea = "Cape Verde" if countryorarea == "Cabo Verde"
replace countryorarea = "China, Hong Kong Special Administrative Region" if countryorarea =="Hong Kong, China (SAR)"
replace countryorarea = "Democratic Republic of the Congo" if countryorarea == "Congo (Democratic Republic of the)"
replace countryorarea = "Korea, Democratic People's Republic of" if countryorarea == "Korea (Democratic People's Rep. of)"
replace countryorarea = "Korea, Republic of" if countryorarea == "Korea (Republic of)"
replace countryorarea = "Libyan Arab Jamahiriya" if countryorarea == "Libya"
replace countryorarea = "Micronesia, Federated States of" if countryorarea == "Micronesia (Federated States of)" 
replace countryorarea = "Republic of Moldova" if countryorarea == "Moldova (Republic of)" 
replace countryorarea = "State of Palestine" if countryorarea == "Palestine, State of"
replace countryorarea = "United Republic of Tanzania" if countryorarea == "Tanzania (United Republic of)" 
replace countryorarea = "Venezuela"	if countryorarea ==	"Venezuela (Bolivarian Republic of)" 
capture replace countryorarea = "Republic of Moldova" if countryorarea == "Moldova"

// save the product
save IA_HDI, replace
// then add it to what we have so far with many-to-one
use UNdata_MDG_SDG, clear
merge m:1 countryorarea using IA_HDI
drop _merge 
save UN_MDG_SDG_IA_HDI, replace



* FINALLY let's bring in HOFSTEDE
cd "${directory}\Data Files\Hofstede\"
import delimited "hofstede.csv", clear
drop if isregion == 1 // (we want countries, not supranational regions)
drop isregion ctr
save hofstede, replace
use hofstede, clear
// So the Hofstede dataset is now a .dta and ready to go. 

// replace some 'incorrect' national names...
rename country countryorarea
replace countryorarea = "Bosnia and Herzegovina" if countryorarea == "Bosnia"
replace countryorarea = "Czech Republic" if countryorarea == "Czech Rep" 
replace countryorarea = "Dominican Republic" if countryorarea == "Dominican Rep" 
replace countryorarea = "United Kingdom" if countryorarea == "Great Britain"
replace countryorarea = "China, Hong Kong Special Administrative Region" if countryorarea == "Hong Kong" 
replace countryorarea = "Iran (Islamic Republic of)" if countryorarea == "Iran"
replace countryorarea = "Korea, Republic of" if countryorarea == "Korea South"
replace countryorarea = "The former Yugoslav Republic of Macedonia" if countryorarea == "Macedonia Rep"
replace countryorarea = "Russian Federation" if countryorarea == "Russia"
replace countryorarea = "Slovakia" if countryorarea == "Slovak Rep" 
replace countryorarea = "United Republic of Tanzania" if countryorarea == "Tanzania" 
replace countryorarea = "United States" if countryorarea ==	"U.S.A." 
replace countryorarea = "Viet Nam" if countryorarea ==	"Vietnam" 
capture replace countryorarea = "Republic of Moldova" if countryorarea == "Moldova"

// label our variables. 
label var pdi 		"Power distance index" 
label var idv 		"Individualism vs. collectivism"
label var mas 		"Masculinity vs. femininity"
label var uai 		"Uncertainty avoidance index"
label var ltowvs 	"Long-term orientation vs. short-term orientation"
label var ivr  		"Indulgence vs. restraint"

// save a clean Hofstede set. 
save hofstede_clean, replace


cd "${drive}\Data Files\UN Data Main\"
use UN_MDG_SDG_IA_HDI, clear // now pull the bigger data set

cd "${directory}\Data Files\Hofstede\"
merge m:1 countryorarea using hofstede_clean // and merge
drop _merge

sort countryorarea year
order countryorarea year
capture drop if countryorarea == "" //sometimes a blank observation appears? Not sure why


cd "${drive}Data Files\"
save UN_DG_IHDI_Hofstede, replace
// this is the final data set, hooray!


///////////////////////////////////////////////////////////////////////////////
//                          Merges and Cleaning Finished                     //
///////////////////////////////////////////////////////////////////////////////

cd "${drive}do_files\"
myprog


* For more information:
// browse
// describe
// codebook
