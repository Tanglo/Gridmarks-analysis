program rotateGroupData
	version 14
	clear
	use "../Data/GM_groupData_shifted.dta" if(posture==3) //rightStraight
	replace calX = calX * -1
	save "../Data/temp_rightStraight", replace
	use "../Data/GM_groupData_shifted.dta" if(posture==0 | posture==2)
	//covert to polar
	g mag = sqrt(calX^2 + calY^2)
	g rawAngle = atan(calY/calX)
	g angle = rawAngle
	replace angle = _pi + rawAngle if(calX<0 & rawAngle<0)
	replace angle = -_pi + rawAngle if(calX<0 & rawAngle>=0)
	save "../Data/temp_90", replace
	use "../Data/temp_90" if(posture == 0) //left90
	//rotate by 90
	replace angle = angle + _pi/2
	save "../Data/temp_left90", replace
	use "../Data/temp_90" if(posture == 2) //temp_right90
	//rotate by -90
	replace angle = angle - _pi/2
	append using "../Data/temp_left90.dta"
	//convert to cartesian
	replace calX = mag * cos(angle)
	replace calY = mag * sin(angle)
	replace calX = 0 if(condition==2 & landmark==10)
	replace calY = 0 if(condition==2 & landmark==10)
	save "../Data/temp_90",replace
	
	use "../Data/GM_groupData_shifted.dta" if(posture==1) //leftStraight
	append using "../Data/temp_rightStraight"
	append using "../Data/temp_90"
	sort subjNum condition posture landmark
	save "../Data/GM_groupData_rotated", replace
	rm "../Data/temp_rightStraight.dta"
end
