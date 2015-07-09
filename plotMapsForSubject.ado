program plotMapsForSubject
	args subjNum
	set more off
	use "../Data/GM_groupData.dta" if subjNum==`subjNum'
	capture graph drop maps
	g highCalXCI = calX + invttail(n-1,0.025)*(calXSD / sqrt(n))
	g lowCalXCI = calX - invttail(n-1,0.025)*(calXSD / sqrt(n))
	g highCalYCI = calY + invttail(n-1,0.025)*(calYSD / sqrt(n))
	g lowCalYCI = calY - invttail(n-1,0.025)*(calYSD / sqrt(n))
	twoway (scatter calY calX if condition==2, mcolor(black)) (scatter calY calX if condition==0, mcolor(blue)) (rcap highCalXCI lowCalXCI calY if condition==0, lcolor(blue) horizontal) (rcap highCalYCI lowCalYCI calX if condition==0, lcolor(blue)) (scatter calY calX if condition==1, mcolor(red)) (rcap highCalXCI lowCalXCI calY if condition==1, lcolor(red) horizontal) (rcap highCalYCI lowCalYCI calX if condition==1, lcolor(red)), by(posture, note("") compact title("Subject `subjNum'")) graphregion(color(none)) bgcolor(white) xsize(8.27) ysize(11.7) ytitle("calibratedY") legend(order(1 "Actual" 2 "Pointing" 5 "Grid") rows(1)) aspect(1) name(maps)
	graph export "../Data/Figures/S`subjNum'_maps.pdf", replace name(maps)
	
	forvalues i = 0/3{
		local postureStr : label Postures `i'
		capture graph drop "maps`i'"
		twoway (scatter calY calX if (condition==2 & posture==`i'), mcolor(black)) (scatter calY calX if (condition==0 & posture==`i'), mcolor(blue)) (rcap highCalXCI lowCalXCI calY if (condition==0 & posture==`i'), lcolor(blue) horizontal) (rcap highCalYCI lowCalYCI calX if (condition==0 & posture==`i'), lcolor(blue)) (scatter calY calX if (condition==1 & posture==`i'), mcolor(red)) (rcap highCalXCI lowCalXCI calY if (condition==1 & posture==`i'), lcolor(red) horizontal) (rcap highCalYCI lowCalYCI calX if (condition==1 & posture==`i'), lcolor(red)), graphregion(color(none)) bgcolor(white) title("Subject `subjNum': `postureStr'") legend(order(1 "Actual" 2 "Pointing" 5 "Grid") rows(1)) aspect(1) name(maps`i')
		graph export "../Data/Figures/S`subjNum'_`postureStr'_map.pdf", replace name(maps`i')
	}
	set more on
	clear
end
