program plotGroupMeasurements
	version 14
	clear
	calcMeasurements
	forvalues i = 0/4{
		plotMnMeasurementsForPosture `i'
	}
end
