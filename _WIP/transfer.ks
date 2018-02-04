
declare function transfer{
		
	sas off.
	
	set act_eng to list().
	set dis_eng to list().
	list engines in eng.
	when true then {
		if act_eng:empty{
			for foo in eng {
				if (foo:ignition = true){
					act_eng:add(foo).
				}
				if (foo:ignition = false){
					dis_eng:add(foo).
				}
			}
		}
		if(dis_eng:length <> 0){
			preserve.
		}
		set bool to false.
		if (not act_eng:empty){
			from {local x is 0.} until x = act_eng:length step {set x to x + 1.} do {
				if (act_eng[x]:availablethrust < 0.1) set bool to true.
			}
		}
		if (bool = true){
			act_eng:clear.
			if (dis_eng:length <> 0){
				dis_eng:clear.
				stage.
			}
			list engines in eng.
		}
	}
	
	set liquid to list().
	when true then {
		set check to true.
		if(liquid:empty){
			from {declare local i is 0.} until i = ship:partsdubbed("proceduraltankliquid"):length step {set i to (i+1).} do {
				if (ship:partsdubbed("proceduraltankliquid")[i]:parent:name = "radialdecoupler"){
					liquid:add(ship:partsdubbed("proceduraltankliquid")[i]).
				}
			}
			if (liquid:length = 0) set check to false.
		}
		
		set bool to false.
		for l in liquid {
			if (l:resources[0]:amount < 0.1){
				set bool to true.
			}
		}
		if (bool = true){
			liquid:clear.
			stage.
		}
		if (check = true) preserve.
	}
	
	declare parameter p_orbit is 50000.
	
	clearscreen.
	set flag to false.
	declare local ang is 0.
	until flag {
		lock steering to prograde.
			if ship:longitude < 0{
				set sl to (abs(360 + ship:longitude)).
				print "ship longitude: : " + round(sl, 4) at(0, 8).
			}else{
				set sl to ship:longitude.
				print "ship longitude: : " + round(sl, 4) at(0, 8).
			}
			if target:longitude < 0 {
				set tl to (abs(360 + target:longitude)).
				print "target longitude: " + round(tl, 4) at(0, 9).
			}else{
				set tl to target:longitude.
				print "target longitude: " + round(tl, 4) at(0, 9).
			}
			
			// if tl - sl > 180{
				// set ang to 360 - tl + sl.
			// }else if sl - tl > 180{
				// set ang to -360 + tl - sl.
			// }else if tl - sl < 0{
				// set ang to sl - tl.
			// }else if tl - sl > 0 {
				// set ang to sl - tl.
			// }
			
			if tl > sl {
				if tl - sl > 180{
					set ang to ((360 - tl + sl)*(-1)).
				}else{
					set ang to tl - sl.
				}
			}else{
				if sl - tl > 180{
					set ang to (360 - sl + tl).
				}else{
					set ang to ((sl - tl)*(-1)).
				}
			}
			
			print "Phase: " + round(ang, 4) at(0, 10).
			
			print "Intercept angle: " + round(deg_period, 4) at(0, 7).
			
			if(deg_period + 0.01 > ang and ang >= deg_period - 0.01){
				print "Throttling up...                " at (0, 0).
				until ship:apoapsis >= (target:apoapsis - target:radius - p_orbit){
					lock throttle to 1.
				}
				lock throttle to 0.
				set flag to true.
			}else{
				print "Waiting for intercept angle..." at (0, 0).
			}
			
	}
}

declare function deg_period{
	set sma to (ship:periapsis + target:apoapsis)/2 + ship:orbit:body:radius.
	set rop to sqrt((sma/target:apoapsis)^3).
	
	return 180 - (180*rop).
}



transfer(50000).
wait 10.
run parking.