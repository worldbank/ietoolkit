	
	*Set standardized settings
	ieboilstart, v(11.1)
	`r(version)'
	
	*Create filepaths
	global ietoolkit "C:\Users\wb503680\Box Sync\DIME WOrk\GitFolder\ietoolkit"
	*global ietoolkit "C:\Users\wb462869\Box Sync\Stata\Stata work\Commands\ietoolkit"
	global testOutput "$ietoolkit/test/ieimpgraphOutput"
	
	*Set cd folder to catch and cd leakage
	cd "$ietoolkit\test\cdjunk"
	
	*Load the command
	do "$ietoolkit\iegraph.do"

	**********************
	*Graph 1 - single treatment
	
	*open an example data set and create a mock dummy
	sysuse auto, clear
	gen Treatment = (weight >= 3019.5)
	
	*Run the impact regression
	reg price  Treatment
	*Create the graph
	iegraph Treatment, noconfbars title("Treatment effect on price") save("$testOutput/Graph1.gph")
	iegraph Treatment, title("Treatment effect on price") save("$testOutput/Graph1.gph")
		
	**********************
	*Graph 2 - multiple treatment	
	
	*open an example data set and create mutually exclusive mock dummies
	sysuse auto, clear
	tab rep78, gen(d_)
	
	*Run the impact regression
	reg price  d_2 d_3 d_4 d_5 weight length gear_ratio
	*Create the graph
	iegraph d_2 d_3,  title("Treatment effect on price") save("$testOutput/Graph2.gph")
	iegraph d_2 d_3 d_4,  title("Treatment effect on price") save("$testOutput/Graph3.gph")
	iegraph d_2 d_3 d_4 d_5,  title("Treatment effect on price") save("$testOutput/Graph4.gph")
	iegraph d_2 d_3 d_4 d_5,  noconfbars title("Treatment effect on price") save("$testOutput/Graph2.gph")



