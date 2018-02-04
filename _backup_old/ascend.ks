
set ship:control:pilotmainthrottle to 0.
set external_fuel to ship:partstagged("external_fuel").
set main_fuel to ship:partstagged("main_fuel").
set omni_antenna to ship:partstagged("omni_antenna")[0].
set main_engine to ship:partstagged("main_engine")[0].
set secondary_engine to ship:partstagged("secondary_engine")[0].
set dish_antenna to ship:partstagged("dish_antenna")[0].
set shell to ship:partstagged("shell").
set solar_panel to ship:partstagged("solar_panel").


sas off.
lock steering to heading(90, 90).

if external_fuel:length > 0{
	when external_fuel[0]:resources[0]:amount < 0.1 and external_fuel[2]:resources[0]:amount < 0.1 then{
		stage.
	}
	when external_fuel[1]:resources[0]:amount < 0.1 and external_fuel[3]:resources[0]:amount < 0.1 then{
		stage.
	}
}

if main_fuel:length > 0 {
	when main_fuel[0]:resources[0]:amount < 0.1 and main_fuel[1]:resources[0]:amount < 0.1 then {
		stage.
		wait 3.
		stage.
	}
}

if shell:length > 0 {
	when ship:altitude >= ship:orbit:body:atm:height then {
		from {local x is shell:length - 1.} until x <= -1 step {set x to x - 1.} do {
			if shell[x]:getmodule("proceduralfairingdecoupler"):hasevent("jettison"){
				shell[x]:getmodule("proceduralfairingdecoupler"):doevent("jettison").
			}
		}
	}
}

if defined omni_antenna {
	when ship:altitude >= ship:orbit:body:atm:height then {
		if omni_antenna:getmodule("modulertantenna"):hasevent("activate"){
			omni_antenna:getmodule("modulertantenna"):doevent("activate").
		}
	}
}

if defined dish_antenna {
	when ship:altitude >= ship:orbit:body:atm:height then {
		if dish_antenna:getmodule("modulertantenna"):hasevent("activate"){
			dish_antenna:getmodule("modulertantenna"):doevent("activate").
			dish_antenna:getmodule("modulertantenna"):setfield("target", "kerbin").
		}
	}
}

if solar_panel:length > 0 {
	when ship:altitude >= ship:orbit:body:atm:height then {
		from {local x is 0.} until x >= solar_panel:length step {set x to x + 1.} do {
			if solar_panel[x]:getmodule("moduledeployablesolarpanel"):hasevent("extend panels"){
				solar_panel[x]:getmodule("moduledeployablesolarpanel"):doevent("extend panels").
			}
		}
	}
}

