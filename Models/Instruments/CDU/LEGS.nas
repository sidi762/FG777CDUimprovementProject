crtPageNum = getprop("/autopilot/route-manager/route/crtPageNum");
#print(getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/id"));
var turnLEGS = func(move)
{
	if(move == 1){crtPageNum = crtPageNum + 1;}
	else if(move == 0 and crtPageNum != 1){crtPageNum = crtPageNum - 1;}
}
#Display phase
var DisplayLEGS = func()
{
	if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/id") != nil)
	{
		line1lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/leg-bearing-true-deg"));
		line1l = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/id");
		line2ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/leg-distance-nm"))~" NM";
		line1r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/altitude-ft"));
		if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/speed-kts") != nil)
		{
			line1r = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+1)~"]/altitude-ft"));
		}
	}
	if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+2)~"]/id") != nil)
	{
		line2lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+2)~"]/leg-bearing-true-deg"));
		line2l = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+2)~"]/id");
		line3ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+2)~"]/leg-distance-nm"))~" NM";
		line2r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+2)~"]/altitude-ft"));
		if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+2)~"]/speed-kts") != nil)
		{
			line2r = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+2)~"]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+2)~"]/altitude-ft"));
		}
	}
	if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+3)~"]/id") != nil)
	{
		line3lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+3)~"]/leg-bearing-true-deg"));
		line3l = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+3)~"]/id");
		line4ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+3)~"]/leg-distance-nm"))~" NM";
		line3r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+3)~"]/altitude-ft"));
		if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+3)~"]/speed-kts") != nil)
		{
			line3r = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+3)~"]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+3)~"]/altitude-ft"));
		}
	}
	if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+4)~"]/id") != nil)
	{
		line4lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+4)~"]/leg-bearing-true-deg"));
		line4l = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+4)~"]/id");
		line5ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+4)~"]/leg-distance-nm"))~" NM";
		line4r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+4)~"]/altitude-ft"));
		if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+4)~"]/speed-kts") != nil)
		{
			line4r = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+4)~"]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+4)~"]/altitude-ft"));
		}
	}
	if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+5)~"]/id") != nil)
	{
		line5lt = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+5)~"]/leg-bearing-true-deg"));
		line5l = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+5)~"]/id");
		line6ct = sprintf("%3.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+5)~"]/leg-distance-nm"))~" NM";
		line5r = sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+5)~"]/altitude-ft"));
		if (getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+5)~"]/speed-kts") != nil)
		{
			line5r = getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+5)~"]/speed-kts")~"/"~sprintf("%5.0f", getprop("/autopilot/route-manager/route/wp["~(((crtPageNum -1) /5)+5)~"]/altitude-ft"));
		}
	}
	points = getprop("/autopilot/route-manager/route/num");
	pageNum = math.ceil(points / 5);
	if(pageNum == 0)
	{
		page = crtPageNum ~ "/" ~ pageNum;
	}
}