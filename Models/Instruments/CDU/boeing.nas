#Initialize the properties here 
setprop("/instrumentation/cdu/LATorBRG",0);
setprop("/instrumentation/cdu/isARMED",0);
setprop("/autopilot/route-manager/cruise/altitude-ft",0);
setprop("/instrumentation/cdu/sids/rwyIsSelected", 0);
setprop("/instrumentation/cdu/sids/sidIsSelected", 0);
setprop("instrumentation/cdu/StepSize","RVSM");
setprop("/instrumentation/fmc/THRLIM","TOGA");
setprop("/instrumentation/fmc/CLB_LIM","CLB");
setprop("/instrumentation/fmc/isCustomizeFlaps",0);
setprop("/instrumentation/fmc/isInputedPos",0);
setprop("/autopilot/route-manager/isArmed",-1);
setprop("/autopilot/route-manager/isChanged",1);
setprop("/fmc/EoAccelHT",1000);
setprop("/fmc/AccelHT",1000);
setprop("/fmc/Reduction",1000);
setprop("/fmc/ref-temperature-degc",-999);
#Initialize aera end

var input = func(v) {
		setprop("/instrumentation/cdu/input",getprop("/instrumentation/cdu/input")~v);
}

var armChanges = func(){
	if (getprop("/autopilot/route-manager/departure/newsid") != nil){
		setprop("/autopilot/route-manager/departure/sid", getprop("/autopilot/route-manager/departure/newsid"));
	}
	if (getprop("/autopilot/route-manager/departure/newrunway") != nil){
		setprop("/autopilot/route-manager/departure/runway", getprop("/autopilot/route-manager/departure/newrunway"));
	}
	setprop("/autopilot/route-manager/isArmed",1);
}
	
var delete = func {
		var length = size(getprop("/instrumentation/cdu/input")) - 1;
		setprop("/instrumentation/cdu/input",substr(getprop("/instrumentation/cdu/input"),0,length));
}

var plusminus = func {
	var end = size(getprop("/instrumentation/cdu/input"));
	var start = end - 1;
	var lastchar = substr(getprop("/instrumentation/cdu/input"),start,end);
	if (lastchar == "+"){
		me.delete();
		me.input('-');
		}
	if (lastchar == "-"){
		me.delete();
		me.input('+');
		}
	if ((lastchar != "-") and (lastchar != "+")){
		me.input('+');
		}
}
	
var i = 0;

