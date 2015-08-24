program calcMeasurements
	version 14
	clear
	set more off
	rotateGroupData
	use "../Data/GM_groupData_rotated.dta"
	sort subjNum condition posture landmark
	reshape wide calX calY, i(subjNum posture landmark) j(condition)
	g proxShift0 = 	
	save "../Data/GM_groupMeasures", replace
	set more on
end
