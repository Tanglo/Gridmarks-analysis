program importSubject
	args subjNum
	set more off
	mata: printf("Importing subject: %s\n",st_local("subNum"))
	importDataCondition "left90" `subjNum'
	importDataCondition "leftStraight" `subjNum'
	importDataCondition "right90" `subjNum'
	importDataCondition "rightStraight" `subjNum'
	importDataActual `subjNum'
//	clear
end

program importDataCondition
	args condition subjNum
	importBaseCSVFile `condition' `subjNum'
	importImageCSVFile `condition' `subjNum'
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

