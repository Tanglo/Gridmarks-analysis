program rotateGroupData
	version 14
	clear
	//reflect right hand
	use "../Data/GM_groupData_shifted.dta" if(posture==3) //rightStraight
	replace calX = calX * -1
	save "../Data/temp_rightStraight", replace
	use "../Data/GM_groupData_shifted.dta" if(posture==2)	//right90
	replace calX = calX * -1
	save "../Data/temp_right90", replace
	
	use "../Data/GM_groupData_shifted.dta" if(posture==0)	//left90
	append using "../Data/temp_right90"
	//covert to polar
	g mag = sqrt(calX^2 + calY^2)
	g rawAngle = atan(calY/calX)
	g angle = rawAngle
	replace angle = _pi + rawAngle if(calX<0 & rawAngle<0)
	replace angle = -_pi + rawAngle if(calX<0 & rawAngle>=0)
	//rotate by 90
	replace angle = angle + _pi/2
	//convert to cartesian
	replace calX = mag * cos(angle)
	replace calY = mag * sin(angle)
	replace calX = 0 if(condition==2 & landmark==10)
	replace calY = 0 if(condition==2 & landmark==10)
	save "../Data/temp_90",replace
	
	use "../Data/GM_groupData_shifted.dta" if(posture==1) //leftStraight
	append using "../Data/temp_rightStraight"
	append using "../Data/temp_90"
	drop mag rawAngle angle calXSD calYSD n
	sort subjNum condition posture landmark
	save "../Data/GM_groupData_rotated", replace
	rm "../Data/temp_rightStraight.dta"
	rm "../Data/temp_90.dta"
	rm "../Data/temp_right90.dta"
end
