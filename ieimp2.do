		version 12.0
		set more off
		pause on 

		cd "C:\Users\wb503680\Box Sync\DIME WOrk\GitFolder\ietoolkit\test"

		do "C:\Users\wb503680\Box Sync\DIME WOrk\GitFolder\ietoolkit\ieimpgraph2.do"

		sysuse auto, replace
		gen weight2 = 1 if weight >= 3019.5
		replace weight2 = 0 if weight2 == .

		reg price  weight2
		ieimpgraph weight2, title(Treatment effect on overall price)

		
		tab rep78, gen(n1_)
		drop n1_1

		regress price n1_*
		ieimpgraph n1_*



