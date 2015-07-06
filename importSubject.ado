program importSubject
	args subjNum
	set more off
	importRawDataFiles `subjNum'
	mergeImageAndBaseData `subjNum'
//	clear
	set more on
end

program importRawDataFiles
	args subjNum
	mata: printf("Importing subject: %s\n",st_local("subNum"))
	importDataCondition "left90" `subjNum'
	importDataCondition "leftStraight" `subjNum'
	importDataCondition "right90" `subjNum'
	importDataCondition "rightStraight" `subjNum'
	importDataActual `subjNum'
	clear
end

program importDataCondition
	args condition subjNum
	importBaseCSVFile `condition' `subjNum'
	importImageCSVFile `condition' `subjNum'
end

program importBaseCSVFile
	args condition subjNum
	mata: st_local("filePath",sprintf("../Data/Raw/S%s/GM_S%s_%s_data.csv",st_local("subjNum"),st_local("subjNum"),st_local("condition")))
	mata: printf("File: %s\n",st_local("filePath"))
	capture confirm file `filePath'
	if _rc==0 {
		clear
		import delimited trial condition landmark xLocation yLocation  using `filePath'
		mata: st_local("outFile",sprintf("../Data/GM_S%s_%s_data",st_local("subjNum"),st_local("condition")))
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
		mata: st_local("outFile",sprintf("../Data/GM_S%s_actualPosition_imageData",st_local("subjNum")))
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
	mata: calibrateGridReferences()
	drop xLocation yLocation
	order filename, last
	save `baseDataFile', replace
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

