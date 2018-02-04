

declare function parking{

	declare parameter p_orbit is 50000.
	clearscreen.
	
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
//run landing.