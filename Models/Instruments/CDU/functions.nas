var getRwyOfSids = func(sidID){
	var apt = airportinfo(getprop("/autopilot/route-manager/departure/airport"));
	var allRwys = keys(apt.runways);
	if(sidID != "DEFAULT"){
		var rwysCount = size(allRwys);
		for(var i = 0; i < rwysCount; i+=1){
			var allSids = apt.sids(allRwys[i]);
			for(var j = 0; j < size(allSids); j+=1){
				if(sidID == allSids[j]){
					return allRwys[i];
					}
				}
			}
		}else{
			if(getprop("/autopilot/route-manager/departure/newrunway") == ""){
				return allRwys[0];
			}else if(getprop("/autopilot/route-manager/departure/newrunway") == nil){
				return allRwys[0];
			}else{
				return getprop("/autopilot/route-manager/departure/newrunway");
			}
		}
}
var echoSids = func(page,selectedRwy = ""){
	var apt = airportinfo(getprop("/autopilot/route-manager/departure/airport"));
	if(getprop("/autopilot/route-manager/departure/airport") != ""){
		if(selectedRwy != ""){
			var allSids = apt.sids(selectedRwy);
			var defaultNum = 1;
		}else{
			var allSids = apt.sids();
			var defaultNum = size(keys(apt.runways));
		}
		var echoedSids = [];
		var i = 0;
		var sidsNum = size(apt.sids());
		if(sidsNum != 0){
			var countStart = (page - 1) * 5;
			if(countStart > sidsNum){
				setprop("/instrumentation/cdu/sids/page", page - 1);
			}
			count = countStart;
			while(i <= 5){
				if(count < sidsNum){
					append(echoedSids, allSids[count]);
					i = i + 1;
					count = count + 1;
				}else{
					append(echoedSids, "");
					i = i + 1;
				}
			}
		}else{
			var countStart = (page - 1) * 5;
			if(countStart > sidsNum){
				setprop("/instrumentation/cdu/sids/page", page - 1);
			}
			count = countStart;
			while(i <= 5){
				if(count < defaultNum){
					append(echoedSids, "DEFAULT");
					i = i + 1;
					count = count + 1;
				}else{
					append(echoedSids, "");
					i = i + 1;
				}
			}
		}
				return echoedSids;
			}else{
				return ["", "", "", "", ""];
			}
}
var echoRwys = func(pageRwys){
	if(getprop("/autopilot/route-manager/departure/airport") != ""){
		var apt = airportinfo(getprop("/autopilot/route-manager/departure/airport"));
		var allRwys = keys(apt.runways);
		var echoedRwys = [];
		var rwysCount = size(allRwys);
	
		    var countStart = (pageRwys - 1) * 5;
			var count = countStart;
			var i = 0;
			while(i <= 5){
				if(count < rwysCount){
					append(echoedRwys, allRwys[count]);
					i = i + 1;
					count = count + 1;
				}else{
						append(echoedRwys, "");
						i = i + 1;
				}
			}
				return echoedRwys;
		}else{
			return ["", "", "", "", ""];
		}
}

var getIRSPos = func(cduInputedPos){
 
 	call(func inputPosLatConversion(cduInputedPos), nil, var err = []);
	if(size(err)){
		setprop("/instrumentation/cdu/input", "INVALID ENTRY");
	}else{
		setprop("/instrumentation/fmc/inertialposlat", inputPosLatConversion(cduInputedPos));
	}
	
	call(func inputPosLonConversion(cduInputedPos), nil, var err1 = []);
	if(size(err1)){
		setprop("/instrumentation/cdu/input", "INVALID ENTRY");
	}else{
		setprop("/instrumentation/fmc/inertialposlon", inputPosLonConversion(cduInputedPos));
	}
	setprop("/instrumentation/fmc/inertialpos", latdeg2latDMM(getprop("/instrumentation/fmc/inertialposlat"))~" "~londeg2lonDMM(getprop("/instrumentation/fmc/inertialposlon")));
}
var getGpsPos = func(){
	var gpsPosGot = latdeg2latDMM(getprop("/position/latitude-deg"))~" "~londeg2lonDMM(getprop("/position/longitude-deg"));
	setprop("/instrumentation/fmc/gpspos", gpsPosGot);
	setprop("/instrumentation/fmc/gpsposlat", getprop("/position/latitude-deg"));
	setprop("/instrumentation/fmc/gpsposlon", getprop("/position/longitude-deg"));
	return gpsPosGot;
}
var getLastPos = func(){
	setprop("/instrumentation/fmc/lastposlat", getprop("/position/latitude-deg"));
	setprop("/instrumentation/fmc/lastposlon", getprop("/position/longitude-deg"));
	var lastPosGot = latdeg2latDMM(getprop("/position/latitude-deg"))~" "~londeg2lonDMM(getprop("/position/longitude-deg"));
	setprop("/instrumentation/fmc/lastpos", lastPosGot);
	return lastPosGot;
}
var execPushed = func(){
	if(getprop("/autopilot/route-manager/isArmed") == 1){
		setprop("/autopilot/route-manager/isChanged",0);
		setprop("/autopilot/route-manager/input","@ACTIVATE");
		setprop("/autopilot/route-manager/isArmed", -1);
	}
}
var sidNextPge = func(){
	var tmp = getprop("/instrumentation/cdu/sids/page");
	tmp = tmp + 1;
	setprop("/instrumentation/cdu/sids/page", tmp);
}
var sidPrevPge = func(){
	var tmp = getprop("/instrumentation/cdu/sids/page");
	if(tmp - 1 >= 1){
		tmp = tmp - 1;
	}
	setprop("/instrumentation/cdu/sids/page", tmp);
}
var DisplayLATorBRG = func(){
	if (getprop("/instrumentation/cdu/LATorBRG") == 0){
		return "LAT/LON>";
	}
	else{
		return "BRG/DIST>";
	}
}
var echoLatBrg = func(){
	if(getprop("/instrumentation/cdu/LATorBRG") == 1){
		return "000*/0.0NM";
	}
	else if(getprop("/instrumentation/cdu/LATorBRG") == 0){
		return getGpsPos();
	}
}