function ascend {
	
	parameter heading_x.
	parameter max_apoapsis.
	parameter max_twr.
	declare parameter throt_tunning is 0.001.
	
	clearscreen.
	
	if ship:altitude < 300 {
		from {local x is -10.} until x > 0 step {set x to x + 1.} do {
			print "Countdown: T " + x + "s  " at(0, 10).
			wait 1.
		}
	}
		
	clearscreen.
	
	lock head to (1000 * (1 - 1/(12 * (ship:altitude/1000) + 100))^(ship:altitude/1000)-910). //y=1000\left(1-\frac{1}{12x+100}\right)^x-910
	set g to (ship:orbit:body:mass * constant:g / (ship:altitude + ship:orbit:body:radius)^2). // function above is curveture of angle/height. x=altitude; y=angle in degrees (90 - up, 0 horizont)
	lock twr to (main_engine:thrust / (g * ship:mass)).
		
	
	lock steering to heading(heading_x, head).
	lock throttle to 1.
	
	when ag1 then{
		set max_twr to max_twr - 0.001.
		print "New MAX_TWR: " + round(max_twr, 2) at(0, 5).
		preserve.
	}
	
	when ag2 then{
		set max_twr to max_twr + 0.001.
		print "New MAX_TWR: " + round(max_twr, 2) at(0, 5).
		preserve.
	}
	
	until ship:altitude >= 10000{
		print "Under 10000          " at(0, 0).
		print "TWR: " + round(twr, 2) + " | Max TWR: " + round(max_twr, 2) + "     " at(0, 1).
		print "Groundspeed: " + round(ship:groundspeed, 2) at(0, 2).
		print "Verticalspeed: " + round(ship:verticalspeed, 2) at(0, 3).
		print "Velocity: " + round(sqrt(ship:groundspeed^2 + ship:verticalspeed^2)) at(0, 4).
		if main_engine:ignition = false {
			stage.
		}
		if (sqrt(ship:groundspeed^2 + ship:verticalspeed^2) < 300) {
			if twr < max_twr{
				if throttle < 1 {
					set thr to throttle.
					lock throttle to thr + throt_tunning.
				}
			}else{
				if throttle > 0 {
					set thr to throttle.
					lock throttle to thr - throt_tunning.
				}				
			}				
		}else{
			if throttle > 0 {
				set thr to throttle.
				lock throttle to thr - throt_tunning.
			}					
		}
	}
	
	until ship:apoapsis >= max_apoapsis {
		print "Waitiing for apoapsis         " at(0, 0).
		print "TWR: " + round(twr, 2) + " | Max TWR: " + round(max_twr, 2) + "     " at(0, 1).
		print "Groundspeed: " + round(ship:groundspeed, 2) at(0, 2).
		print "Verticalspeed: " + round(ship:verticalspeed, 2) at(0, 3).
		print "Velocity: " + round(sqrt(ship:groundspeed^2 + ship:verticalspeed^2)) at(0, 4).
		if twr < max_twr{
			if throttle < 1 {
				set thr to throttle.
				lock throttle to thr + throt_tunning.
			}
		}else{
			if throttle > 0 {
				set thr to throttle.
				lock throttle to thr - throt_tunning.
			}				
		}
	}
	
	lock throttle to 0.
	lock steering to prograde.
	
	until ship:altitude >= ship:orbit:body:atm:height {
		print "Keeping apoapsis         " at(0, 0).
		print "TWR: " + round(twr, 2) + " | Max TWR: " + round(max_twr, 2) + "     " at(0, 1).
		print "Groundspeed: " + round(ship:groundspeed, 2) at(0, 2).
		print "Verticalspeed: " + round(ship:verticalspeed, 2) at(0, 3).
		print "Velocity: " + round(sqrt(ship:groundspeed^2 + ship:verticalspeed^2)) at(0, 4).
		if ship:apoapsis < max_apoapsis{
			if throttle < 1 {
				set thr to throttle.
				lock throttle to thr + throt_tunning.
			}
		}else{
			if throttle > 0 {
				set thr to throttle.
				lock throttle to thr - throt_tunning.
			}				
		}
	}
	
	lock throttle to 0.
	
	circularisation(max_apoapsis).
	
	lock throttle to 0.
	set ship:control:pilotmainthrottle to 0.
}

declare function circularisation{
	declare parameter max_orbit.
	clearscreen.
	
	set u to constant:g * ship:orbit:body:mass.
	set r to ship:orbit:body:radius + ship:apoapsis.
	set a to ship:orbit:body:radius + ((ship:apoapsis + ship:periapsis)/2).
	set iv to sqrt(u*(2/r-1/a)).
	print "Initial vel.: " + round(iv, 4).
	
	set rr to ship:orbit:body:radius + max_orbit.
	set aa to ship:orbit:body:radius + max_orbit.
	set fv to sqrt(u*(2/rr-1/aa)).
	print "Final vel.: " + round(fv, 4).
	
	set dv to fv - iv.
	print "Total vel.: " + round(dv, 4).
	
	set myNode to node(time:seconds + eta:apoapsis, 0, 0, dv).
	add myNode.
	lock steering to myNode.
	
	set max_acc to ship:maxthrust/ship:mass.
	set burn_duration to myNode:deltav:mag/max_acc.
	print "Estimated burn time: " + round(burn_duration, 4) + " s".
	
	wait until eta:apoapsis <= (burn_duration/2).
	set fv to ship:orbit:velocity:orbit:mag + dv.
	lock throttle to 1.
	
	wait until ship:orbit:velocity:orbit:mag >= fv.
	lock thrust to 0.
	remove myNode.
}


ascend(90, 75000, 2.5, 0.01).
run transfer.