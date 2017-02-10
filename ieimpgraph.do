
	
cap	program drop	ieimpgraph
	program define 	ieimpgraph
	
	syntax anything
	
	mat list e(b)
	
	foreach var of local varlist {
	
	
		local beta = _b[`var']
		
		di "`beta'"
	
	}
	
end 

cap	program drop	tobeused
	program define 	tobeused
		
	capture file close `textfile'_`date'
	file open  `textfile'_`date' using `textfile'_`date'.txt, text write replace
	file write `textfile'_`date' ///
		"Variable" 	_tab "Tmt-Status"	_tab "mean" _tab "coeff" _tab "conf_int_min" _tab "conf_int_max" _tab "obs" _tab "star" _n 	
	file close `textfile'_`date'
	
	local REG_RESULTS ""
	foreach depvar of local depvars {
		
		rename lag2_`depvar' lagvar
		
		local regname `depvar'
			eststo `regname' : areg `depvar' tmt_reg tmt_sdp tmt_inc lagvar NoCropBoroBL NoCropBL incorrect_no_bl NoPlotDataBL NoHarvValueDataBL if t == 2, a(d_code) cl(v_code)
		local  REG_RESULTS "`REG_RESULTS' `regname'"
		
		
		
		foreach tmt_arm in reg sdp inc {
			scalar coeff_`tmt_arm' 		= _b[tmt_`tmt_arm']
			scalar coeff_se_`tmt_arm' 	= _se[tmt_`tmt_arm']
			
			sum `depvar' if e(sample) & tmt_`tmt_arm' == 1
			scalar obs_`tmt_arm'	= r(N)
		}
		
		sum `depvar' if e(sample) & tmt_reg == 0 & tmt_sdp == 0 & tmt_inc == 0
		scalar ctl_N		= r(N)
		scalar ctl_mean	  	= r(mean)
		scalar ctl_mean_sd 	= r(sd)					
		
		estadd scalar ctl_mean_table	=r(mean)
		estadd scalar ctl_N_table		=r(N)
		estadd scalar ctl_mean_sd_table	=r(sd)
		
		sum lagvar if e(sample) & !(NoCropBoroBL == 1 | NoCropBL == 1 | incorrect_no_bl == 1 | NoPlotDataBL == 1 | NoHarvValueDataBL == 1)
		scalar BL_mean 		= r(mean)
		scalar BL_N 	= r(N)
		
		estadd scalar BL_mean_table	=r(mean)
		estadd scalar BL_N_table	=r(N)
		
		rename lagvar lag2_`depvar' 	
		
		foreach tmt_arm in reg sdp inc {
			scalar  conf_int_min_`tmt_arm'   =coeff_`tmt_arm'-(1.96*coeff_se_`tmt_arm') + ctl_mean
			scalar  conf_int_max_`tmt_arm'   =coeff_`tmt_arm'+(1.96*coeff_se_`tmt_arm') + ctl_mean
			
			test    tmt_`tmt_arm'
			
			scalar  pvalue =r(p)
			local star_`tmt_arm'
			if pvalue < 0.10 {
				local star_`tmt_arm' "*"
			}
			if pvalue < 0.05 {
				local star_`tmt_arm' "**"
			}
			if pvalue < 0.01 {
				local star_`tmt_arm' "***"
			}
			
			scalar tmt_mean_`tmt_arm' = ctl_mean + coeff_`tmt_arm'
		}

		file open  `textfile'_`date' using `textfile'_`date'.txt, text write append
		file write `textfile'_`date' ///
			"`regname'" _tab "Control"  _tab %9.3f (ctl_mean)      _tab  		 			_tab 		 			  	  _tab 			 				_tab %9.3f (ctl_N) 	   _tab			  	  _n ///
			"`regname'" _tab "reg"		_tab %9.3f (tmt_mean_reg)  _tab  %9.3f (coeff_reg)  _tab %9.3f (conf_int_min_reg) _tab %9.3f (conf_int_max_reg) _tab %9.3f (obs_reg)   _tab "`star_reg'"  _n ///
			"`regname'" _tab "sdp"		_tab %9.3f (tmt_mean_sdp)  _tab  %9.3f (coeff_sdp)  _tab %9.3f (conf_int_min_sdp) _tab %9.3f (conf_int_max_sdp) _tab %9.3f (obs_sdp)   _tab "`star_sdp'"  _n ///
			"`regname'" _tab "inc"		_tab %9.3f (tmt_mean_inc)  _tab  %9.3f (coeff_inc)  _tab %9.3f (conf_int_min_inc) _tab %9.3f (conf_int_max_inc) _tab %9.3f (obs_inc)   _tab "`star_inc'"  _n
		file close `textfile'_`date'
		
		
	}
	esttab `REG_RESULTS' using "$csv/outcomeVar_AllTreat_`date'.csv",      ///
		title(`tabeleFileName') stats(BL_mean_table BL_N_table ctl_mean_table ctl_N_table ctl_mean_sd_table N) mtitles nonumbers plain br  star(* 0.10 ** 0.05 *** 0.01) ///
		b(a3)  se(%9.2f) alignment(l) replace 

	
	/***************************************
	
		Produce the graphs
	
	***************************************/
	
	insheet using `textfile'_`date'.txt, clear tab
	
	pause on
	
	cd "$graphs/gRaw"
	
	gen tmt = .
	replace tmt = 1 if tmtstatus == "Control"
	replace tmt = 2 if tmtstatus == "reg"
	replace tmt = 3 if tmtstatus == "sdp"
	replace tmt = 4 if tmtstatus == "inc"
	
	gen placement = tmt
	
	*gen 	placement = tmt if demo_code == 1
	*replace placement = tmt + 5 if demo_code == 2
	
	foreach percentVar in mean coeff conf_int_min conf_int_max {
	
		replace `percentVar' =  `percentVar' * 100 if variable == "c1_commerce"
	}

	
	gen 	labelString 		= ""
	gen 	labelCategory		= .
	local 	continVars_Large  	c1_harv_value c1_net_yield c1_gross_yield c1_total_earnings c2_inp_total_spending c1_IAAP_harv_value c1_net_yield_nonLabor c1_net_yield_allLabor
	local 	continVars_Small  	c1_total_plotsize
	local 	percentage_Vars   	c1_commerce
	
	foreach L_var of local continVars_Large {
		
		replace labelCategory = 1 if variable == "`L_var'"
	}
	foreach S_var of local continVars_Small {
		
		replace labelCategory = 2 if variable == "`S_var'"
	}
	foreach P_var of local percentage_Vars {
		
		replace labelCategory = 3 if variable == "`P_var'"
	}
	
	tempvar labelString_temp decimal_postion
	
	tostring mean,	gen(`labelString_temp') force
	gen 	`decimal_postion' = strpos(`labelString_temp',".")
	
	*For continious values without decimal point (means include all in practice)
	replace `decimal_postion' = 10 if  `decimal_postion' == 0
	
	replace labelString = substr(`labelString_temp',1,(`decimal_postion'-1)) 		if labelCategory == 1 
	replace labelString = substr(`labelString_temp',1,4) 							if labelCategory == 2 
	replace labelString = substr(`labelString_temp',1,`decimal_postion'+1) + "%"	if labelCategory == 3
	
	
	tempfile restart_loop
	save 	`restart_loop', replace
	
	levelsof variable
	foreach level in `r(levels)' {
		use `restart_loop', clear
		di "`level'"
		keep if variable == "`level'"
		
		foreach tmt in reg sdp inc {
			preserve
				keep if tmtstatus == "`tmt'" 
				local obs_`tmt'  = obs[1]
				local star_`tmt' = star[1]
			restore
		}
		
		preserve
			keep if tmtstatus == "Control" 
			local obs_ctrl  = obs[1]
		restore
		

		
		
		
		local title "ERROR"
		
		if "`level'" == "c1_IAAP_harv_value"	local title "Harvest value IAPP crops, Taka"
		if "`level'" == "c1_commerce"			local title "Commercialization, earnings/production %"
		if "`level'" == "c1_gross_yield"		local title "Gross yield, Taka/Ha"
		if "`level'" == "c1_gross_yield_comp"	local title "Gross yield, plots with completed harvest, Taka/Ha"
		if "`level'" == "c1_gross_yield_harv" 	local title "Gross yield, actaully harvested all plots, Taka/Ha"
		if "`level'" == "c1_harv_value"			local title "Total value all harvest, Taka"
		if "`level'" == "c1_harv_value_int"		local title "Total value harvest intercropped, Taka"
		if "`level'" == "c1_harv_value_mono" 	local title "Total value harvest monocropped, Taka"
		if "`level'" == "c1_net_yield"			local title "Net yield, Taka/Ha"
		if "`level'" == "c1_total_earnings"		local title "Total earnings all crop sales, Taka"
		if "`level'" == "c1_total_plotsize"		local title "Total plotsize, Ha"
		if "`level'" == "c2_inp_total_spending"	local title "Total input spending, Taka"

		
		local noyscale ylabel(#3) ytitle("")
		*if "`title'" != "Boro" & "`title'" != "Lentil" & "`title'" != "Mustard" local noyscale ysc(off) 
			
		if "`level'" == "c2_inp_total_spending"	local noyscale ylabel(#2) ytitle("")	 
		if "`level'" == "c1_gross_yield"		local noyscale ylabel(#2) ytitle("")	 
			
		local graphname	gph_`textfile'_`level'
		sort placement
		graph twoway (bar mean placement if tmt == 1, color("17 33 44")	 ) ///
			(bar mean placement if tmt == 2 , color("228 202 194") 		) ///
			(bar mean placement if tmt == 3 , color("215 107 96" ) 		 ) ///
			(bar mean placement if tmt == 4 , color("156 36  24" ) 		) ///
			(rcap conf_int_max conf_int_min placement, lc(gs) 						) ///
			(scatter  mean placement, msym(none) mlab(labelString) mlabs(medium) mlabpos(10) mlabcolor(black))	, ///
			legend(order(1 2 3 4) lab(1 "Control") lab(2 "Regular Treatment") lab(3 "Shared Demo Treatment") lab(4 "Incentives Treatment")) ///
			 plotregion(margin(b+3 t+3)) ///
			xlabel(	1 `" (N = `obs_ctrl') "' ///
					2 `" "(N = `obs_reg')" " `star_reg' " "' ///
					3 `" "(N = `obs_sdp')" " `star_sdp' " "' ///
					4 `" "(N = `obs_inc')" " `star_inc' " "', noticks labsize(medsmall)) ///
			graphregion( lcolor("182 222 255") fcolor("182 222 255")) ///
			plotregion(fcolor("247 247 247") ) ///
		   	xtitle("") ``level'_lab' `noyscale'  ///
			title("`title'") saving(`graphname'.gph, replace)
			graph export `graphname'.png, replace
		*pause
	}
	
	*Main outcomes
	cd "$graphs/gRaw"
	grc1leg gph_ag_outcome_log_c1_harv_value.gph 	///
			gph_ag_outcome_log_c1_net_yield.gph 	///
			gph_ag_outcome_log_c1_gross_yield.gph 	///
			gph_ag_outcome_log_c1_total_earnings.gph 	///
		,saving(gph_ag_outcome_log_MAIN.png, replace) /*ycom*/ ///
		cols(2) imargin(small) graphregion( lcolor("182 222 255") fcolor("182 222 255"))
	graph use gph_ag_outcome_log_MAIN.png
	graph display, xsize(8.5)
	
	cd "$graphs/"
	graph export gph_ag_outcome_log_MAIN.eps, preview(on) replace
	
	pause
	
	*Other ag outcomes
	cd "$graphs/gRaw"
	grc1leg gph_ag_outcome_log_c2_inp_total_spending.gph 	///
			gph_ag_outcome_log_c1_total_plotsize.gph 	///
			gph_ag_outcome_log_c1_IAAP_harv_value.gph 	///
			gph_ag_outcome_log_c1_commerce.gph 	///
		,saving(gph_ag_outcome_log_other.png, replace) /*ycom*/ ///
		cols(2) imargin(small) graphregion( lcolor("182 222 255") fcolor("182 222 255"))
	graph use gph_ag_outcome_log_other.png
	graph display, xsize(8.5)
	
		cd "$graphs/"
	graph export gph_ag_outcome_log_other.eps, preview(on) replace
	
	cap log close `logname'
end