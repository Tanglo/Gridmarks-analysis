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
		mata: st_local("currentFile",sprintf("../Data/GM_S%s_perceivedPosition_means.dta",st_local("i")))
		if fileexists("`currentFile'"){
			append using "`currentFile'"
		}
		else {
			mata: printf(`"File: "%s" does not exist\n"', st_local("currentFile"))
		}
	}
	save "../Data/GM_group_perceivedPosition_means.dta",replace
	clear
	
	use "../Data/GM_S`first'_actualPosition.dta"
	forvalues i = `second'/`last' {
		mata: st_local("currentFile",sprintf("../Data/GM_S%s_actualPosition.dta",st_local("i")))
		if fileexists("`currentFile'"){
			append using "`currentFile'"
		}
		else {
			mata: printf(`"File: "%s" does not exist\n"', st_local("currentFile"))
		}
	}
	save "../Data/GM_group_actualPosition.dta",replace
	clear
end


