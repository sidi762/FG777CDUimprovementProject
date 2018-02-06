###################################################
## This is the calculation for Boeing 737 series ##
############### by Sidi Liang #####################
###################################################

var grossweight777lbstree = "fdm/yasim/gross-weight-lbs";
var fdragtree = "fdm/yasim/forces/f-x-drag";
var flifttree = "fdm/yasim/forces/f-z-lift";
var accelerationtree = "fdm/yasim/accelerations/a-x";
var pitchdegtree = "orientation/pitch-deg";
var perfData = {
	pAir : 1.29,#kg/m^2
	flift:getprop(flifttree),#N
	wingArea : 124.58,#m
	nv : 0,
	CL : 0.491,
	CD: 0.0344,
	CDi: 0.0102,
	CD0: 0.0242, #CD0 = CD - CDi
	e : 0.796,
	g : 9.8,
	a : getprop(accelerationtree),
	mass : 42255, #Get it in Property Tree,kg
	AR : 9.45, #Data of 737ng
	#T : (cdu.lbs2kg(getprop(grossweight777lbstree)) * getprop(accelerationtree) + getprop(fdragtree))/math.cos(getprop(pitchdegtree) * D2R), #Get it in Property Tree
	T : cdu.lbs2kg(27300),
};
var calVy = func(){
	var tmp = (perfData.T * math.pi * perfData.AR * perfData.e)/(perfData.mass * perfData.g);
	var CL = ((perfData.nv + 1) / 2) * tmp * math.sqrt(((((perfData.nv + 1) * (perfData.nv + 1))/4) * tmp * tmp) + 3 * perfData.CD0 * math.pi * perfData.AR * perfData.e); 
	print(CL);
	print(perfData.T);
	var VyTASkts = math.sqrt(perfData.flift / CL * perfData.pAir * perfData.wingArea * 0.5) * 0.51444;
	print(VyTASkts);
}
calVy();