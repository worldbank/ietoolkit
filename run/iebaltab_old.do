
	* Set versson and seed
	ieboilstart , version(13.1)
	`r(version)'
	
	global 	ietoolkit "C:\Users\wb462869\GitHub\ietoolkit"

	* Add the path to your local clone of the [ietoolkit] repo
	
	sysuse auto
	
	set seed 34543673
	
	gen tmt = (runiform()<.5)
	
	recode tmt (0=6) (1=2)
	
	replace tmt = 10231 if (runiform()<.2)
	replace tmt = 4 	if (runiform()<.2)
	tab		tmt
	
	gen this_cluster = tmt
	sum this_cluster, d
	gen tmt_cl = (this_cluster <= r(p50))
	
	mat rmat = [1,2\3,4]
	
	iebaltab price weight mpg, ///
	grpvar(tmt_cl)   total      ///
	replace savetex("${ietoolkit}/run/output/iebaltab/iebt_old1") /// 
	browse   ftest onerow texvspace(2cm) texdocument
	
	