program plotMnMeasurementsForPosture
	args postureCode
	version 14
	clear
	use "../Data/GM_groupMeasures.dta" if(posture==`postureCode')
	local postureName: label Postures `postureCode'
	capture graph drop `postureName'
	
	collapse (mean) mnProxShiftTip=proxShiftTip (sd) sdProxShiftTip=proxShiftTip (mean) mnProxShiftMCP=proxShiftMCP (sd) sdProxShiftMCP=proxShiftMCP (mean) mnMedShiftTip=medShiftTip (sd) sdMedShiftTip=medShiftTip (mean) mnMedShiftMCP=medShiftMCP (sd) sdMedShiftMCP=medShiftMCP (mean) mnLengthError=lengthError (sd) sdLengthError=lengthError (mean) mnSpacingError=spacingError (sd) sdSpacingError=spacingError (count) n=subjNum, by(condition digit)
	g hiCIProxShiftTip = mnProxShiftTip + invttail(n-1,0.025)*(sdProxShiftTip/sqrt(n))
	g loCIProxShiftTip = mnProxShiftTip - invttail(n-1,0.025)*(sdProxShiftTip/sqrt(n))
	g hiCIProxShiftMCP = mnProxShiftMCP + invttail(n-1,0.025)*(sdProxShiftMCP/sqrt(n))
	g loCIProxShiftMCP = mnProxShiftMCP - invttail(n-1,0.025)*(sdProxShiftMCP/sqrt(n))
	g hiCIMedShiftTip = mnMedShiftTip + invttail(n-1,0.025)*(sdMedShiftTip/sqrt(n))
	g loCIMedShiftTip = mnMedShiftTip - invttail(n-1,0.025)*(sdMedShiftTip/sqrt(n))
	g hiCIMedShiftMCP = mnMedShiftMCP + invttail(n-1,0.025)*(sdMedShiftMCP/sqrt(n))
	g loCIMedShiftMCP = mnMedShiftMCP - invttail(n-1,0.025)*(sdMedShiftMCP/sqrt(n))
	g hiCILengthError = mnLengthError + invttail(n-1,0.025)*(sdLengthError/sqrt(n))
	g loCILengthError = mnLengthError - invttail(n-1,0.025)*(sdLengthError/sqrt(n))
	g hiCISpacingError = mnSpacingError + invttail(n-1,0.025)*(sdSpacingError/sqrt(n))
	g loCISpacingError = mnSpacingError - invttail(n-1,0.025)*(sdSpacingError/sqrt(n))
	
	g xAxis = digit*2
	replace xAxis=xAxis+1 if(condition==1)	//gridReference
	capture graph drop proxShiftTip
	capture graph drop proxShiftMCP
	capture graph drop medShiftTip
	capture graph drop medShiftMCP
	capture graph drop lengthError
	capture graph drop spacingError
	twoway (bar mnProxShiftTip xAxis if(condition==0), color(navy)) (rcap hiCIProxShiftTip loCIProxShiftTip xAxis if(condition==0), color(navy)) (bar mnProxShiftTip xAxis if(condition==1), color(maroon)) (rcap hiCIProxShiftTip loCIProxShiftTip xAxis if(condition==1), color(maroon)), graphregion(color(none)) bgcolor(white) ytitle("Proximal localisation error of tip (mm)") xtitle("") xlabel(0.5 "Thumb" 2.5 "Index" 4.5 "Middle" 6.5 "Ring" 8.5 "Little",angle(45) valuelabel) name("proxShiftTip") legend(order(1 "Pointing" 3 "Grid reference")) nodraw
	twoway (bar mnProxShiftMCP xAxis if(condition==0), color(navy)) (rcap hiCIProxShiftMCP loCIProxShiftMCP xAxis if(condition==0), color(navy)) (bar mnProxShiftMCP xAxis if(condition==1), color(maroon)) (rcap hiCIProxShiftMCP loCIProxShiftMCP xAxis if(condition==1), color(maroon)), graphregion(color(none)) bgcolor(white) ytitle("Proximal localisation error of MCP (mm)") xtitle("") xlabel(0.5 "Thumb" 2.5 "Index" 4.5 "Middle" 6.5 "Ring" 8.5 "Little",angle(45) valuelabel) name("proxShiftMCP") legend(off) nodraw
	twoway (bar mnMedShiftTip xAxis if(condition==0), color(navy)) (rcap hiCIMedShiftTip loCIMedShiftTip xAxis if(condition==0), color(navy)) (bar mnMedShiftTip xAxis if(condition==1), color(maroon)) (rcap hiCIMedShiftTip loCIMedShiftTip xAxis if(condition==1), color(maroon)), graphregion(color(none)) bgcolor(white) ytitle("Medial localisation error of tip (mm)") xtitle("") xlabel(0.5 "Thumb" 2.5 "Index" 4.5 "Middle" 6.5 "Ring" 8.5 "Little",angle(45) valuelabel) name("medShiftTip") legend(off) nodraw
	twoway (bar mnMedShiftMCP xAxis if(condition==0), color(navy)) (rcap hiCIMedShiftMCP loCIMedShiftMCP xAxis if(condition==0), color(navy)) (bar mnMedShiftMCP xAxis if(condition==1), color(maroon)) (rcap hiCIMedShiftMCP loCIMedShiftMCP xAxis if(condition==1), color(maroon)), graphregion(color(none)) bgcolor(white) ytitle("Medial localisation error of MCP (mm)") xtitle("") xlabel(0.5 "Thumb" 2.5 "Index" 4.5 "Middle" 6.5 "Ring" 8.5 "Little",angle(45) valuelabel) name("medShiftMCP") legend(off) nodraw
	twoway (bar mnLengthError xAxis if(condition==0), color(navy)) (rcap hiCILengthError loCILengthError xAxis if(condition==0), color(navy)) (bar mnLengthError xAxis if(condition==1), color(maroon)) (rcap hiCILengthError loCILengthError xAxis if(condition==1), color(maroon)), graphregion(color(none)) bgcolor(white) ytitle("Error in perceived digit length (mm)") xtitle("") xlabel(0.5 "Thumb" 2.5 "Index" 4.5 "Middle" 6.5 "Ring" 8.5 "Little",angle(45) valuelabel) name("lengthError") legend(off) nodraw
	twoway (bar mnSpacingError xAxis if(condition==0), color(navy)) (rcap hiCISpacingError loCISpacingError xAxis if(condition==0), color(navy)) (bar mnSpacingError xAxis if(condition==1), color(maroon)) (rcap hiCISpacingError loCISpacingError xAxis if(condition==1), color(maroon)), graphregion(color(none)) bgcolor(white) ytitle("Error in perceived digit spacing (mm)") xtitle("") xlabel(0.5 "Thumb" 2.5 "Index" 4.5 "Middle" 6.5 "Ring" 8.5 "Little",angle(45) valuelabel) name("spacingError") legend(off) nodraw
	grc1leg proxShiftTip proxShiftMCP medShiftTip medShiftMCP lengthError spacingError, graphregion(color(white)) title("`postureName'") rows(2) name(`postureName')
	graph drop proxShiftTip
	graph drop proxShiftMCP
	graph drop medShiftTip
	graph drop medShiftMCP
	graph drop lengthError
	graph drop spacingError
	mata: st_local("graphPath",sprintf("../Data/Figures/group_%s_measures.pdf",st_local("postureName")))
	graph export `graphPath',replace name(`postureName')
	clear
	
/*		
	mata: st_local("graphPath",sprintf("../Figs/MnMeasures_%s.pdf",st_local("condition")))
	graph export `graphPath',replace name(`graphName')
	clear
*/
end
