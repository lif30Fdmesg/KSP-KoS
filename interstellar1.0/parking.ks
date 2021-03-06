

declare function parking{

	declare parameter p_orbit is 50000.
	clearscreen.
	
	sas off.
	
	set flag to ship:orbit:body:name.
	
	wait until ship:orbit:body:name <> "kerbin".
	
	if ship:periapsis < 0 {
		lock steering to vxcl(prograde:vector, up:vector).
		wait 120.
		until ship:periapsis > p_orbit{
			lock throttle to 1.
		}
		lock throttle to 0.
	}
	
	//if ship:apoapsis < 0 ship:
	
//	if (ship:apoapsis < 0){
//		lock steering to retrograde.
//		wait until eta:periapsis = 60.
//		lock throttle to 1.
//		wait until ship:apoapsis > 0.
//		wait 1.
//		lock throttle to 0.
//	}
	
	set u to constant:g * ship:orbit:body:mass.
	set r to ship:orbit:body:radius + ship:periapsis.
	set a to ship:orbit:body:radius + ((ship:apoapsis + ship:periapsis)/2).
	set iv to sqrt(u*(2/r-1/a)).
	print "Initial vel.: " + round(iv, 4).
	
	set rr to ship:orbit:body:radius + p_orbit.
	set aa to ship:orbit:body:radius + p_orbit.
	set fv to sqrt(u*(2/rr-1/aa)).
	print "Final vel.: " + round(fv, 4).
	
	set dv to fv - iv.
	print "Total vel.: " + round(dv, 4).
	
	set myNode to node(time:seconds + eta:periapsis, 0, 0, dv).
	add myNode.
	lock steering to myNode.
	
	set max_acc to ship:maxthrust/ship:mass.
	set burn_duration to myNode:deltav:mag/max_acc.
	print "Estimated burn time: " + round(burn_duration, 4) + " s".
	
	wait until eta:periapsis <= (burn_duration/2).
	set fv to ship:orbit:velocity:orbit:mag + dv.
	lock throttle to 1.
	
	wait until ship:orbit:velocity:orbit:mag <= fv.
	lock throttle to 0.
	lock steering to retrograde.
	remove myNode.
	
}

parking(20000).
wait 10.
run landing.