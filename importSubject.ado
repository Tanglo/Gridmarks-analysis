program importSubject
	args subjNum
	set more off
	importRawDataFiles `subjNum'
	mergeImageAndBaseData `subjNum'
	collectPerceivedData `subjNum'
	clear
	set more on
end

program importRawDataFiles
	args subjNum
	importDataCondition "left90" 0 `subjNum'
	importDataCondition "leftStraight" 1 `subjNum'
	importDataCondition "right90" 2 `subjNum'
	importDataCondition "rightStraight" 3 `subjNum'
	importDataActual `subjNum'
	clear
end

program importDataCondition
	args condition postureCode subjNum
	importBaseCSVFile `condition' `postureCode' `subjNum'
	importImageCSVFile `condition' `subjNum'
end

program importBaseCSVFile
	args condition postureCode subjNum
	mata: st_local("filePath",sprintf("../Data/Raw/S%s/GM_S%s_%s_data.csv",st_local("subjNum"),st_local("subjNum"),st_local("condition")))
	mata: printf("File: %s\n",st_local("filePath"))
	capture confirm file `filePath'
	if _rc==0 {
		clear
		import delimited trial condition landmark xLocation yLocation  using `filePath'
		mata: st_local("outFile",sprintf("../Data/GM_S%s_%s_data",st_local("subjNum"),st_local("condition")))
		g posture=`postureCode'
		save `outFile', replace
		clear	
	}
	else {
		mata: printf("\t - does not exist.\n")
	}
end

program importImageCSVFile
	args condition subjNum
	mata: st_local("filePath",sprintf("../Data/Raw/S%s/GM_S%s_%s_imageData.csv",st_local("subjNum"),st_local("subjNum"),st_local("condition")))
	mata: printf("File: %s\n",st_local("filePath"))
	capture confirm file `filePath'
	if _rc==0 {
		clear
		import delimited trial measurement filename rawX rawY calX calY using `filePath'
		mata: st_local("outFile",sprintf("../Data/GM_S%s_%s_imageData",st_local("subjNum"),st_local("condition")))
		drop trial measurement
		save `outFile', replace
		clear	
	}
	else {
		mata: printf("\t - does not exist.\n")
	}
end

program importDataActual
	args subjNum
	mata: st_local("filePath",sprintf("../Data/Raw/S%s/GM_S%s_actualPosition_imageData.csv",st_local("subjNum"),st_local("subjNum")))
	mata: printf("File: %s\n",st_local("filePath"))
	capture confirm file `filePath'
	if _rc==0 {
		clear
		import delimited trial measurement filename rawX rawY calX calY using `filePath'
		g posture=0 if strpos(filename, "left90")
		replace posture=1 if strpos(filename, "leftStraight")
		replace posture=2 if strpos(filename, "right90")
		replace posture=3 if strpos(filename, "rightStraight")
		label define Postures 0 "left90" 1 "leftStraight" 2 "right90" 3 "rightStraight"
		label values posture Postures
		label define Landmarks 0 "thumbTip" 1 "thumbMCP" 2 "indexTip" 3 "indexMCP" 4 "middleTip" 5 "middleMCP" 6 "ringTip" 7 "ringMCP" 8 "littleTip" 9 "littleMCP" 10 "ulna"
		label values measurement Landmarks
		rename measurement landmark
		g subjNum=`subjNum'
		order trial subjNum posture landmark, first
		drop filename
		mata: st_local("outFile",sprintf("../Data/GM_S%s_actualPosition",st_local("subjNum")))
		save `outFile', replace
		clear	
	}
	else {
		mata: printf("\t - does not exist.\n")
	}
end

program mergeImageAndBaseData
	args subjNum
	mergeRawImageAndBaseData "left90" `subjNum'
	mergeRawImageAndBaseData "leftStraight" `subjNum'
	mergeRawImageAndBaseData "right90" `subjNum'
	mergeRawImageAndBaseData "rightStraight" `subjNum'
	clear
end

program mergeRawImageAndBaseData
	args condition subjNum
	mata: st_local("baseDataFile",sprintf("../Data/GM_S%s_%s_data",st_local("subjNum"),st_local("condition")))
	mata: st_local("imageDataFile",sprintf("../Data/GM_S%s_%s_imageData",st_local("subjNum"),st_local("condition")))
	use `baseDataFile' if condition == 0
	rename xLocation filename
	save "../Data/tempBase.dta", replace
	clear
	use `imageDataFile'
	merge 1:1 filename using "../Data/tempBase.dta"
	drop _merge
	save "../Data/tempBase.dta",replace
	use `baseDataFile' if condition == 1
	destring xLocation, replace
	append using "../Data/tempBase.dta"
	sort trial
	rm "`imageDataFile'.dta"
	replace xLocation=xLocation	+4 //to line up with zero of the image calibration
	mata: calibrateGridReferences()
	drop xLocation yLocation
	drop filename
	save `baseDataFile', replace
	rm "../Data/tempBase.dta"
	clear
end

version 14
mata:
void calibrateGridReferences() {
	gridRefs = st_data(.,"condition xLocation yLocation")
	st_view(calCoords,.,"rawX rawY calX calY")
	count = rows(gridRefs)
	xCalibration = 10.2	//mm
	yCalibration = 10.2 //mm
	for(i=1; i<=count ;i++){
		if(gridRefs[i,1] == 1){
			calCoords[i,1] = gridRefs[i,2]
			calCoords[i,2] = gridRefs[i,3]
			calCoords[i,3] = gridRefs[i,2] * xCalibration
			calCoords[i,4] = gridRefs[i,3] * yCalibration
		}
	}
}
end

program collectPerceivedData
	args subjNum
	use "../Data/GM_S`subjNum'_left90_data.dta"
	append using "../Data/GM_S`subjNum'_leftStraight_data.dta"
	append using "../Data/GM_S`subjNum'_right90_data.dta"
	append using "../Data/GM_S`subjNum'_rightStraight_data.dta"
	label define Conditions 0 "pointing" 1 "gridReference" 2 "actual"
	label values condition Conditions
	label define Postures 0 "left90" 1 "leftStraight" 2 "right90" 3 "rightStraight"
	label values posture Postures
	label define Landmarks 0 "thumbTip" 1 "thumbMCP" 2 "indexTip" 3 "indexMCP" 4 "middleTip" 5 "middleMCP" 6 "ringTip" 7 "ringMCP" 8 "littleTip" 9 "littleMCP" 10 "ulna"
	label values landmark Landmarks
	g subjNum=`subjNum'
	order trial subjNum condition posture landmark, first
	save "../Data/GM_S`subjNum'_perceivedPosition.dta",replace
	rm "../Data/GM_S`subjNum'_left90_data.dta"
	rm "../Data/GM_S`subjNum'_leftStraight_data.dta"
	rm "../Data/GM_S`subjNum'_right90_data.dta"
	rm "../Data/GM_S`subjNum'_rightStraight_data.dta"
	
	collapse (mean) rawX=rawX (sd) rawXSD=rawX (mean) rawY=rawY (sd) rawYSD=rawY (mean) calX=calX (sd) calXSD=calX (mean) calY=calY (sd) calYSD=calY (count) n=subjNum, by(condition posture landmark)
	g subjNum=`subjNum'
	order subjNum, first
	save "../Data/GM_S`subjNum'_perceivedPosition_means.dta", replace
	clear
end

