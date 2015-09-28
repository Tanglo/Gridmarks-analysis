program setActualUlnaToZero
	set more off
	use "../Data/GM_groupData.dta"
	g shiftedCalX=.
	g shiftedCalY=.
	sort subjNum condition posture landmark
	mata: subtractActualUlna()
	drop rawX rawY calX calY rawXSD rawYSD
	rename shiftedCalX calX
	rename shiftedCalY calY
	order calXSD calYSD n,last
	save "../Data/GM_groupData_shifted.dta", replace
	set more on
	clear
end

version 14
mata:
void subtractActualUlna() {
	rawData = st_data(.,"subjNum calX calY")
	st_view(shiftedData,.,"shiftedCalX shiftedCalY")
	count = rows(rawData)
//	numSubj = rawData[count-1,1]
	numSubj = count/132
	for(i=1; i<=numSubj ;i++){
		for(l=0; l<3; l++){
			for(j=0; j<4; j++){
				for(k=0; k<11; k++){
					shiftedData[(i-1)*132 +l*44 + j*11 + k +1,1] = rawData[(i-1)*132 +l*44 + j*11 + k +1,2] - rawData[(i-1)*132 +88 + j*11 + 10 +1,2]
					shiftedData[(i-1)*132 +l*44 + j*11 + k +1,2] = rawData[(i-1)*132 +l*44 + j*11 + k +1,3] - rawData[(i-1)*132 +88 + j*11 + 10 +1,3]
				}
			}
		}
	}
}
end
