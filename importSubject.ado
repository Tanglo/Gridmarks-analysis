program importSubject
	args subjInitials subjN
	set more off
	display "`subjInitials'"
	mata: printf("Importing subject: %s\n",st_local("subjInitials"))
	importDataType "experimentalData" `subjInitials' `subjN'
	importDataType "actualPositionData" `subjInitials' `subjN'
	importCalibrationData `subjInitials'
	calibrateData `subjInitials'
	clear
	use Landmark_actualPositionData
	mata: st_local("fileName",sprintf("%s/Landmark_%s_actualPositionData",st_local("subjInitials"),st_local("subjInitials")))
	append using `fileName'
	save Landmark_actualPositionData,replace
	clear
	use Landmark_data
	mata: st_local("fileName",sprintf("%s/Landmark_%s_experimentalData",st_local("subjInitials"),st_local("subjInitials")))
	append using `fileName'
	save Landmark_data,replace
	
end

program calibrateData
	args subjInitials
	clear
	mata: st_local("calibrationFileName",sprintf("%s/Land_%s_calibration_actualPositionData",st_local("subjInitials"),st_local("subjInitials")))
	use `calibrationFileName'
	mata: calData = st_data(.,"rawX rawY")
	//mata: printf("%g, %g, %g, %g",rawCoords[1,1],rawCoords[1,2],rawCoords[1,3],rawCoords[1,4])
	mata: st_local("mainFileName",sprintf("%s/Landmark_%s_experimentalData",st_local("subjInitials"),st_local("subjInitials")))
	use `mainFileName'
	generate calX=.
	generate calY=.
	mata: calibrateDataWith(calData)
	save `mainFileName', replace
	mata: st_local("mainFileName",sprintf("%s/Landmark_%s_actualPositionData",st_local("subjInitials"),st_local("subjInitials")))
	use `mainFileName'
	generate calX=.
	generate calY=.
	mata: calibrateDataWith(calData)
	save `mainFileName', replace
	clear
end

version 13
mata:
void calibrateDataWith(real matrix calData) {
	rawCoords = st_data(.,"rawX rawY")
	st_view(calCoords,.,"calX calY")
	count = rows(rawCoords)
	xOffset = calData[1,1]
	xFactor = calData[2,1] - xOffset
	yOffset = calData[1,2]
	yFactor = calData[3,2] - yOffset
	for(i=1; i<=count ;i++){
		calCoords[i,1] = (rawCoords[i,1] - xOffset) / xFactor * 100
		calCoords[i,2] = (rawCoords[i,2] - yOffset) / yFactor * 100
	}
}
end


program importCalibrationData
	args subjInitials
	clear
	mata: st_local("fileName",sprintf("%s/Land_%s_calibration_actualPositionData",st_local("subjInitials"),st_local("subjInitials")))
	mata: st_local("csvName",sprintf("%s.csv",st_local("fileName")))
	mata: printf("\tFile: %s\n",st_local("csvName"))
	capture confirm file `csvName'
	if _rc==0 {
		clear
		import delimited landmark rawX rawY using `csvName'
		drop landmark
		keep in 1/3
		generate point = "-"
		replace point = "zero" in 1
		replace point = "x100" in 2
		replace point = "y100" in 3
		order point,first
		save `fileName', replace
		clear
		
	}
	else {
		mata: printf("\t - does not exist.\n")
	}
end

program importDataType
	args dataType subjInitials subjN
	importCSVFile `dataType' `subjInitials' "instructionDorsal"
	importCSVFile `dataType' `subjInitials' "pointerDorsal"
	importCSVFile `dataType' `subjInitials' "visionDorsal"
	importCSVFile `dataType' `subjInitials' "blindDorsal"
	importCSVFile `dataType' `subjInitials' "visionPalmar"
	importCSVFile `dataType' `subjInitials' "blindPalmar"
	clear
	mata: st_local("dataFileName",sprintf("%s/Land_%s_instructionDorsal_%s",st_local("subjInitials"),st_local("subjInitials"),st_local("dataType")))
	capture confirm file "`dataFileName'.dta"
	if _rc==0 {
		append using `dataFileName'
		rm "`dataFileName'.dta"
	}
	mata: st_local("dataFileName",sprintf("%s/Land_%s_pointerDorsal_%s",st_local("subjInitials"),st_local("subjInitials"),st_local("dataType")))
	capture confirm file "`dataFileName'.dta"
	if _rc==0 {
		append using `dataFileName'
		rm "`dataFileName'.dta"
	}
	mata: st_local("dataFileName",sprintf("%s/Land_%s_visionDorsal_%s",st_local("subjInitials"),st_local("subjInitials"),st_local("dataType")))
	capture confirm file "`dataFileName'.dta"
	if _rc==0 {
		append using `dataFileName'
		rm "`dataFileName'.dta"
	}
	mata: st_local("dataFileName",sprintf("%s/Land_%s_blindDorsal_%s",st_local("subjInitials"),st_local("subjInitials"),st_local("dataType")))
	capture confirm file "`dataFileName'.dta"
	if _rc==0 {
		append using `dataFileName'
		rm "`dataFileName'.dta"
	}
	mata: st_local("dataFileName",sprintf("%s/Land_%s_visionPalmar_%s",st_local("subjInitials"),st_local("subjInitials"),st_local("dataType")))
	capture confirm file "`dataFileName'.dta"
	if _rc==0 {
		append using `dataFileName'
		rm "`dataFileName'.dta"
	}
	mata: st_local("dataFileName",sprintf("%s/Land_%s_blindPalmar_%s",st_local("subjInitials"),st_local("subjInitials"),st_local("dataType")))
	capture confirm file "`dataFileName'.dta"
	if _rc==0 {
		append using `dataFileName'
		rm "`dataFileName'.dta"
	}
	generate subjNum = `subjN'
	order subjNum, first
	mata: st_local("mainFileName",sprintf("%s/Landmark_%s_%s",st_local("subjInitials"),st_local("subjInitials"),st_local("dataType")))
	save `mainFileName',replace
	clear
end

program importCSVFile
	args dataType subjInitials block
	mata: st_local("fileStem",sprintf("%s/Land_%s_%s_%s",st_local("subjInitials"),st_local("subjInitials"),st_local("block"),st_local("dataType")))
	mata: st_local("csvPath",sprintf("%s.csv",st_local("fileStem")))
	mata: printf("\tFile: %s\n",st_local("csvPath"))
	capture confirm file `csvPath'
	if _rc==0 {
		clear
		import delimited landmark rawX rawY using `csvPath'
		generate condition = "`block'"
		order condition, first
		save `fileStem', replace
		clear
		
	}
	else {
		mata: printf("\t - does not exist.\n")
	}
end
