program calcMeasurements
	version 14
	clear
	set more off
	rotateGroupData
	use "../Data/GM_groupData_rotated.dta"
	sort subjNum condition posture landmark
	reshape wide calX calY, i(subjNum posture landmark) j(condition)
	g proxShift0 = calY0 - calY2	//pointing
	g proxShift1 = calY1 - calY2	//gridReference
	g medShift0 = calX2 - calX0		//pointing
	g medShift1 = calX2 - calX1		//gridReference
	drop calX0 calX1 calX2 calY0 calY1 calY2
	g proxShift2=.
	g medShift2=.
	reshape long proxShift medShift, i(subjNum posture landmark) j(condition)
	reshape wide proxShift medShift, i(subjNum posture condition) j(landmark)
	rename proxShift0 proxShiftTip0
	rename medShift0 medShiftTip0
	rename proxShift1 proxShiftMCP0
	rename medShift1 medShiftMCP0
	rename proxShift2 proxShiftTip1
	rename medShift2 medShiftTip1
	rename proxShift3 proxShiftMCP1
	rename medShift3 medShiftMCP1
	rename proxShift4 proxShiftTip2
	rename medShift4 medShiftTip2
	rename proxShift5 proxShiftMCP2
	rename medShift5 medShiftMCP2
	rename proxShift6 proxShiftTip3
	rename medShift6 medShiftTip3
	rename proxShift7 proxShiftMCP3
	rename medShift7 medShiftMCP3
	rename proxShift8 proxShiftTip4
	rename medShift8 medShiftTip4
	rename proxShift9 proxShiftMCP4
	rename medShift9 medShiftMCP4
	drop proxShift10 medShift10
	reshape long proxShiftTip proxShiftMCP medShiftTip medShiftMCP, i(subjNum posture condition) j(digit)
	label define Digits 0 "Thumb" 1 "Index" 2 "Middle" 3 "Ring" 4 "Little"
	label values digit Digits
	sort subjNum condition posture digit
	save "../Data/temp_shifts",replace
	
	use "../Data/GM_groupData_rotated.dta"
	sort subjNum condition posture landmark
	reshape wide calX calY, i(subjNum posture condition) j(landmark)
	rename calX0 tipX0
	rename calY0 tipY0
	rename calX1 MCPX0
	rename calY1 MCPY0
	rename calX2 tipX1
	rename calY2 tipY1
	rename calX3 MCPX1
	rename calY3 MCPY1
	rename calX4 tipX2
	rename calY4 tipY2
	rename calX5 MCPX2
	rename calY5 MCPY2
	rename calX6 tipX3
	rename calY6 tipY3
	rename calX7 MCPX3
	rename calY7 MCPY3
	rename calX8 tipX4
	rename calY8 tipY4
	rename calX9 MCPX4
	rename calY9 MCPY4
	drop calX10 calY10
	reshape long tipX tipY MCPX MCPY, i(subjNum posture condition) j(digit)
	label define Digits 0 "Thumb" 1 "Index" 2 "Middle" 3 "Ring" 4 "Little"
	label values digit Digits
	g length = sqrt((tipY - MCPY)^2 + (tipX - MCPX)^2)
	g spacing = . 
	sort subjNum condition posture digit
	mata: calcKnuckleDistances()
	g spacingError = spacing
	g lengthError = length
	mata: calcSpacingErrors()
	drop tipX tipY MCPX MCPY spacing length
	merge 1:1 subjNum condition posture digit using "../Data/temp_shifts"
	drop _merge
	drop if condition==2
	order subjNum condition posture digit, first
	order length spacing, last
	save "../Data/GM_groupMeasures", replace
	rm "../Data/temp_shifts.dta"
	set more on
end

mata: 
void calcKnuckleDistances(){
	rawData = st_data(.,"MCPX MCPY")
	st_view(spacing,.,"spacing")
	count = rows(rawData)
	for(i=1; i<=count; i++){
		if(mod(i,5) == 0){
			spacing[i] = sqrt((rawData[i-4,1] - rawData[i,1])^2 + (rawData[i-4,2] - rawData[i,2])^2)
		}
		else {
			spacing[i] = sqrt((rawData[i,1] - rawData[i+1,1])^2 + (rawData[i,2] - rawData[i+1,2])^2)
		}
	}
}

void calcSpacingErrors(){
	rawData = st_data(.,"condition spacing length")
	st_view(errors,.,"spacingError lengthError")
	count = rows(rawData) -20
	for(i=1; i<=count; i++){
		if(rawData[i,1] == 0){
			errors[i,1] = rawData[i,2] - rawData[i+40,2]
			errors[i,2] = rawData[i,3] - rawData[i+40,3]
		}
		else if(rawData[i,1] == 1) {
			errors[i,1] = rawData[i,2] - rawData[i+20,2]
			errors[i,2] = rawData[i,3] - rawData[i+20,3]
		}
		else {
			errors[i,1] = .
			errors[i,2] = .
		}
	}
}
end
