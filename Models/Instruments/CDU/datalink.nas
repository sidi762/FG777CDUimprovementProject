var serviceable = 1;

if (serviceable == 1){

	var ground = {
		
		ident : 0,
		
		new: func(id) { return { parents:[ground], ident: id}; },
		data : ["Comm Success"],
		dataName: ["testMessage"],
		errorMessage : "Error",
		
		uplink : func(key,target){
			transmit(key, "uplink",me.ident,target);
		},
		downlinkReceived: func(key,from){
			append(me.data, from.data[findInArray(from.dataName, key)]);
			append(me.dataName, from.dataName[findInArray(from.dataName, key)]);
			print("DownlinkReceived, "~from.dataName[findInArray(from.dataName, key)]~" is "~from.data[findInArray(from.dataName, key)]);
		},
		requestReceived : func(key,from){
				onBoard.requestState = "DATALINK REQUEST SENT"; 
				print(onBoard.requestState);
				me.requestRespond(key,from);
		},
		requestRespond : func(key, to){
			if(findInArray(me.dataName,key) != "NOT FOUND"){
				me.uplink(findInArray(me.dataName,key),to);
			}else{
				print(me.errorMessage);
			}
		},
		getWXR : func(apt){	#apt is the ICAO(4 digit)code for the airport
			http.save("https://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&stationString="~apt~"&hoursBeforeNow=1", getprop('/sim/fg-home') ~ '/Export/METAR.xml')
			    .fail(func print("Download failed!"))
			    .done(func(r) processMETAR(r));
		}
	};
	
	var onBoard = {
		
		ident : 0,
		
		states : "NO COMM",
		
		new: func(id) { 
			return { parents:[onBoard], ident: id}; 
		},
		
		data : ["Comm Success by Aircraft"],
		dataName: ["test"],
		errorMessage : "Error",
		
		downlink : func(key,target){
			transmit(key, "downlink",me,target.ident);
		},
		uplinkReceived: func(key,from){
			append(me.data, allGrounds[from].data[key]);
			append(me.dataName, allGrounds[from].dataName[key]);
			print("UplinkReceived, "~allGrounds[from].dataName[key]~" is "~allGrounds[from].data[key]);
			if(me.data[size(me.data)-1] == "Comm Success"){
				me.states = "READY";
			}
		},
		request : func(key,target){
			me.requestState = "DATALINK REQUESTING";
			print(me.requestState);
			transmit(key,"request",me.ident,target.ident);
			
			
		},
		
		testConnection: func(){
			
			me.request("testMessage",allGrounds[0]);
			print("DATALINK COMM TEST STARTED");
			me.states = "NO COMM";
			
		},
		
		requestState: "",
		
	};
	
	var transmit = func(key,tag,planeId,groundId){
		settimer(func(){
			if(tag == "uplink"){
				allAircrafts[planeId].uplinkReceived(key,groundId);
			}else if(tag == "downlink"){
				allGrounds[groundId].downlinkReceived(key,planeId);
			}else if(tag == "request"){
				allGrounds[groundId].requestReceived(key,planeId);
			}
		}, rand()*10);
	}
	
	
	var allAircrafts = [];
	var allGrounds = [];
	var aircraft1 = onBoard.new(0);
	var groundDefault = ground.new(0);
	
	append(allGrounds, groundDefault);
	append(allAircrafts, aircraft1);
	
	#allAircrafts[0].request("testMessage",allGrounds[0]);
	#allAircrafts[0].downlink("test",allGrounds[0]);
	
	var findInArray = func(target, obj){
		for(var i = 0; i < size(target); i+=1){
			if(target[i] == obj){
				return i;
			}
			return "NOT FOUND";
		}
	}
}
var processMETAR = func(r){
	#For datalink wxr request use
	print("Finished request with status: " ~ r.status ~ " " ~ r.reason);
	var path = getprop("/sim/fg-home") ~ '/Export/METAR.xml';
	var data = io.readfile(path);
	var result = "";
	for(var i = 0; i < utf8.size(data)-2; i = i+1){
		if(utf8.chstr(data[i])~utf8.chstr(data[i+1])~utf8.chstr(data[i+2]) == "raw"){
			var metar_j = i+9;
			while(utf8.chstr(data[metar_j]) != "<"){
				result = result~utf8.chstr(data[metar_j]);
				metar_j += 1;
			}
			break;
		}
	}	
	print(result);
	#append(groundDefault.data,result);
	#append(groundDefault.dataName,"wxr");
}