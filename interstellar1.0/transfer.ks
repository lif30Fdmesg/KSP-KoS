
declare function transfer{
		
	sas off.
	
	
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