var key = func(v) {
		var cduDisplay = getprop("/instrumentation/cdu/display");
		var serviceable = getprop("/instrumentation/cdu/serviceable");
		var eicasDisplay = getprop("/instrumentation/eicas/display");
		var cduInput = getprop("/instrumentation/cdu/input");
		
		if (serviceable == 1){
			if (v == "LSK1L"){
				if (cduDisplay == "RTE1_DEP"){
					if (getprop("/instrumentation/cdu/output/line1/left") != ""){
						setprop("/autopilot/route-manager/isChanged",1);
						setprop("/autopilot/route-manager/departure/newsid", getprop("/instrumentation/cdu/output/line1/left"));
						setprop("/instrumentation/cdu/sids/sidIsSelected", 1);
						setprop("/autopilot/route-manager/departure/newrunway", getRwyOfSids(getprop("/instrumentation/cdu/output/line1/left")));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
						setprop("/autopilot/route-manager/departure/sidID", getprop("/instrumentation/cdu/output/line1/left"));
					}
				}
				if (cduDisplay == "DEP_ARR_INDEX"){
					cduDisplay = "RTE1_DEP";
					setprop("/instrumentation/cdu/sids/page", 1);
				}
				if (cduDisplay == "EICAS_MODES"){
					eicasDisplay = "ENG";
				}
				if (cduDisplay == "EICAS_SYN"){
					eicasDisplay = "ELEC";
				}
				if (cduDisplay == "INIT_REF"){
					cduDisplay = "IDENT";
					#fmc.getVSpeeds(getprop("/instrumentation/cdu/ident/engines"));
				}
				if (cduDisplay == "NAV_RAD"){
					if (int(cduInput) > 107 and int(cduInput) < 119) {
				 	 setprop("/instrumentation/nav[0]/frequencies/selected-mhz",cduInput);
					}
					cduInput = "";
				}
				if (cduDisplay == "RTE1_1"){
					setprop("/autopilot/route-manager/departure/airport",cduInput);
					cduInput = "";
				}
				if (cduDisplay == "RTE1_LEGS"){
					if (cduInput == "DELETE"){
						setprop("/autopilot/route-manager/input","@DELETE1");
						cduInput = "";
					}
					else{
						setprop("/autopilot/route-manager/input","@INSERT2:"~cduInput);
					}
				}
				if (cduDisplay == "TO_REF"){
					setprop("/instrumentation/fmc/to-flap",cduInput);
					setprop("/instrumentation/fmc/isCustomizeFlaps",1);
					cduInput = "";
				}
				if (cduDisplay == "POS_REF_0"){
					cduInput = LatDMMunsignal(getprop("/position/latitude-deg"))~LonDmmUnsignal(getprop("/position/longitude-deg"));
				}
				if (cduDisplay == "POS_REF"){
					cduInput = LatDMMunsignal(getprop("/position/latitude-deg"))~LonDmmUnsignal(getprop("/position/longitude-deg"));
				}
			}
			if (v == "LSK1R"){
				if (cduDisplay == "RTE1_DEP"){
					if (getprop("/instrumentation/cdu/output/line1/right") != ""){
						setprop("/autopilot/route-manager/isChanged",1);
						setprop("/autopilot/route-manager/departure/newrunway", getprop("/instrumentation/cdu/output/line1/right"));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
					}
					
				}
				if (cduDisplay == "EICAS_MODES"){
					eicasDisplay = "FUEL";
				}
				if (cduDisplay == "EICAS_SYN"){
					eicasDisplay = "HYD";
				}
				if (cduDisplay == "POS_INIT"){
					cduInput = LatDMMunsignal(getprop("/instrumentation/fmc/lastposlat"))~LonDmmUnsignal(getprop("/instrumentation/fmc/lastposlon"));
				}
				if (cduDisplay == "NAV_RAD"){
					if (int(cduInput) > 107 and int(cduInput) < 119) {
						setprop("/instrumentation/nav[1]/frequencies/selected-mhz",cduInput);
					}
					cduInput = "";
				}
				if (cduDisplay == "RTE1_1"){
					setprop("/autopilot/route-manager/destination/airport",cduInput);
					cduInput = "";
				}
				if (cduDisplay == "RTE1_LEGS"){
					setprop("/autopilot/route-manager/route/wp[1]/altitude-ft",cduInput);
					if (substr(cduInput,0,2) == "FL"){
						setprop("/autopilot/route-manager/route/wp[1]/altitude-ft",substr(cduInput,2)*100);
					}
					cduInput = "";
				}
				if (cduDisplay == "POS_REF_0"){
					if (getprop("/instrumentation/cdu/isARMED") == 0)
					{
						setprop("/instrumentation/cdu/isARMED",1);
					}
					else if(getprop("/instrumentation/cdu/isARMED") == 1)
					{
						setprop("/instrumentation/cdu/isARMED",0);
					}
				}
				if (cduDisplay == "PERF_INIT"){
					if(find("FL", cduInput) != -1){
						if (size(cduInput) <=5 ){
							if(num(substr(cduInput,2,size(cduInput))) != nil){
								if (substr(cduInput,2,size(cduInput)) >= 100){
									if(substr(cduInput,2,size(cduInput)) <= 412){
										setprop("/autopilot/route-manager/cruise/altitude-FL",cduInput);
										setprop("/autopilot/route-manager/cruise/altitude-ft",FL2feet(cduInput));
										cduInput = "";
									}else{cduInput = "INVALID ENTRY";}
								}else{cduInput = "INVALID ENTRY";}
							}
						}else{cduInput = "INVALID ENTRY";}
					}else if(find("FL", cduInput) == -1){
						if (num(cduInput) != nil){
							if (cduInput >= 1000){
								if (cduInput < 10000){
									setprop("/autopilot/route-manager/cruise/altitude-ft",cduInput);
									setprop("/autopilot/route-manager/cruise/altitude-FL",feet2FL(cduInput));
									cduInput = "";
								}else if(cduInput >= 10000){
									if(cduInput <= 41200){
										setprop("/autopilot/route-manager/cruise/altitude-ft",cduInput);
										setprop("/autopilot/route-manager/cruise/altitude-FL",feet2FL(cduInput));
										cduInput = "";
									}else if(cduInput >= 10){
										if(cduInput <= 412){
											setprop("/autopilot/route-manager/cruise/altitude-FL","FL"~cduInput);
											setprop("/autopilot/route-manager/cruise/altitude-ft",int(cduInput~"00"));
											cduInput = "";
											}else{cduInput = "INVALID ENTRY";}
										}else{cduInput = "INVALID ENTRY";}
									}
								}
							}else{cduInput = "INVALID ENTRY";}
						}else{cduInput = "INVALID ENTRY";}
						
					}
					if (cduDisplay == "TO_REF"){
					if(cduInput == ""){setprop("/instrumentation/fmc/V1checked",1);}
					else if(num(cduInput) != nil){
							setprop("/instrumentation/fmc/vspeeds/V1");
							setprop("/instrumentation/fmc/V1checked",1);
							cduInput = "";
					}else{setprop("/instrumentation/fmc/V1checked",1);}
				}
			}
			}
			if (v == "LSK2L"){
				if (cduDisplay == "RTE1_DEP"){
					if (getprop("/instrumentation/cdu/output/line2/left") != ""){
						setprop("/autopilot/route-manager/isChanged",1);
						setprop("/autopilot/route-manager/departure/newsid", getprop("/instrumentation/cdu/output/line2/left"));
						setprop("/instrumentation/cdu/sids/sidIsSelected", 1);
						setprop("/autopilot/route-manager/departure/newrunway", getRwyOfSids(getprop("/instrumentation/cdu/output/line2/left")));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
						setprop("/autopilot/route-manager/departure/sidID", getprop("/instrumentation/cdu/output/line2/left"));
					}
				}
				if (cduDisplay == "EICAS_MODES"){
					eicasDisplay = "STAT";
				}
				if (cduDisplay == "EICAS_SYN"){
					eicasDisplay = "ECS";
				}
				if (cduDisplay == "POS_INIT"){
					setprop("/instrumentation/fmc/ref-airport",cduInput);
					var RefApt = airportinfo(getprop("/instrumentation/fmc/ref-airport"));
					setprop("/instrumentation/fmc/ref-airport-poslat",RefApt.lat);
					setprop("/instrumentation/fmc/ref-airport-poslon",RefApt.lon);
					cduInput = "";
				}
				if (cduDisplay == "NAV_RAD"){
					if (int(cduInput) < 360) {
						setprop("/instrumentation/nav[0]/radials/selected-deg",cduInput);
					}
					cduInput = "";
				}
				if (cduDisplay == "INIT_REF"){
					cduDisplay = "POS_INIT";
				}
				if (cduDisplay == "RTE1_1"){
					if (getprop("/autopilot/route-manager/departure/airport") == ""){
						cduInput = cduInput;
					}
					else{
					setprop("/autopilot/route-manager/departure/newrunway",cduInput);
					cduInput = "";
					}
				}
				if (cduDisplay == "RTE1_LEGS"){
					if (cduInput == "DELETE"){
						setprop("/autopilot/route-manager/input","@DELETE2");
						cduInput = "";
					}
					else{
						setprop("/autopilot/route-manager/input","@INSERT3:"~cduInput);
					}
				}
				if (cduDisplay == "POS_REF_0"){
					cduInput = LatDMMunsignal(getprop("/position/latitude-deg"))~LonDmmUnsignal(getprop("/position/longitude-deg"));
				}
				if (cduDisplay == "POS_REF"){
					cduInput = LatDMMunsignal(getprop("/position/latitude-deg"))~LonDmmUnsignal(getprop("/position/longitude-deg"));
				}
				if (cduDisplay == "THR_LIM"){
					setprop("/instrumentation/fmc/THRLIM","TOGA");
				}
			}
			if (v == "LSK2R"){
				if (cduDisplay == "RTE1_DEP"){
					setprop("/autopilot/route-manager/isChanged",1);
					if (getprop("/instrumentation/cdu/output/line2") != ""){
						setprop("/autopilot/route-manager/departure/newrunway", getprop("/instrumentation/cdu/output/line2/right"));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
					}
				}else if (cduDisplay == "DEP_ARR_INDEX")
				{
					cduDisplay = "RTE1_ARR";
				}
				else if (cduDisplay == "EICAS_MODES"){
					eicasDisplay = "GEAR";
				}
				else if (cduDisplay == "EICAS_SYN"){
					eicasDisplay = "DRS";
				}else if (cduDisplay == "POS_INIT"){
					if(getprop("/instrumentation/fmc/ref-airport") != ""){
						cduInput = LatDMMunsignal(getprop("/instrumentation/fmc/ref-airport-poslat"))~LonDmmUnsignal(getprop("/instrumentation/fmc/ref-airport-poslon"));
					}
				}
				else if (cduDisplay == "NAV_RAD"){
					if (int(cduInput) < 360) {
						setprop("/instrumentation/nav[1]/radials/selected-deg",cduInput);
					}
					cduInput = "";
				}
				else if (cduDisplay == "MENU"){
					eicasDisplay = "EICAS_MODES";
				}
				else if (cduDisplay == "RTE1_LEGS"){
					setprop("/autopilot/route-manager/route/wp[2]/altitude-ft",cduInput);
					if (substr(cduInput,0,2) == "FL"){
						setprop("/autopilot/route-manager/route/wp[2]/altitude-ft",substr(cduInput,2)*100);
					}
					cduInput = "";
				}
				else if (cduDisplay == "RTE1_1"){
					setprop("/instrumentation/fmc/flight-number",cduInput);
					cduInput = "";
				}else if (cduDisplay == "PERF_INIT"){
					if (num(cduInput) != nil){
						if(cduInput >= 0){
							if(cduInput <= 1000){
								setprop("/instrumentation/fmc/COST_INDEX",cduInput);
								cduInput = "";
							}else{cduInput = "INVALID ENTRY"}
						}else{cduInput = "INVALID ENTRY"}
					}else{cduInput = "INVALID ENTRY"}
				}
				else if(cduDisplay == "THR_LIM"){
					setprop("/instrumentation/fmc/CLB_LIM","CLB");
				}
				else if (cduDisplay == "TO_REF"){
					if(cduInput == ""){setprop("/instrumentation/fmc/VRchecked",1);}
					else if(num(cduInput) != nil){
							setprop("/instrumentation/fmc/vspeeds/VR");
							setprop("/instrumentation/fmc/VRchecked",1);
							cduInput = "";
					}else{setprop("/instrumentation/fmc/VRchecked",1);}
				}
			}
			if (v == "LSK3L"){
				if (cduDisplay == "RTE1_DEP"){
					if (getprop("/instrumentation/cdu/output/line3/left") != ""){
						setprop("/autopilot/route-manager/isChanged",1);
						setprop("/autopilot/route-manager/departure/newsid", getprop("/instrumentation/cdu/output/line3/left"));
						setprop("/instrumentation/cdu/sids/sidIsSelected", 1);
						setprop("/autopilot/route-manager/departure/newrunway", getRwyOfSids(getprop("/instrumentation/cdu/output/line3/left")));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
						setprop("/autopilot/route-manager/departure/sidID", getprop("/instrumentation/cdu/output/line3/left"));
					}
				}
				if (cduDisplay == "INIT_REF"){
					cduDisplay = "PERF_INIT";
				}
				if (cduDisplay == "POS_INIT"){
					setprop("/instrumentation/fmc/gate",cduInput);
					cduInput = "";
				}
				if (cduDisplay == "NAV_RAD"){
					if (int(cduInput) > 189 and int(cduInput) < 1751) {
						setprop("/instrumentation/adf[0]/frequencies/selected-khz",cduInput);
					}
					cduInput = "";
				}
				if (cduDisplay == "RTE1_LEGS"){
					if (cduInput == "DELETE"){
						setprop("/autopilot/route-manager/input","@DELETE3");
						cduInput = "";
					}
					else{
						setprop("/autopilot/route-manager/input","@INSERT4:"~cduInput);
					}
				}
				if (cduDisplay == "POS_REF_0"){
					cduInput = LatDMMunsignal(getprop("/position/latitude-deg"))~LonDmmUnsignal(getprop("/position/longitude-deg"));
				}
				if (cduDisplay == "POS_REF"){
					cduInput = LatDMMunsignal(getprop("/position/latitude-deg"))~LonDmmUnsignal(getprop("/position/longitude-deg"));
				}
				if (cduDisplay == "THR_LIM"){
					setprop("/instrumentation/fmc/THRLIM","TO-1");
				}
			}
			if (v == "LSK3R"){
				if (cduDisplay == "RTE1_DEP"){
					if (getprop("/instrumentation/cdu/output/line3") != ""){
						setprop("/autopilot/route-manager/isChanged",1);
						setprop("/autopilot/route-manager/departure/newrunway", getprop("/instrumentation/cdu/output/line3/right"));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
						}
					}
				if (cduDisplay == "NAV_RAD"){
					if (int(cduInput) > 189 and int(cduInput) < 1751) {
						setprop("/instrumentation/adf[1]/frequencies/selected-khz",cduInput);
					}
					cduInput = "";
				}
				if (cduDisplay == "RTE1_LEGS"){
					setprop("/autopilot/route-manager/route/wp[3]/altitude-ft",cduInput);
					if (substr(cduInput,0,2) == "FL"){
						setprop("/autopilot/route-manager/route/wp[3]/altitude-ft",substr(cduInput,2)*100);
					}
					cduInput = "";
				}
				else if(cduDisplay == "THR_LIM"){
					setprop("/instrumentation/fmc/CLB_LIM","CLB-1");
				}
				else if (cduDisplay == "TO_REF"){
					if(cduInput == ""){setprop("/instrumentation/fmc/V2checked",1);}
					else if(num(cduInput) != nil){
							setprop("/instrumentation/fmc/vspeeds/V2");
							setprop("/instrumentation/fmc/V2checked",1);
							cduInput = "";
					}else{setprop("/instrumentation/fmc/V2checked",1);}
				}
			}
			if (v == "LSK4L"){
				if (cduDisplay == "RTE1_DEP"){
					if (getprop("/instrumentation/cdu/output/line4/left") != ""){
						setprop("/autopilot/route-manager/isChanged",1);
						setprop("/autopilot/route-manager/departure/newsid", getprop("/instrumentation/cdu/output/line4/left"));
						setprop("/instrumentation/cdu/sids/sidIsSelected", 1);
						setprop("/autopilot/route-manager/departure/newrunway", getRwyOfSids(getprop("/instrumentation/cdu/output/line4/left")));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
						setprop("/autopilot/route-manager/departure/sidID", getprop("/instrumentation/cdu/output/line4/left"));
					}
				}
				if (cduDisplay == "INIT_REF"){
					cduDisplay = "THR_LIM";
				}
				if (cduDisplay == "RTE1_LEGS"){
					if (cduInput == "DELETE"){
						setprop("/autopilot/route-manager/input","@DELETE4");
						cduInput = "";
					}
					else{
						setprop("/autopilot/route-manager/input","@INSERT5:"~cduInput);
					}
				}
				if (cduDisplay == "POS_REF_0"){
					cduInput = LatDMMunsignal(getprop("/position/latitude-deg"))~LonDmmUnsignal(getprop("/position/longitude-deg"));
				}if (cduDisplay == "POS_REF"){
					cduInput = LatDMMunsignal(getprop("/position/latitude-deg"))~LonDmmUnsignal(getprop("/position/longitude-deg"));
				}
				if (cduDisplay == "PERF_INIT"){
					setprop("/instrumentation/cdu/RESERVES",cduInput);
					cduInput = "";
				}
				if (cduDisplay == "THR_LIM"){
					setprop("/instrumentation/fmc/THRLIM","TO-2");
				}
			}
			if (v == "LSK4R"){
				if (cduDisplay == "RTE1_DEP"){
					if (getprop("/instrumentation/cdu/output/line4") != ""){
						setprop("/autopilot/route-manager/isChanged",1);
						setprop("/autopilot/route-manager/departure/newrunway", getprop("/instrumentation/cdu/output/line4/right"));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
						}
					}
				if (cduDisplay == "POS_INIT"){
					cduInput = LatDMMunsignal(getprop("/instrumentation/fmc/gpsposlat"))~LonDmmUnsignal(getprop("/instrumentation/fmc/gpsposlon"));
				}
				if (cduDisplay == "RTE1_LEGS"){
					setprop("/autopilot/route-manager/route/wp[4]/altitude-ft",cduInput);
					if (substr(cduInput,0,2) == "FL"){
						setprop("/autopilot/route-manager/route/wp[4]/altitude-ft",substr(cduInput,2)*100);
					}
					cduInput = "";
				}
				if(cduDisplay == "THR_LIM"){
					setprop("/instrumentation/fmc/CLB_LIM","CLB-2");
				}
				if (cduDisplay == "TO_REF"){
					if(cduInput == ""){setprop("/instrumentation/fmc/V2checked",1);}
					else if(num(cduInput) != nil){
							setprop("/instrumentation/fmc/vspeeds/V2");
							setprop("/instrumentation/fmc/V1checked",2);
							cduInput = "";
					}else{setprop("/instrumentation/fmc/V1checked",1);}
				}
			}
			if (v == "LSK5L"){
				if (cduDisplay == "RTE1_DEP"){
					if (getprop("/instrumentation/cdu/output/line5/left") != ""){
						setprop("/autopilot/route-manager/isChanged",1);
						setprop("/autopilot/route-manager/departure/newsid", getprop("/instrumentation/cdu/output/line5/left"));
						setprop("/instrumentation/cdu/sids/sidIsSelected", 1);
						setprop("/autopilot/route-manager/departure/newrunway", getRwyOfSids(getprop("/instrumentation/cdu/output/line5/left")));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
						setprop("/autopilot/route-manager/departure/sidID", getprop("/instrumentation/cdu/output/line5/left"));
					}
				}
				if (cduDisplay == "INIT_REF"){
					cduDisplay = "TO_REF";
				}
				if (cduDisplay == "RTE1_LEGS"){
					if (cduInput == "DELETE"){
						setprop("/autopilot/route-manager/input","@DELETE5");
						cduInput = "";
					}
					else{
						setprop("/autopilot/route-manager/input","@INSERT6:"~cduInput);
					}
				}
			}
			if (v == "LSK5R"){
				if (cduDisplay == "RTE1_DEP"){
					setprop("/autopilot/route-manager/isChanged",1);
					if (getprop("/instrumentation/cdu/output/line5") != ""){
						setprop("/autopilot/route-manager/departure/newrunway", getprop("/instrumentation/cdu/output/line5/right"));
						setprop("/instrumentation/cdu/sids/rwyIsSelected", 1);
						}
					}
				if (cduDisplay == "RTE1_LEGS"){
					setprop("/autopilot/route-manager/route/wp[5]/altitude-ft",cduInput);
					if (substr(cduInput,0,2) == "FL"){
						setprop("/autopilot/route-manager/route/wp[5]/altitude-ft",substr(cduInput,2)*100);
					}
					cduInput = "";
				}
				if (cduDisplay == "POS_INIT"){
					call(func getIRSPos(cduInput), nil, var err2 = []);
					if (size(err2)){
						setprop("/instrumentation/fmc/isInputedPos",0);
						cduInput = "INVALID ENTRY";
					}else{
						setprop("/instrumentation/fmc/isInputedPos",1);
						cduInput = "";
					}
				}
				if (cduDisplay == "TO_REF_2")
				{
					setprop("/fmc/ref-temperature-degc",cduInput);
					cduInput = "";
				}
				if (cduDisplay == "PERF_INIT")
				{
					if (cduInput == "0")
					{
						setprop("/instrumentation/cdu/StepSize","INHIBIT");
						cduInput = "";
					}
					else if(cduInput == "R")
					{
						setprop("/instrumentation/cdu/StepSize","RVSM");
						cduInput = "";
					}
					else if(cduInput == "RVSM")
					{
						setprop("/instrumentation/cdu/StepSize","RVSM");
						cduInput = "";
					}
					else if(cduInput == "I")
					{
						setprop("/instrumentation/cdu/StepSize","ICAO");
						cduInput = "";
					}
					else if(cduInput == "ICAO")
					{
						setprop("/instrumentation/cdu/StepSize","ICAO");
						cduInput = "";
					}
				}
			}
			if (v == "LSK6L"){
				if (cduDisplay == "INIT_REF"){
					cduDisplay = "APP_REF";
				}else if ((cduDisplay == "APP_REF") or (cduDisplay == "IDENT") or (cduDisplay == "MAINT") or (cduDisplay == "PERF_INIT") or (cduDisplay == "POS_INIT") or (cduDisplay == "POS_REF") or (cduDisplay == "THR_LIM") or (cduDisplay == "TO_REF")){
					cduDisplay = "INIT_REF";
				}else if (cduDisplay == "RTE1_DEP"){
					if(getprop("/autopilot/route-manager/isChanged") != 0){
						if (getprop("/autopilot/route-manager/departure/sid") != nil){
							setprop("/autopilot/route-manager/departure/newsid", getprop("/autopilot/route-manager/departure/sid"));
						}else{
							setprop("/instrumentation/cdu/sids/sidIsSelected", 0);
						}
						if (getprop("/autopilot/route-manager/departure/runway") != nil){
							setprop("/autopilot/route-manager/departure/newrunway", getprop("/autopilot/route-manager/departure/runway"));
						}else{
							setprop("/instrumentation/cdu/sids/rwyIsSelected", 0);
						}
						setprop("/autopilot/route-manager/isChanged", 0);
						setprop("/autopilot/route-manager/isArmed", -1);
					}else{
						cduDisplay = "DEP_ARR_INDEX";
					}
				}
				
			}
			if (v == "LSK6R"){
				if (cduDisplay == "THR_LIM"){
					cduDisplay = "TO_REF";
				}
				else if (cduDisplay == "APP_REF"){
					cduDisplay = "THR_LIM";
				}
				else if ((cduDisplay == "RTE1_1") or (cduDisplay == "RTE1_LEGS")){
					armChanges();
				}
				else if ((cduDisplay == "POS_INIT") or (cduDisplay == "DEP") or (cduDisplay == "RTE1_ARR") or (cduDisplay == "RTE1_DEP")){
					cduDisplay = "RTE1_1";
				}
				else if ((cduDisplay == "IDENT") or (cduDisplay == "TO_REF")){
					cduDisplay = "POS_INIT";
				}
				else if (cduDisplay == "EICAS_SYN"){
					cduDisplay = "EICAS_MODES";
				}
				else if (cduDisplay == "EICAS_MODES"){
					cduDisplay = "EICAS_SYN";
				}
				else if (cduDisplay == "INIT_REF"){
					cduDisplay = "MAINT";
				}
				else if (cduDisplay == "POS_REF_0"){
					if(getprop("/instrumentation/cdu/LATorBRG") == 1)
					{
						setprop("/instrumentation/cdu/LATorBRG",0);
					}
					else if(getprop("/instrumentation/cdu/LATorBRG") == 0)
					{
						setprop("/instrumentation/cdu/LATorBRG",1);
					}
				}
				else if (cduDisplay == "POS_REF"){
					if(getprop("/instrumentation/cdu/LATorBRG") == 1)
					{
						setprop("/instrumentation/cdu/LATorBRG",0);
					}
					else if(getprop("/instrumentation/cdu/LATorBRG") == 0)
					{
						setprop("/instrumentation/cdu/LATorBRG",1);
					}
				}
				else if(cduDisplay == "PERF_INIT")
				{
					cduDisplay = "THR_LIM";
				}
			}
			
			setprop("/instrumentation/cdu/display",cduDisplay);
			if (eicasDisplay != nil){
				setprop("/instrumentation/eicas/display",eicasDisplay);
			}
			setprop("/instrumentation/cdu/input",cduInput);
}

