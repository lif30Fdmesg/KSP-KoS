//@param:
//1. orbit you want to achieve
//2. heading in degrees (eg. 90-east, 0-north, 45-northeast)

//from {declare local i is 0.} until i = 9 step {set i to (i+1).} do {print ship:partsdubbed("proceduraltankliquid")[i]:parent:name.} radialdecoupler




declare parameter orbit_height is ship:orbit:body:atm:height + 5000.
declare parameter inclin is 90.

declare function ascend{
	clearscreen.
	parameter orbit_h.
	parameter inc.
	
	sas off.
	declare flag is false.

	when flag = true then {
		set warpmode to "physics".
		set warp to 3.
		preserve.
	}

	when flag = false then {
		set warp to 0.
		preserve.
	}
	

	lock throttle to 1.
	sas off.
	
	//ascend finction1
	//f(x) = 4.7016379943005E-08x² − 0.004084345266111x + 88.7420923015285      -->    trend line polynomial
	//lock head to ( (4.7016379943005E-08*(ship:altitude^2))-(0.004084345266111*ship:altitude) + 88.7420923015285 ).
	//end function1
	
	//ascend function2
	//f(x) = 96.4581090949085 exp( − 6.98981109924504E-05 x )    -->    trend line exponential
	set e to 2.718281828459. //euler's number rounded to 12 decimal places.
	lock steering to heading(inc, 90).
	until ship:altitude >= 1200{}
	lock head to ( 96.4581090949085*(e^(-6.98981109924504E-05*ship:altitude)) ).
	//end function2
	
	lock steering to heading(inc, head).
	until ship:altitude >= ship:orbit:body:atm:height {
		if ship:apoapsis > orbit_h {
			set foo to throttle.
			if (throttle > 0) lock throttle to foo - 0.1.
			set flag to true.
		}else{
			set foo to throttle.
			if (throttle < 1) lock throttle to foo + 0.1.
		}
	}

	set u to constant:g * ship:orbit:body:mass.
	set r to ship:orbit:body:radius + ship:apoapsis.
	set a to ship:orbit:body:radius + ((ship:apoapsis + ship:periapsis)/2).
	set iv to sqrt(u*(2/r-1/a)).
	print "Initial vel.: " + round(iv, 4).

	set rr to ship:orbit:body:radius + ship:apoapsis.
	set aa to ship:orbit:body:radius + ship:apoapsis.
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

	wait until eta:apoapsis <= (burn_duration/2+5).
	set flag to false.
	wait until eta:apoapsis <= (burn_duration/2).
	set fv to ship:orbit:velocity:orbit:mag + dv.
	lock throttle to 1.

	wait until ship:orbit:velocity:orbit:mag >= fv or ship:periapsis >= orbit_h.
	lock throttle to 0.
	lock steering to prograde.
	remove myNode.
	set ship:control:pilotmainthrottle to 0.
}

ascend(orbit_height, inclin).
wait 1.
run tools.