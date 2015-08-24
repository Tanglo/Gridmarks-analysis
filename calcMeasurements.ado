program calcMeasurements
	version 14
	clear
	rotateGroupData
	use "../Data/GM_groupData_rotated.dta"
	sort subjNum condition posture landmark
	reshape wide calX calY calXSD calYSD n, i(subjNum posture landmark) j(condition)
	
	save "../Data/GM_groupMeasures", replace
end