var cdu = func{
		
		var display = getprop("/instrumentation/cdu/display");
		var serviceable = getprop("/instrumentation/cdu/serviceable");
		title = "";		page = "";
		line1l = "";	line2l = "";	line3l = "";	line4l = "";	line5l = "";	line6l = "";
		line1lt = "";	line2lt = "";	line3lt = "";	line4lt = "";	line5lt = "";	line6lt = "";
		line1ls = "";	line2ls = "";	line3ls = "";	line4ls = "";	line5ls = "";	line6ls = "";
		line1c = "";	line2c = "";	line3c = "";	line4c = "";	line5c = "";	line6c = "";
		line1ct = "";	line2ct = "";	line3ct = "";	line4ct = "";	line5ct = "";	line6ct = "";
		line1r = "";	line2r = "";	line3r = "";	line4r = "";	line5r = "";	line6r = "";
		line1rt = "";	line2rt = "";	line3rt = "";	line4rt = "";	line5rt = "";	line6rt = "";
		line1rs = "";	line2rs = "";	line3rs = "";	line4rs = "";	line5rs = "";	line6rs = "";
		line1ctl = "";	line1cl = ""; line1cr = "";
		line2ctl = "";	line2cl = ""; line2cr = "";
		line3ctl = "";	line3cl = ""; line3cr = "";
		line4ctl = "";	line4cl = ""; line4cr = "";
		line5ctl = "";	line5cl = ""; line5cr = "";
		line6ctl = "";	line6cl = ""; line6cr = "";
		
		
		if (display == "MENU") {
			title = "MENU";
			line1l = "<FMC";
			line1rt = "EFIS CP";
			line1r = "SELECT>";
			line2l = "<ACARS";
			line2rt = "EICAS CP";
			line2r = "SELECT>";
			line6l = "<ACMS";
			line6r = "CMC>";
		}
		if (display == "ALTN_NAV_RAD") {
			title = "ALTN NAV RADIO";
		}
		if (display == "APP_REF") {
			title = "APPROACH REF";
			line1lt = "GROSS WT";
			line1cr = "FLAPS";
			line2cr = "20*";
			line3cr = "25*";
			line4cr = "30*";
			line1rt = "VREF";		
			if (getprop("/autopilot/route-manager/destination/airport") != nil){
				line4lt = getprop("/autopilot/route-manager/destination/airport");
			}
			if (lbs2tons(getprop("/fdm/yasim/gross-weight-lbs")) != nil){
				line1l = sprintf("%3.2f",lbs2tons(getprop("/yasim/gross-weight-lbs")));
				setprop("/fdm/yasim/gross-weight-tons",lbs2tons(getprop("/yasim/gross-weight-lbs")));
				
			}
			line6l = "<INDEX";
			line6r = "THRUST LIM>";
		}
		if (display == "DEP_ARR_INDEX") {
			title = "DEP/ARR INDEX";
			line1l = "<DEP";
			line1ct = "RTE 1";
			if (getprop("/autopilot/route-manager/departure/airport") != nil){
				line1c = getprop("/autopilot/route-manager/departure/airport");
			}
			line1r = "ARR>";
			if (getprop("/autopilot/route-manager/destination/airport") != nil){
				line2c = getprop("/autopilot/route-manager/destination/airport");
			}
			line2r = "ARR>";
			line3l = "<DEP";
			line3r = "ARR>";
			line4r = "ARR>";
			line6lt ="DEP";
			line6l = "<----";
			line6c = "OTHER";
			line6rt ="ARR";
			line6r = "---->";
		}
		if (display == "EICAS_MODES") {
			title = "EICAS MODES";
			line1l = "<ENG";
			line1r = "FUEL>";
			line2l = "<STAT";
			line2r = "GEAR>";
			line5l = "<CANC";
			line5r = "RCL>";
			line6r = "SYNOPTICS>";
		}
		if (display == "EICAS_SYN") {
			title = "EICAS SYNOPTICS";
			line1l = "<ELEC";
			line1r = "HYD>";
			line2l = "<ECS";
			line2r = "DOORS>";
			line5l = "<CANC";
			line5r = "RCL>";
			line6r = "MODES>";
		}
		if (display == "FIX_INFO") {
			title = "FIX INFO";
			line1l = sprintf("%3.2f", getprop("/instrumentation/nav[0]/frequencies/selected-mhz-fmt"));
			line1r = sprintf("%3.2f", getprop("/instrumentation/nav[1]/frequencies/selected-mhz-fmt"));
			line2l = sprintf("%3.2f", getprop("/instrumentation/nav[0]/radials/selected-deg"));
			line2r = sprintf("%3.2f", getprop("/instrumentation/nav[1]/radials/selected-deg"));
			line6l = "<ERASE FIX";
		}
		if (display == "IDENT") {
			title = "IDENT";
			line1lt = "MODEL";
			if (getprop("/instrumentation/cdu/ident/model") != nil){
				line1l = getprop("/instrumentation/cdu/ident/model");
			}
			line1rt = "ENGINES";
			line2lt = "NAV DATA";
			if (getprop("/instrumentation/cdu/ident/engines") != nil){
				line1r = getprop("/instrumentation/cdu/ident/engines");
			}
			line6ct = "----------------------------------------";
			line6l = "<INDEX";
			line6r = "POS INIT>";
		}
		if (display == "INIT_REF") {
			title = "INIT/REF INDEX";
			line1l = "<IDENT";
			line1r = "NAV DATA>";
			line2l = "<POS";
			line3l = "<PERF";
			line4l = "<THRUST LIM";
			line5l = "<TAKEOFF";
			line6l = "<APPROACH";
			line6r = "MAINT>";
		}
		if (display == "MAINT") {
			title = "MAINTENANCE INDEX";
			line1l = "<CROS LOAD";
			line1r = "BITE>";
			line2l = "<PERF FACTORS";
			line3l = "<IRS MONITOR";
			line6l = "<INDEX";
		}
		if (display == "NAV_RAD") {
			title = "NAV RADIO";
			line1lt = "VOR L";
			line1l = sprintf("%3.2f", getprop("/instrumentation/nav[0]/frequencies/selected-mhz-fmt"));
			line1rt = "VOR R";
			line1r = sprintf("%3.2f", getprop("/instrumentation/nav[1]/frequencies/selected-mhz-fmt"));
			line2lt = "CRS";
			line2ct = "RADIAL";
			line2c = sprintf("%3.2f", getprop("/instrumentation/nav[0]/radials/selected-deg"))~"   "~sprintf("%3.2f", getprop("/instrumentation/nav[1]/radials/selected-deg"));
			line2rt = "CRS";
			line3lt = "ADF L";
			line3l = sprintf("%3.2f", getprop("/instrumentation/adf[0]/frequencies/selected-khz"));
			line3rt = "ADF R";
			line3r = sprintf("%3.2f", getprop("/instrumentation/adf[1]/frequencies/selected-khz"));
		}
		if (display == "PERF_INIT") {
			title = "PERF INIT";
			line1lt = "GR WT";
			line1rt = "CRZ ALT";
			line2rt = "COST INDEX";
			line2r = getprop("instrumentation/fmc/COST_INDEX") or " ";
			line2lt = "FUEL";
			line3lt = "ZFW";
			line3rt = "MIN FUEL TEMP";
			line3r = "-37*C";
			line4lt = "RESERVES";
			line4l = getprop("/instrumentation/cdu/RESERVES") or " ";
			line4rt = "CRZ CG";	
			line5rt = "STEP SIZE";
			line5r =  getprop("instrumentation/cdu/StepSize");
			line6ct = "------------------------------------";
			line6l = "<INDEX";
			line6r = "THRUST LIM>";	
			if (getprop("/autopilot/route-manager/cruise/altitude-ft") != nil){
				if(getprop("/autopilot/route-manager/cruise/altitude-ft") == 0){
					line1r = "";
				}else if(getprop("/autopilot/route-manager/cruise/altitude-ft") < 10000){
					line1r = sprintf("%2.0f",getprop("/autopilot/route-manager/cruise/altitude-ft"));
				}else if(getprop("/autopilot/route-manager/cruise/altitude-ft") > 10000){
					line1r = getprop("/autopilot/route-manager/cruise/altitude-FL");
				}
			}
			if (getprop("/sim/flight-model") == "jsb") {
				line1l = sprintf("%3.1f", (getprop("/fdm/jsbsim/inertia/weight-lbs")/1000));
				line2l = sprintf("%3.1f", (getprop("/fdm/jsbsim/propulsion/total-fuel-lbs")/1000));
				line3l = sprintf("%3.1f", (getprop("/fdm/jsbsim/inertia/empty-weight-lbs")/1000));
				
			}
			else if (getprop("/sim/flight-model") == "yasim") {
				line1l = sprintf("%3.1f", (getprop("/yasim/gross-weight-lbs")/1000));
				line2l = sprintf("%3.1f", (getprop("/consumables/fuel/total-fuel-lbs")/1000));
				line4r = decimal2percentage(getprop("/fdm/yasim/cg-x-m") * -0.1);
				yasim_emptyweight = getprop("/yasim/gross-weight-lbs");
				yasim_emptyweight -= getprop("/consumables/fuel/total-fuel-lbs");
				yasim_weights = props.globals.getNode("/sim").getChildren("weight");
				for (i = 0; i < size(yasim_weights); i += 1) {
					yasim_emptyweight -= yasim_weights[i].getChild("weight-lb").getValue();
				}

				line3l = sprintf("%3.1f", yasim_emptyweight/1000);
			}
		}
		if (display == "POS_INIT") {
			title = "POS INIT";
			page = "1/3";
			line1rt = "LAST POS";
			line1r = getLastPos();
			line2lt = "REF AIRPORT";
			var getRefApt = func(){
				var aptA_INIT = getprop("/instrumentation/fmc/ref-airport") or "";
				if (aptA_INIT == ""){
				    setprop("/instrumentation/fmc/gate", " ");
					setprop("/instrumentation/fmc/ref-airport-pos", "");
					return "----";
				}else{
					var refAptLat = airportinfo(aptA_INIT).lat;
					var refAptLon = airportinfo(aptA_INIT).lon;
					var refAptPosStr = latdeg2latDMM(refAptLat)~" "~londeg2lonDMM(refAptLon);
					setprop("/instrumentation/fmc/gate", "-----");
					setprop("/instrumentation/fmc/ref-airport-pos", refAptPosStr);
					return aptA_INIT;
				}
			}
			var line2ltmp = call(func getRefApt(), nil, var err = []);
			if (size(err)){
				setprop("/instrumentation/fmc/ref-airport", "");
				setprop("/instrumentation/cdu/input", "NOT IN DATABASE");
			}else{
				line2l = line2ltmp;
			}
			line2r = getprop("/instrumentation/fmc/ref-airport-pos");
			line3lt = "GATE";
			line3l = getprop("/instrumentation/fmc/gate");
			line4rt = "GPS POS";
			line4r = getGpsPos();
			line4lt = "UTC";
			if(getprop("/instrumentation/clock/indicated-hour") < 10){
				if(getprop("/instrumentation/clock/indicated-min") < 10){
					line4l = "0"~getprop("/instrumentation/clock/indicated-hour")~"0"~getprop("/instrumentation/clock/indicated-min")~"z";
				}else{
					line4l = "0"~getprop("/instrumentation/clock/indicated-hour")~getprop("/instrumentation/clock/indicated-min")~"z";
				}
			}else if(getprop("/instrumentation/clock/indicated-min") < 10){
				line4l = getprop("/instrumentation/clock/indicated-hour")~"0"~getprop("/instrumentation/clock/indicated-min")~"z";
			}else{
				line4l = getprop("/instrumentation/clock/indicated-hour")~getprop("/instrumentation/clock/indicated-min")~"z";
			}
			line5rt = "SET INERTIAL POS";
			if (getprop("/instrumentation/fmc/isInputedPos") == 1){
				line5r = "";
			}else{
				line5r = "   *  .    *  . ";
			}

			line6ct = "----------------------------------------";
			line6l = "<INDEX";
			line6r = "ROUTE>";
		}
		if (display == "POS_REF_0") {
			title = "POS REF";
			page = "2/3";
			line1lt = "FMC(GPS)";
			line1ct = "ACTUAL";
			line1rt = "UPDATE";
			line1r = isUpdateArm();
			line2lt = "IRS(3)";
			line2ct = "ACTUAL";
			line2rt = "INERTIAL";
			line3lt = "GPS";
			line3ct = "ACTUAL";
			line3rt = "GPS";
			line4lt = "RADIO";
			line4ct = "ACTUAL";
			lien4rt = "RADIO";
			line5lt = "RNP/ACTUAL";
			line5l = "1.00/0.10";
			line5rt = "DME DME";
			line1l = echoLatBrg();
			line2l = echoLatBrg();
			line3l = echoLatBrg();
			line4l = echoLatBrg();
			line2r = echoUpdateArmed();
			line3r = echoUpdateArmed();
			line4r = echoUpdateArmed();
			line6ct = "----------------------------------------";
			line6l = "<INDEX";
			line6r = DisplayLATorBRG();
			
		}
		if (display == "POS_REF") {
			title = "POS REF";
			page = "3/3";
			line1lt = "GPS L";
			line1rt = "GS";	
			line1l = echoLatBrg();
			line1r = sprintf("%3.0f", getprop("/velocities/groundspeed-kt"));
			line2lt = "GPS C";
			line2rt = "GS";	
			line2l = echoLatBrg();
			line2r = sprintf("%3.0f", getprop("/velocities/groundspeed-kt"));
			line3lt = "FMC L (PRI)";
			line3rt = "GS";	
			line3r = sprintf("%3.0f", getprop("/velocities/groundspeed-kt"));
			line4lt = "FMC R";
			line4rt = "GS";	
			line4r = sprintf("%3.0f", getprop("/velocities/groundspeed-kt"));
			line3l = echoLatBrg();
			line3r = sprintf("%3.0f", getprop("/velocities/groundspeed-kt"));
			line6ct = "------------------------------------------";
			line6l = "<INDEX";
			line6r = DisplayLATorBRG();
		}
		if (display == "RTE1_1") {
			title = "RTE 1";
			page = "1/2";
			line1lt = "ORIGIN";
			if (getprop("/autopilot/route-manager/departure/airport") != nil){
				line1l = getprop("/autopilot/route-manager/departure/airport");
			}
			line1rt = "DEST";
			if (getprop("/autopilot/route-manager/destination/airport") != nil){
				line1r = getprop("/autopilot/route-manager/destination/airport");
			}
			line2lt = "RUNWAY";
			if (getprop("/autopilot/route-manager/departure/newrunway") != nil){
				line2l = getprop("/autopilot/route-manager/departure/newrunway");
			}else{
				if (getprop("/autopilot/route-manager/departure/runway") != nil){
							line2l = getprop("/autopilot/route-manager/departure/runway");
				}
			}
			line2rt = "FLT NO";
			line2r = getprop("/instrumentation/fmc/flight-number") or " ";
			line3rt = "CO ROUTE";
			line5l = "<RTE COPY";
			line6l = "<RTE 2";
			line6r = "ACTIVATE>";
		}
		if (display == "RTE1_2") {
			title = "RTE 1";
			page = "2/2";
			line1lt = "VIA";
			line1rt = "TO";
			if (getprop("/autopilot/route-manager/route/wp[1]/id") != nil){
				line1r = getprop("/autopilot/route-manager/route/wp[1]/id");
				}
			if (getprop("/autopilot/route-manager/route/wp[2]/id") != nil){
				line2r = getprop("/autopilot/route-manager/route/wp[2]/id");
				}
			if (getprop("/autopilot/route-manager/route/wp[3]/id") != nil){
				line3r = getprop("/autopilot/route-manager/route/wp[3]/id");
				}
			if (getprop("/autopilot/route-manager/route/wp[4]/id") != nil){
				line4r = getprop("/autopilot/route-manager/route/wp[4]/id");
				}
			if (getprop("/autopilot/route-manager/route/wp[5]/id") != nil){
				line5r = getprop("/autopilot/route-manager/route/wp[5]/id");
				}
			line6l = "<RTE 2";
			line6r = "ACTIVATE>";
		}
		if (display == "RTE1_ARR") {
			if (getprop("/autopilot/route-manager/destination/airport") != nil){
				title = getprop("/autopilot/route-manager/destination/airport")~" ARRIVALS";
			}
			else{
				title = "ARRIVALS";
			}
			line1lt = "STARS";
			line1rt = "APPROACHES";
			if (getprop("/autopilot/route-manager/destination/runway") != nil){
				line1r = getprop("/autopilot/route-manager/destination/runway");
			}
			line2lt = "TRANS";
			line3rt = "RUNWAYS";
			line6l = "<INDEX";
			line6r = "ROUTE>";
		}
		if (display == "RTE1_DEP") {
				if(getprop("/autopilot/route-manager/isChanged") == 0){
					var selOrAct = "<ACT>";
				    line6l = "<INDEX";
				}else{
					var selOrAct = "<SEL>";
					line6l = "<ERASE";
				}
			if (getprop("/autopilot/route-manager/departure/airport") != nil){
				title = getprop("/autopilot/route-manager/departure/airport")~" DEPARTURES";
			}
			else{
				title = "DEPARTURES";
			}
			line1ctl = "RTE 1";
			line1lt = "SIDS";
			
			if(getprop("/instrumentation/cdu/sids/sidIsSelected") == 0){
				line1cl = "";
				if(getprop("/instrumentation/cdu/sids/rwyIsSelected") == 0){
					line1l = echoSids(getprop("/instrumentation/cdu/sids/page"))[0];
					line2l = echoSids(getprop("/instrumentation/cdu/sids/page"))[1];
					line3l = echoSids(getprop("/instrumentation/cdu/sids/page"))[2];
					line4l = echoSids(getprop("/instrumentation/cdu/sids/page"))[3];
					line5l = echoSids(getprop("/instrumentation/cdu/sids/page"))[4];
				}else{
					line1l = echoSids(getprop("/instrumentation/cdu/sids/page"), getprop("/autopilot/route-manager/departure/newrunway"))[0];
					line2l = echoSids(getprop("/instrumentation/cdu/sids/page"), getprop("/autopilot/route-manager/departure/newrunway"))[1];
					line3l = echoSids(getprop("/instrumentation/cdu/sids/page"), getprop("/autopilot/route-manager/departure/newrunway"))[2];
					line4l = echoSids(getprop("/instrumentation/cdu/sids/page"), getprop("/autopilot/route-manager/departure/newrunway"))[3];
					line5l = echoSids(getprop("/instrumentation/cdu/sids/page"), getprop("/autopilot/route-manager/departure/newrunway"))[4];
				}
			}else{
				line1cl = selOrAct;
				line1l = getprop("/autopilot/route-manager/departure/sidID"); 
				line2l = "";
				line3l = "";
				line4l = "";
				line5l = "";
			}
			
			if (getprop("/autopilot/route-manager/departure/newrunway") == ""){
				setprop("/instrumentation/cdu/sids/rwyIsSelected", 0);
				setprop("/instrumentation/cdu/sids/sidIsSelected", 0);
				setprop("/autopilot/route-manager/departure/sidID", "");
				setprop("/autopilot/route-manager/departure/newsid", "");
			}else{
				if(getprop("/instrumentation/cdu/sids/rwyIsSelected") == 0){
					if(getprop("/instrumentation/cdu/output/line1/right") == getprop("/autopilot/route-manager/departure/newrunway")){
						line1cr = selOrAct;
					}else if(getprop("/instrumentation/cdu/output/line2/right") == getprop("/autopilot/route-manager/departure/newrunway")){
						line2cr = selOrAct;
					}else if(getprop("/instrumentation/cdu/output/line3/right") == getprop("/autopilot/route-manager/departure/newrunway")){
						line3cr = selOrAct;
					}else if(getprop("/instrumentation/cdu/output/line4/right") == getprop("/autopilot/route-manager/departure/newrunway")){
						line4cr = selOrAct;
					}else if(getprop("/instrumentation/cdu/output/line5/right") == getprop("/autopilot/route-manager/departure/newrunway")){
						line5cr = selOrAct;
					}
				}
			}
			
			if(getprop("/instrumentation/cdu/sids/rwyIsSelected") == 0){
				line1cr = "";
				line1r = echoRwys(getprop("/instrumentation/cdu/sids/page"))[0];
				line2r = echoRwys(getprop("/instrumentation/cdu/sids/page"))[1];
				line3r = echoRwys(getprop("/instrumentation/cdu/sids/page"))[2];
				line4r = echoRwys(getprop("/instrumentation/cdu/sids/page"))[3];
				line5r = echoRwys(getprop("/instrumentation/cdu/sids/page"))[4];
			}else{
				line1cr = selOrAct;
				line1r = getprop("/autopilot/route-manager/departure/newrunway"); 
				line2r = "";
				line3r = "";
				line4r = "";
				line5r = "";
			}
			line6ct = "----------------------------------------";
			line1rt = "RUNWAYS";
			#if (getprop("/autopilot/route-manager/departure/newrunway") != nil){
			#	line1r = getprop("/autopilot/route-manager/departure/newrunway");
			#}
			#line2lt = "TRANS";
			#if(getprop("/autopilot/route-manager/departure/newsid") != nil){
			#	line6l = "<ERASE";
			#}else{
			#	line6l = "<INDEX";
			#}
			line6r = "ROUTE>";
		}
		if (display == "RTE1_LEGS") {
			if (getprop("/autopilot/route-manager/active") == 0){
				title = "ACT RTE 1 LEGS";
				}
			else {
				title = "RTE 1 LEGS";
				}
			if (getprop("/autopilot/route-manager/route/wp[1]/id") != nil){
				line1lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[1]/leg-bearing-true-deg"));
				line1l = getprop("/autopilot/route-manager/route/wp[1]/id");
				line2ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[1]/leg-distance-nm"))~" NM";
				line1r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[1]/altitude-ft"));
				if (getprop("/autopilot/route-manager/route/wp[1]/speed-kts") != nil){
					line4r = getprop("/autopilot/route-manager/route/wp[1]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[1]/altitude-ft"));
					}
				}
			if (getprop("/autopilot/route-manager/route/wp[2]/id") != nil){
				if (getprop("/autopilot/route-manager/route/wp[2]/leg-bearing-true-deg") != nil){
					line2lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[2]/leg-bearing-true-deg"));
				}
				line2l = getprop("/autopilot/route-manager/route/wp[2]/id");
				if (getprop("/autopilot/route-manager/route/wp[2]/leg-distance-nm") != nil){
					line3ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[2]/leg-distance-nm"))~" NM";
				}
				line2r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[2]/altitude-ft"));
				if (getprop("/autopilot/route-manager/route/wp[2]/speed-kts") != nil){
					line4r = getprop("/autopilot/route-manager/route/wp[2]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[2]/altitude-ft"));
					}
				}
			if (getprop("/autopilot/route-manager/route/wp[3]/id") != nil){
				if (getprop("/autopilot/route-manager/route/wp[3]/leg-bearing-true-deg") != nil){
					line3lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[3]/leg-bearing-true-deg"));
				}
				line3l = getprop("/autopilot/route-manager/route/wp[3]/id");
				if (getprop("/autopilot/route-manager/route/wp[3]/leg-distance-nm") != nil){
					line4ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[3]/leg-distance-nm"))~" NM";
				}
				line3r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[3]/altitude-ft"));
				if (getprop("/autopilot/route-manager/route/wp[3]/speed-kts") != nil){
					line3r = getprop("/autopilot/route-manager/route/wp[3]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[3]/altitude-ft"));;
					}
				}
			if (getprop("/autopilot/route-manager/route/wp[4]/id") != nil){
				if (getprop("/autopilot/route-manager/route/wp[4]/leg-bearing-true-deg") != nil){
					line4lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[4]/leg-bearing-true-deg"));
				}
				line4l = getprop("/autopilot/route-manager/route/wp[4]/id");
				if (getprop("/autopilot/route-manager/route/wp[4]/leg-distance-nm") != nil){
					line5ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[4]/leg-distance-nm"))~" NM";
				}
				line4r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[4]/altitude-ft"));
				if (getprop("/autopilot/route-manager/route/wp[4]/speed-kts") != nil){
					line4r = getprop("/autopilot/route-manager/route/wp[4]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[4]/altitude-ft"));
					}
				}
			if (getprop("/autopilot/route-manager/route/wp[5]/id") != nil){
				if (getprop("/autopilot/route-manager/route/wp[5]/leg-bearing-true-deg") != nil){
					line5lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp[5]/leg-bearing-true-deg"));
				}
				line5l = getprop("/autopilot/route-manager/route/wp[5]/id");
				line5r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[5]/altitude-ft"));
				if (getprop("/autopilot/route-manager/route/wp[5]/speed-kts") != nil){
					line4r = getprop("/autopilot/route-manager/route/wp[5]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp[5]/altitude-ft"));
					}
				}
			line6l = "<RTE 2 LEGS";
			if (getprop("/autopilot/route-manager/active") == 1){
				line6r = "RTE DATA>";
				}
			else{
				line6r = "ACTIVATE>";
				}
		}
		if (display == "THR_LIM") {
			title = "THRUST LIM";
			line1lt = "SEL";
			line1ct = "OAT";
			line1c = sprintf("%2.0f", getprop("/environment/temperature-degc"))~"*c";
			line1rt = "TO 1 N1";
			line2l = "<TO";
			line2r = "CLB>";
			line3lt = "TO 1";
			line3l = "<-10%";
			line3r = "CLB 1>";
			line4lt = "TO 2";
			line4l = "<-20%";
			line4r = "CLB 2>";
			line6l = "<INDEX";
			line6r = "TAKEOFF>";
			if (getprop("/instrumentation/fmc/THRLIM") == "TOGA"){line2cl = "<SEL>";}
			else if (getprop("/instrumentation/fmc/THRLIM") == "TO-1"){line3cl = "<SEL>";}
			else if (getprop("/instrumentation/fmc/THRLIM") == "TO-2"){line4cl = "<SEL>";}
			if (getprop("/instrumentation/fmc/CLB_LIM") == "CLB"){line2cr = "<SEL>";}
			else if (getprop("/instrumentation/fmc/CLB_LIM") == "CLB-1"){line3cr = "<SEL>";}
			else if (getprop("/instrumentation/fmc/CLB_LIM") == "CLB-2"){line4cr = "<SEL>";}
		}
		if (display == "TO_REF") {
			title = "TAKEOFF REF";
			page = "1/2";
			line1lt = "FLAPS";
			if(getprop("/instrumentation/fmc/isCustomizeFlaps") != 1){
				line1ls = sprintf("%2.0f", getprop("/instrumentation/fmc/to-flap"));			
			}else{line1l = sprintf("%2.0f", getprop("/instrumentation/fmc/to-flap"));}
			line2lt = "THRUST";
			line3lt = "CG";
			line1cr = sprintf("%3.0f", getprop("/instrumentation/fmc/vspeeds/V1")) or "---";
			line2cr = sprintf("%3.0f", getprop("/instrumentation/fmc/vspeeds/VR")) or "---";
			line3cr = sprintf("%3.0f", getprop("/instrumentation/fmc/vspeeds/V2")) or "---";
			line4lt = "RWY/POS";
			line4ct = "GR WT";
			line4c =  sprintf("%3.1f", (getprop("/yasim/gross-weight-lbs")/1000));
			if (getprop("/autopilot/route-manager/departure/runway") == nil){
				line4l = "--/--";
			}
			else{
				line4l = getprop("/autopilot/route-manager/departure/runway") ~"/--" #will add the runway status at sooooooooooooon	
			}
			line6ct = "----------------------------------------";
			line6l = "<INDEX";
			line6r = "POS INIT>";
		}
		if (display == "TO_REF_2"){
			title = "TAKEOFF REF UPLINK";
			line1rt = "EO ACCEL HT";
			line1r = sprintf("%3.0f",getprop("/fmc/EoAccelHT"));
			line2rt = "ACCEL HT";
			line2r = sprintf("%3.0f",getprop("/fmc/AccelHT"));
			line3rt = "THE REDUCTION";
			line3r = sprintf("%3.0f",getprop("/fmc/Reduction"));
			line2lt = "ALTN THRUST";
			line2l = "<TO";
			line3lt = "WIND";
			line3l = "---*/---KT";
			line4lt = "RWY WIND";
			line4rt = "LIM TOGW";
			line5lt = "SLOPE";
			line5rt = "REF OAT";
			line6ct = "----------------------------------------";
			line6l = "<INDEX";
			if (getprop("/fmc/ref-temperature-degc") == -999){line5r = "---*C";}else{line5r = getprop("/fmc/ref-temperature-degc")}
		}
		
		if (serviceable != 1){
			title = "";		page = "";
			line1l = "";	line2l = "";	line3l = "";	line4l = "";	line5l = "";	line6l = "";
			line1lt = "";	line2lt = "";	line3lt = "";	line4lt = "";	line5lt = "";	line6lt = "";
			line1c = "";	line2c = "";	line3c = "";	line4c = "";	line5c = "";	line6c = "";
			line1ct = "";	line2ct = "";	line3ct = "";	line4ct = "";	line5ct = "";	line6ct = "";
			line1r = "";	line2r = "";	line3r = "";	line4r = "";	line5r = "";	line6r = "";
			line1rt = "";	line2rt = "";	line3rt = "";	line4rt = "";	line5rt = "";	line6rt = "";
			line1ctl = "";
			
			line1cl = ""; 
			line1cr = "";
			line2cl = "";
			line2cr = "";
			line3cl = "";
			line3cr = "";
			line4cl = "";
			line4cr = "";
			line5cr = "";
			line5cl = "";
			line6cr = "";
			line6cl = "";
		}
		
		setprop("/instrumentation/cdu/output/title",title);
		setprop("/instrumentation/cdu/output/page",page);
		setprop("/instrumentation/cdu/output/line1/left",line1l);
		setprop("/instrumentation/cdu/output/line2/left",line2l);
		setprop("/instrumentation/cdu/output/line3/left",line3l);
		setprop("/instrumentation/cdu/output/line4/left",line4l);
		setprop("/instrumentation/cdu/output/line5/left",line5l);
		setprop("/instrumentation/cdu/output/line6/left",line6l);
		setprop("/instrumentation/cdu/output/line1/left-title",line1lt);
		setprop("/instrumentation/cdu/output/line2/left-title",line2lt);
		setprop("/instrumentation/cdu/output/line3/left-title",line3lt);
		setprop("/instrumentation/cdu/output/line4/left-title",line4lt);
		setprop("/instrumentation/cdu/output/line5/left-title",line5lt);
		setprop("/instrumentation/cdu/output/line6/left-title",line6lt);
		setprop("/instrumentation/cdu/output/line1/center",line1c);
		setprop("/instrumentation/cdu/output/line2/center",line2c);
		setprop("/instrumentation/cdu/output/line3/center",line3c);
		setprop("/instrumentation/cdu/output/line4/center",line4c);
		setprop("/instrumentation/cdu/output/line5/center",line5c);
		setprop("/instrumentation/cdu/output/line6/center",line6c);
		setprop("/instrumentation/cdu/output/line1/center-left",line1cl);
		setprop("/instrumentation/cdu/output/line2/center-left",line2cl);
		setprop("/instrumentation/cdu/output/line3/center-left",line3cl);
		setprop("/instrumentation/cdu/output/line4/center-left",line4cl);
		setprop("/instrumentation/cdu/output/line5/center-left",line5cl);
		setprop("/instrumentation/cdu/output/line6/center-left",line6cl);
		setprop("/instrumentation/cdu/output/line1/center-right",line1cr);
		setprop("/instrumentation/cdu/output/line2/center-right",line2cr);
		setprop("/instrumentation/cdu/output/line3/center-right",line3cr);
		setprop("/instrumentation/cdu/output/line4/center-right",line4cr);
		setprop("/instrumentation/cdu/output/line5/center-right",line5cr);
		setprop("/instrumentation/cdu/output/line6/center-right",line6cr);
		setprop("/instrumentation/cdu/output/line1/center-title",line1ct);
		setprop("/instrumentation/cdu/output/line2/center-title",line2ct);
		setprop("/instrumentation/cdu/output/line3/center-title",line3ct);
		setprop("/instrumentation/cdu/output/line4/center-title",line4ct);
		setprop("/instrumentation/cdu/output/line5/center-title",line5ct);
		setprop("/instrumentation/cdu/output/line6/center-title",line6ct);
		setprop("/instrumentation/cdu/output/line1/right",line1r);
		setprop("/instrumentation/cdu/output/line2/right",line2r);
		setprop("/instrumentation/cdu/output/line3/right",line3r);
		setprop("/instrumentation/cdu/output/line4/right",line4r);
		setprop("/instrumentation/cdu/output/line5/right",line5r);
		setprop("/instrumentation/cdu/output/line6/right",line6r);
		setprop("/instrumentation/cdu/output/line1/right-title",line1rt);
		setprop("/instrumentation/cdu/output/line2/right-title",line2rt);
		setprop("/instrumentation/cdu/output/line3/right-title",line3rt);
		setprop("/instrumentation/cdu/output/line4/right-title",line4rt);
		setprop("/instrumentation/cdu/output/line5/right-title",line5rt);
		setprop("/instrumentation/cdu/output/line6/right-title",line6rt);
		setprop("/instrumentation/cdu/output/line1/center-title-large",line1ctl);
		setprop("/instrumentation/cdu/output/line2/center-title-large",line3ctl);
		setprop("/instrumentation/cdu/output/line3/center-title-large",line3ctl);
		setprop("/instrumentation/cdu/output/line4/center-title-large",line4ctl);
		setprop("/instrumentation/cdu/output/line5/center-title-large",line5ctl);
		setprop("/instrumentation/cdu/output/line6/center-title-large",line6ctl);
		setprop("/instrumentation/cdu/output/line1/left-small",line1ls);
		setprop("/instrumentation/cdu/output/line2/left-small",line2ls);
		setprop("/instrumentation/cdu/output/line3/left-small",line3ls);
		setprop("/instrumentation/cdu/output/line4/left-small",line4ls);
		setprop("/instrumentation/cdu/output/line5/left-small",line5ls);
		setprop("/instrumentation/cdu/output/line6/left-small",line6ls);
		setprop("/instrumentation/cdu/output/line1/right-small",line1rs);
		setprop("/instrumentation/cdu/output/line2/right-small",line2rs);
		setprop("/instrumentation/cdu/output/line3/right-small",line3rs);
		setprop("/instrumentation/cdu/output/line4/right-small",line4rs);
		setprop("/instrumentation/cdu/output/line1/right-small",line1rs);
		setprop("/instrumentation/cdu/output/line5/right-small",line5rs);
		setprop("/instrumentation/cdu/output/line6/right-small",line6rs);
		settimer(cdu,0.2);
}

_setlistener("/sim/signals/fdm-initialized", cdu); 