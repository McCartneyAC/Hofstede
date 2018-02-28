// graphs go here


// first pull in the dataset
cd "${drive}datavis"


capture ssc install aaplot

// first graph the main Hofstede indices
do graph1_boxplot
// then graph girls' primary ed and Hum-Dev Index
do graph2_hdi_scatter
// face-graph girls education gains in select African nations 
do graph3_facet_girls_africa
// Scatter PDI and IA-income
do graph4_scatter_pdi
// scatter participation in education (girls and women) and masculinity
do graph5_scatter_participation_mas
// scatter computer use in classrooms and long-term-orientation
do graph6_computers

graph drop _all


cd "${drive}do_files\"














/////////////////////////////////////////////////////////////////////////////////
/* THIS IS LEGACY CODE
* but what's that weird outlier country?
gen mylabel = countryorarea if (HDI >0.8 &  pr_en_girls <60)
#delimit;	
scatter pr_en_girls HDI,
mlabel(mylabel)	
;	

#delimit;
graph box pdi-ivr,
	title("Distributions of Hofstede's Cultural Dimensions")
	caption("Scale is 0-100, though Hofstede's index occasionally allows for values above 100")
	legend(size(*0.5))
;
//still think the joyplot is cooler :(
*/

/*
twoway (scatter IA_inc_index pdi) (lfit IA_inc_index pdi),
	title("Inequality-Adjusted Income vs. Power-Distance")
	scheme(economist)
	legend(size(*0.5))
;*/

/// but can we do better?

// let's check some girls' metrics against MAS

/* even if this were legible it wouldn't tell us anything
local metric "pr_en_girls pr_comp_girls adult_lit_women pre_prim_participFemale gend_parity_tch_train_pre_prim gend_parity_tch_train_prim gend_parity_tch_train_up_sec"
foreach q in `metric' {
		aaplot `q' mas, name(`q'_a, replace) legend(off) title("`q'")
		 }
#delimit;
graph combine 
pr_en_girls_a pr_comp_girls_a adult_lit_women_a
pre_prim_participFemale_a gend_parity_tch_train_pre_prim_a
gend_parity_tch_train_prim_a gend_parity_tch_train_up_sec_a,
	col(4) 
	title("Hofstede's Masculinity as a predictor of Girls' Education Metrics")
	scheme(s1mono)
;

#delimit; 
twoway (scatter pre_prim_participFemale mas) (lfit gend_parity_tch_train_prim mas),
	title("Gender Parity of Primary School Teachers' Training and (Masc v. Fem)")
	scheme(sj)
	yscale(range(2))  
	legend(size(*0.5))
;*/
