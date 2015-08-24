program plotRotatedGroupMaps
	version 14	
	set more off
	setActualUlnaToZero
	rotateGroupData
	use "../Data/GM_groupData_rotated.dta"
	collapse (mean) calX=calX (sd) calXSD=calX (mean) calY=calY (sd) calYSD=calY (count) n=subjNum, by(condition posture landmark) 
	g highCalXCI = calX + invttail(n-1,0.025)*(calXSD / sqrt(n))
	g lowCalXCI = calX - invttail(n-1,0.025)*(calXSD / sqrt(n))
	g highCalYCI = calY + invttail(n-1,0.025)*(calYSD / sqrt(n))
	g lowCalYCI = calY - invttail(n-1,0.025)*(calYSD / sqrt(n))
	capture graph drop maps
	twoway (scatter calY calX if condition==2, mcolor(black)) (scatter calY calX if condition==0, mcolor(blue)) (rcap highCalXCI lowCalXCI calY if condition==0, lcolor(blue) horizontal) (rcap highCalYCI lowCalYCI calX if condition==0, lcolor(blue)) (scatter calY calX if condition==1, mcolor(red)) (rcap highCalXCI lowCalXCI calY if condition==1, lcolor(red) horizontal) (rcap highCalYCI lowCalYCI calX if condition==1, lcolor(red)), by(posture, note("") compact) xlabel(-150(100)200) ylabel(-100(100)250) graphregion(color(none)) bgcolor(white) xsize(8.27) ysize(11.7) ytitle("calibratedY") legend(order(1 "Actual" 2 "Pointing" 5 "Grid") rows(1)) aspect(1) name(maps)
	graph export "../Data/Figures/group_rotatedMaps.pdf", replace name(maps)
	
	forvalues i = 0/3{
		local postureStr : label Postures `i'
		capture graph drop "maps`i'"
		twoway (scatter calY calX if (condition==2 & posture==`i'), mcolor(black)) (scatter calY calX if (condition==0 & posture==`i'), mcolor(blue)) (rcap highCalXCI lowCalXCI calY if (condition==0 & posture==`i'), lcolor(blue) horizontal) (rcap highCalYCI lowCalYCI calX if (condition==0 & posture==`i'), lcolor(blue)) (scatter calY calX if (condition==1 & posture==`i'), mcolor(red)) (rcap highCalXCI lowCalXCI calY if (condition==1 & posture==`i'), lcolor(red) horizontal) (rcap highCalYCI lowCalYCI calX if (condition==1 & posture==`i'), lcolor(red)), graphregion(color(none)) xlabel(-150(50)200) ylabel(-100(50)250) bgcolor(white) title("Posture: `postureStr'") legend(order(1 "Actual" 2 "Pointing" 5 "Grid") rows(1)) aspect(1) name(maps`i')
		graph export "../Data/Figures/group_`postureStr'_rotatedMap.pdf", replace name(maps`i')
	}
	set more on
	clear
end
