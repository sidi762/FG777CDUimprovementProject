var grosswt = getprop("yasim/gross-weight-lbs");
if(grosswt == nil) return;
var target_speed = 0;
var horn   = 0;
var shaker = 0;
var siren  = (size(me.msgs_alert)!=0);
var vgrosswt = math.sqrt(grosswt/730284);
var altitude_compensate = (getprop("instrumentation/altimeter/indicated-altitude-ft") / 1000);
me.vref.setValue(vgrosswt * 166 + altitude_compensate);
# calculate Flap Maneuver Speed
me.flap.setValue(vgrosswt * 166 + 80 + altitude_compensate);
me.fl1.setValue(vgrosswt * 166 + 60 + altitude_compensate);
me.fl5.setValue(vgrosswt * 166 + 40 + altitude_compensate);
me.fl15.setValue(vgrosswt * 166 + 20 + altitude_compensate);

# calculate stall speed
var vref_table = [
	[0, vgrosswt * 166 + 80],
	[0.033, vgrosswt * 166 + 60],
	[0.166, vgrosswt * 166 + 40],
	[0.500, vgrosswt * 166 + 20],
	[0.666, vgrosswt * 180],
	[0.833, vgrosswt * 174],
	[1.000, vgrosswt * 166]];

var vref_flap = interpolate_table(vref_table, me.flaps);
var stallspeed = (vref_flap - 10 + altitude_compensate);
me.stallspeed.setValue(stallspeed);

var weight_diff = grosswt-308700;
me.v1.setValue(weight_diff*0.00018424+92 + altitude_compensate);
me.vr.setValue(weight_diff*0.000164399+104 + altitude_compensate);
me.v2.setValue(weight_diff*0.000138889+119 + altitude_compensate);
setprop("instrumentation/fmc/vspeeds/V1", me.v1.getValue());
setprop("instrumentation/fmc/vspeeds/VR", me.vr.getValue());
setprop("instrumentation/fmc/vspeeds/V2", me.v2.getValue());

# calculate flap target speed
if (me.flaps_tgt<0.01)            # flap up
{
	if(!(getprop("gear/gear[1]/wow") or getprop("gear/gear[2]/wow")))
	{
		me.takeoff_mode.setValue(0);
	}
}
elsif (me.flaps_tgt<0.034)        # flap 1
{
    target_speed = me.flap.getValue();
}
elsif (me.flaps_tgt<0.167)        # flap 5
{
    target_speed = me.fl1.getValue();
	if(getprop("gear/gear[1]/wow") and getprop("gear/gear[2]/wow"))
	{
		me.takeoff_mode.setValue(1);
	}
}
elsif (me.flaps_tgt<0.501)        # flap 15
{
    target_speed = me.fl5.getValue();
}
elsif (me.flaps_tgt<0.667)        # flap 20
{
    target_speed = me.fl15.getValue();
}
elsif (me.flaps_tgt<0.834)        # flap 25
{
    target_speed = vgrosswt * 180;
}
else                          # flap 30
{
    target_speed = vgrosswt * 174;
}
target_speed -= 5;

if(target_speed > 250) target_speed = 250;
me.targetspeed.setValue(target_speed);