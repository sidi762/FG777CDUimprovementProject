#GE90-110B1 Data
var weight_GE90110B1 = [360, 340, 320, 300, 280, 260, 240, 220, 200, 180, 160, 140];
var V1_GE90110B1 = [169, 164, 158, 152, 146, 139, 131, 122, 113, 102, 91, 83];
var VR_GE90110B1 = [176, 170, 165, 158, 152, 145, 138, 131, 123, 115, 106, 97];
var V2_GE90110B1 = [180, 176, 171, 166, 161, 156, 151, 145, 139, 133, 126, 119];
var VSPEED_GE90110B1 = [weight_GE90110B1, V1_GE90110B1, VR_GE90110B1, V2_GE90110B1];

#V1,VR and V2 Adjustment
var tempC_GE90110B1 = [70,60,50,40,30,20,-60];
var h02000V1Adj_GE90110B1 = [12,8,4,1,0,0,0];
var h0V1Adj_GE90110B1 = [14,10,5,2,0,0,0];
var h2000V1Adj_GE90110B1 = [1000,12,8,4,1,1,1];
var h4000V1Adj_GE90110B1 = [1000,15,10,7,4,3,3];
var h6000V1Adj_GE90110B1 = [1000,1000,13,10,7,5,5];
var h8000V1Adj_GE90110B1 = [1000,1000,17,14,11,9,7];
var V1Adjust_GE90110B1 = [tempC_GE90110B1, h02000V1Adj_GE90110B1, h0V1Adj_GE90110B1, h2000V1Adj_GE90110B1, h4000V1Adj_GE90110B1, h6000V1Adj_GE90110B1, h8000V1Adj_GE90110B1];

var h02000VrAdj_GE90110B1 = [6,4,2,0,0,0,0];
var h0VrAdj_GE90110B1 = [7,5,3,1,0,0,0];
var h2000VrAdj_GE90110B1 = [1000,6,4,3,1,1,1];
var h4000VrAdj_GE90110B1 = [1000,7,6,4,3,2,2];
var h6000VrAdj_GE90110B1 = [1000,1000,7,5,4,3,3];
var h8000VrAdj_GE90110B1 = [1000,1000,8,7,6,5,4];
var VrAdjust_GE90110B1 = [tempC_GE90110B1, h02000VrAdj_GE90110B1, h0VrAdj_GE90110B1, h2000VrAdj_GE90110B1, h4000VrAdj_GE90110B1, h6000VrAdj_GE90110B1, h8000VrAdj_GE90110B1];

var h02000V2Adj_GE90110B1 = [-3,-2,-1,0,0,0,0];
var h0V2Adj_GE90110B1 = [-3,-2,-1,-1,0,0,0];
var h2000V2Adj_GE90110B1 = [1000,-3,-2,-1,0,0,0];
var h4000V2Adj_GE90110B1 = [1000,-3,-2,-2,-1,-1,-1];
var h6000V2Adj_GE90110B1 = [1000,1000,-3,-2,-1,-1,-1];
var h8000V2Adj_GE90110B1 = [1000,1000,-4,-3,-2,-2,-1];
var V2Adjust_GE90110B1 = [tempC_GE90110B1, h02000V2Adj_GE90110B1, h0V2Adj_GE90110B1, h2000V2Adj_GE90110B1, h4000V2Adj_GE90110B1, h6000V2Adj_GE90110B1, h8000V2Adj_GE90110B1];

var getVSpeeds = func(eng){
	if(eng == "GE90-110B1"){
		getGE90110B1VSpeeds();
	}
}
var getGE90110B1VSpeeds = func(){
	var tmpWeight = getprop("/fdm/yasim/gross-weight-lbs") * 0.4535924 * 0.0001;
	var weightForCal = 10 * sprintf("%2.0f",tmpWeight);
	var V1 = 0;
	var Vr = 0;
	var V2 = 0;
	for(var i = 0; i <= 11; i+=1){
		if(VSPEED_GE90110B1[0][i] == weightForCal){
			V1 = VSPEED_GE90110B1[1][i];
			Vr = VSPEED_GE90110B1[2][i];
			V2 = VSPEED_GE90110B1[3][i];
			print(V1~" "~Vr~" "~V2);
		}
	}
	if(V1 == 0){
		print("V SPEEDS UNAVAILABLE");
	}else if(V2 == 0){
		print("V SPEEDS UNAVAILABLE");
	}else if(Vr == 0){
		print("V SPEEDS UNAVAILABLE");
	}

	var outTempC = getprop("/environment/temperature-degc");
	var alt = getprop("/position/altitude-ft");
	var tempCForCal = 10 * sprintf("%1.0f", (sprintf("%1.0f",outTempC) * 0.1));
	var altForCal = 2000 * sprintf("%1.0f",alt/2000);
	if(altForCal > 8000){
		altForCal = 8000;
	}else if(altForCal < -2000){
		altForCal = -2000;
	}
	var altJ = (altForCal / 2000) + 2;
	if(tempCForCal < 20){
		tempCForCal = -60;
	}else if(tempCForCal > 70){
		tempCForCal = 70;
	}
	print(tempCForCal);
	var V1Adj = 0;
	var V2Adj = 0;
	var VrAdj = 0;
	for(var i = 0; i <= 6; i+=1){
		if(V1Adjust_GE90110B1[0][i] == tempCForCal){
				V1Adj = V1Adjust_GE90110B1[altJ][i];
		}
		if(VrAdjust_GE90110B1[0][i] == tempCForCal){
				VrAdj = VrAdjust_GE90110B1[altJ][i];
		}
		if(V2Adjust_GE90110B1[0][i] == tempCForCal){
				V2Adj = V2Adjust_GE90110B1[altJ][i];
		}
	}
	print(V1Adj ~ " " ~ VrAdj ~ " " ~ V2Adj);
	if(V1Adj == 1000){
		print("V SPEEDS UNAVAILABLE");
	}else if(V2Adj == 1000){
		print("V SPEEDS UNAVAILABLE");
	}else if(VrAdj == 1000){
		print("V SPEEDS UNAVAILABLE");
	}
	V1 = V1 + V1Adj;
	Vr = Vr + VrAdj;
	V2 = V2 + V2Adj;
	if(V1 > Vr){
		V1 = Vr;
	}
	print(V1~" "~Vr~" "~V2);
}

