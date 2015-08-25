program plotGroupMeasurements
	version 14
	clear
	calcMeasurements
	forvalues i = 0/3{
		plotMnMeasurementsForPosture `i'
	}
end
