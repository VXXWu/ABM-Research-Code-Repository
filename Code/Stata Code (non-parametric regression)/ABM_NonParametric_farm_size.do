capture log close
clear all

* set to directory on hard drive for outputting data
cd "C:\Users\vince\Downloads\Cleaned-ABM-Research\Sensitivity Analysis\Clean Data\Scaled"


global dataset vietnam cambodia
global filename FarmSize_Scaled
global dep hs_patches net_prod nch_efficiency income_dev nch_patches income nch_strategy

global indep subsidy farmsize sub_size

* Non-parametric regression
cap eststo clear
foreach z in $dep {
	local short_z = substr("`z'", 1, 10)
	foreach d in $dataset {
		import delimited farm_size_`d'_scaled.csv, clear
		
		eststo clear
		gen sub_size = subsidy* farmsize
		
		eststo `short_z'_`d': npregress kernel `z' $indep, vce(bootstrap) 

		estout * using `short_z'_`d'.xls, cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(cmd depvar r2 r2_p ll bic N N_lc N_rc converged) title(`z' `d') legend varlabels(_cons Constant) label wrap replace
		
	}
}

macro drop dataset dep 

