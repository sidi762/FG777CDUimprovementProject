	var perfData = {
		pAir : 1.29,#kg/m^2
		#flift:getprop(flifttree),#N
		wingArea : 124.58,#m
		nv : 0,
		CL : 0.491,
		CD: 0.0344,
		CDi: 0.0102,
		CD0: 0.0242, #CD0 = CD - CDi
		e : 0.796,
		g : 9.8,
		#a : getprop(accelerationtree),
		mass : 42255, #Get it in Property Tree,kg
		AR : 9.45, #Data of 737ng
		#T : (cdu.lbs2kg(getprop(grossweight777lbstree)) * getprop(accelerationtree) + getprop(fdragtree))/math.cos(getprop(pitchdegtree) * D2R), #Get it in Property Tree
		#T : cdu.lbs2kg(27300),
		e0: ((0.491)*(0.491))/((0.0344-0.0242)*3.1415926*9.45),
		milthrust: 27300, #Data from Soitanen 738 engine file
	};
    var milthrust_grid = [
		[1.2600, 1.0805, 0.7400, 0.5340, 0.3720,  0.2410,  0.1490],
		[1.1710, 0.8937, 0.6970, 0.5060, 0.3550,  0.2310,  0.1430],
		[1.1500, 0.9210, 0.6920, 0.5060, 0.3570,  0.2330,  0.1450],
		[1.1810, 0.9510, 0.7210, 0.5320, 0.3780,  0.2480,  0.1540],
		[1.2580, 1.0200, 0.7820, 0.5820, 0.4170,  0.2750,  0.1700],
		[1.3690, 1.1200, 0.8710, 0.6510 ,0.4750,  0.3150,  0.1950],
    ];
    var milthrust_inp = func (mach, alt) {
        var x = 0;
        var y = 0;
        var dif_x = 0.2;
        var dif_mach = 0;
        var dif_y = 10000;
        var dif_alt = 0;
        var thrust_cfn = 1;

        if (mach < 0.2) {
            x = 0;
            dif_mach = mach;
        } else if (mach >= 0.2 and mach < 0.4) {
            x = 1;
            dif_mach = mach - 0.2;
        } else if (mach >= 0.4 and mach < 0.6) {
            x = 2;
            dif_mach = mach - 0.4;
        } else if (mach >= 0.6 and mach < 0.8) {
            x = 3;
            dif_mach = mach - 0.6;
        } else if (mach >= 0.8 and mach < 1.0) {
            x = 4; 
            dif_mach = mach - 0.8;
        } else {
            x = 4;
            dif_mach = 0.0;
        }

        if (alt < 0) {
            y = 0;
            dif_alt = alt;
        } else if (alt >= 0 and alt < 10000) {
            y = 1;
            dif_alt = alt;
        } else if (alt >= 10000 and alt < 20000) {
            y = 2;
            dif_alt = alt - 10000;
        } else if (alt >= 20000 and alt < 30000) {
            y = 3;
            dif_alt = alt - 20000;
        } else if (alt >= 30000 and alt < 40000) {
            y = 4;
            dif_alt = alt - 30000;
        } else if (alt >= 40000 and alt < 50000) {
            y = 5;
            dif_alt = alt - 40000;
        } else if (alt >= 50000 and alt < 60000) {
            y = 6;
            dif_alt = alt - 50000;
        } else {
            y = 6;
            dif_alt = 0;
        }

        var dif_mach_y = milthrust_grid[x + 1][y] - milthrust_grid[x][y];
        var dif_mach_y1 = milthrust_grid[x + 1][y + 1] - milthrust_grid[x][y + 1];
        var avg = milthrust_grid[x][y] + dif_mach_y / dif_x * dif_mach;
        var avg1 = milthrust_grid[x][y + 1] + dif_mach_y1 / dif_x * dif_mach;
        var thrust_rsl = avg + (avg1 - avg) / dif_y * dif_alt;
        return(thrust_rsl);
    }
	var vy_finder = func(test_alt, grs_wgt){
        var crn_dns_alt = getprop("/fdm/jsbsim/atmosphere/density-altitude");
        var crn_dns_air = getprop("/environment/density-slugft3");
        var crn_temp = getprop("/environment/temperature-degc");
        var std_temp = 15 - 1.98 * (test_alt/1000);
        var fd_temp = crn_temp - ((test_alt - crn_dns_alt) / 1000 * 1.98);
        var theta =  (273 + fd_temp) / (273 + 15);
        var snd_spd_temp = 661 * math.sqrt(theta);
        var oswald_efc = perfData.e0;
        var ind_drag_K = 1 / (oswald_efc * math.pi * 9.45); #e0*pi*AR
        var cd0 = perfData.CD0;
        if (test_alt < 36089) {
            dns_air = crn_dns_air - (0.000000046 * (test_alt - crn_dns_alt));
        } else {
            dns_air = crn_dns_air - (0.000000046 * (36089 - crn_dns_alt)) - (0.000000018 * (test_alt - 36089));
        }
        
        var vy_mach = 0.0;
        var vy_tas = 0.0;
        for (i=0; i<32; i=i+1) {
            var thrust = perfData.milthrust * 2 * milthrust_inp(vy_mach, test_alt);
            var cl_for_vy = (-(thrust/grs_wgt) + math.sqrt(math.pow(thrust/grs_wgt,2) + 12 * cd0 * ind_drag_K)) / (2 * ind_drag_K);
            if (cl_for_vy < 0 ) {
                cl_for_vy = (-(thrust/grs_wgt) - math.sqrt(math.pow(thrust/grs_wgt,2) + 12 * cd0 * ind_drag_K)) / (2 * ind_drag_K);
            }
            var cd_for_vy = cd0 + ind_drag_K * math.pow(cl_for_vy, 2);
            var vy = math.sqrt(grs_wgt / (0.5 * dns_air * 1021 * cl_for_vy));
            vy_tas = vy * 0.592;
            var vy_ias = vy_tas / (1 + (test_alt/600/100 + (fd_temp - std_temp)/5/100));
            vy_mach = vy_tas / snd_spd_temp;
        }
        return(vy_ias);
    }
	print(vy_finder(0,65489));