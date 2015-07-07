program makeGroupData
	args first last
	set more off
	groupSubjects `first' `last'
	use "../Data/GM_group_actualPosition.dta"
	drop trial
	g condition=2
	append using "../Data/GM_group_perceivedPosition_means.dta"
	capture label define Conditions 0 "pointing" 1 "gridReference" 2 "actual"
	label values condition Conditions
	order subjNum condition posture landmark, first
	sort subjNum condition posture landmark
	save "../Data/GM_groupData.dta",replace
	rm "../Data/GM_group_actualPosition.dta"
	rm "../Data/GM_group_perceivedPosition_means.dta"
	clear
	set more on
end


program groupSubjects
	args first last
	local second = `first' +1
	use "../Data/GM_S`first'_perceivedPosition_means.dta"
	forvalues i = `second'/`last' {
		append using "../Data/GM_S`i'_perceivedPosition_means.dta"
	}
	save "../Data/GM_group_perceivedPosition_means.dta",replace
	clear
	
	use "../Data/GM_S`first'_actualPosition.dta"
	forvalues i = `second'/`last' {
		append using "../Data/GM_S`i'_actualPosition.dta"
	}
	save "../Data/GM_group_actualPosition.dta",replace
	clear
end


