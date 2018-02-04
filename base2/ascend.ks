//@param:
//1. orbit you want to achieve
//2. heading in degrees (eg. 90-east, 0-north, 45-northeast)

//from {declare local i is 0.} until i = 9 step {set i to (i+1).} do {print ship:partsdubbed("proceduraltankliquid")[i]:parent:name.} radialdecoupler

//ked je separacia, treba vypnut hlavny tah a nechat pracovat iba tie male svine
when ship:altitude > 45000 then {
	set warpmode to "PHYSICS".
	set warp to 1.
}


declare parameter orbit_height is ship:orbit:body:atm:height + 5000.
declare parameter inclin is 90.
//declare parameter orbit_height is 71000.
//declare parameter inclin is 60.

declare function ascend{
	clearscreen.
	parameter orbit_h.
	parameter inc.
	
	sas off.
	
	ship:partstagged("main")[0]:getmodule("modulecommand"):doevent("control from here").
	//potom nastavit tag
	lock throttle to 1.
	sas off.
	
	//ascend finction1
	// f(x) = 4.7016379943005E-08x² − 0.004084345266111x + 88.7420923015285      -->    trend line polynomial
	
	// lock head to ( (4.7016379943005E-08*(ship:altitude^2))-(0.004084345266111*ship:altitude) + 88.7420923015285 ).
	
	//end function1
	
	//ascend function2
	//f(x) = 96.4581090949085 exp( − 6.98981109924504E-05 x )    -->    trend line exponential
	
	set e to 2.718281828459. //euler's number rounded to 12 decimal places.
	lock steering to heading(inc, 90).
	until ship:altitude >= 1200{}
	lock head to ( 96.4581090949085*(e^(-6.98981109924504E-05*ship:altitude)) ).
	
	//end function2
	
	
	//ascend function3
	//f(x) = 2.22170069623719E-08x² − 0.002878166314637x + 89.195259328796
	
	// lock head to ((2.22170069623719E-08*(ship:altitude^2))-(0.002878166314637*ship:altitude)+89.195259328796).
	
	//end function3
	
	
	
	
	
	
	// lock g to (ship:orbit:body:mass * constant:g / (ship:altitude + ship:orbit:body:radius)^2).
	// set act_eng to list().
	// list engines in eng.
	// set twr to 0.
	// set thr2 to 0.
	// when true then {
		// set thr2 to 0.
		// for foo in eng {
			// if (foo:ignition = true){
				// act_eng:add(foo).
			// }
		// }
	
		// if(act_eng:length > 0){
			
			// for foo in act_eng{
				// set thr2 to thr2 + foo:thrust.
			// }
			
		// }
	
		// set twr to thr2/(ship:mass*g).
		// preserve.
	// }
	
	
	
	
	
	lock steering to heading(inc, head).
	until ship:altitude >= ship:orbit:body:atm:height {
	
		if ship:apoapsis > orbit_h {
			set foo to throttle.
			if (throttle > 0) lock throttle to foo - 0.1.
		}else{
			
			// if sqrt(ship:groundspeed^2 + ship:verticalspeed^2) > 450 and ship:altitude < 10000{
				// set foo to throttle.
				// if (throttle > 0) lock throttle to foo - 0.1.
			// }else{		
				set foo to throttle.
				if (throttle < 1) lock throttle to foo + 0.1.
			//}
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

	wait until eta:apoapsis <= ((burn_duration/2)+5).
	set warp to 0.
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

//list ship:partsnamed("kzprocfairingside1") in shell.
set shell to ship:partsnamed("kzprocfairingside1").
if(shell:length <> 0){
	from {declare local i is 0.} until i = shell:length step {set i to i+1.} do {
		ship:partsnamed("kzprocfairingside1")[i]:getmodule("proceduralfairingdecoupler"):doevent("jettison").
	}
}
wait 1.

//ship:partsdubbed("rzresizablefairingbasering")[0]:getmodule("moduledecouple"):doevent("decouple").

set base to ship:partsdubbed("rzresizablefairingbasering").
if(base:length <> 0){
	base[0]:getmodule("moduledecouple"):doevent("decouple").
}




//**************************************
//starting return for booster
//*****************************************



lock steering to ship:srfretrograde.
set warpmode to "rails".
set warp to 3.
wait until ship:longitude > -120 and ship:longitude < -110.
set warp to 2.
wait until ship:longitude > -100 and ship:longitude < -95.
set warp to 1.
wait until ship:longitude > -93 and ship:longitude < -92.
set warp to 0.
wait until ship:longitude > -88.3 and ship:longitude < -88.
set warpmode to "physics".




clearscreen.
sas off.
print "Status: ".

declare parameter longit is -74.

declare parameter DESC_PROFILE is List(

    30,    -150,    20000,    5000,     0.1,	0.1,
    10,    -100,    5000,    500,     0.1,	0.1,
    10,      -50,      500,           100,   0.1,	0.1,
    1,      -4,      100,           0,   0.1,	0.1

).


lock steering to ship:srfretrograde.
set warpmode to "rails".
wait 15.
set warp to 3.
wait until (ship:longitude >= longit - 10) and (ship:longitude <= longit + 10).
set warp to 0.
set warpmode to "physics".
set warp to 1.
//wait 15.
wait until (ship:longitude >= longit - 0.1) and (ship:longitude <= longit + 0.1).
set warp to 0.

print "Killing horizontal speed...".
lock steering to ship:srfretrograde.

until ship:groundspeed < 30 + 0.1 {
	if ship:groundspeed > 30 + 0.1 {
		if throttle < 1 {
			set thr to throttle.
			lock throttle to thr + 0.1.
		}
		print "Throttling up..." at(8, 0).
	}else if ship:groundspeed > 30 and ship:groundspeed < 30 + 0.1{
		if throttle > 0 {
			set thr to throttle.
			lock throttle to thr - 0.1.
		}
		print "Throttling down..." at(8, 0).
	}else {
		lock throttle to 0.
		print "Free falling..." at(8, 0).
	
	}
}



function descend {
parameter p1. //horizontal speed
parameter p2. //vertical speed
parameter p3. // upper altitude
parameter p4. // lower altitude
parameter p5. // diviation/allowed error
declare parameter throt_tunning is 0.01.

if ship:status = "LANDED"{
	return.
}


	
lock steering to retrograde.
set ship:control:pilotmainthrottle to 0.
print "---------------------------".
print "Enabling SAS...".

if ship:periapsis > p3 {
	print "Deorbiting...".
	lock steering to ship:retrograde.
	wait 10.
	
	until ship:periapsis < p3 {
		if throttle < 1 {
			set thr to throttle.
			lock throttle to thr + throt_tunning.
		}
		print "Throttling up..." at(8, 0).
	}
	
	print "Free falling..." at(8, 0).
	lock throttle to 0.
}else{
	print "Starting descend...".
}

if ship:periapsis > 0 {
	print "Waiting for appropriate altitude...".
	wait until ((ship:altitude < p3) or (alt:radar < p3)).
}


print "Killing horizontal speed...".
lock steering to ship:srfretrograde.

until ship:groundspeed < p1 + p5 {
	if ship:groundspeed > p1 + p5 {
		if throttle < 1 {
			set thr to throttle.
			lock throttle to thr + throt_tunning.
		}
		print "Throttling up..." at(8, 0).
	}else if ship:groundspeed > p1 and ship:groundspeed < p1 + p5{
		if throttle > 0 {
			set thr to throttle.
			lock throttle to thr - throt_tunning.
		}
		print "Throttling down..." at(8, 0).
	}else {
		lock throttle to 0.
		print "Free falling..." at(8, 0).
	
	}
}

print "Horizontal speed acquired...".
lock throttle to 0.

until alt:radar < p4 { // pod 5000 nevypina throttle pokial menej ako 0
	lock steering to ship:srfretrograde.
	if ship:verticalspeed < p2 and ship:verticalspeed < 0 {
		if throttle < 1 {
			set thr to throttle.
			lock throttle to thr + throt_tunning.
		}
		print "Throttling up..." at(8, 0).
	}else if ship:verticalspeed > p2 and ship:verticalspeed < 0 {
		if throttle < 0.5 {
			if throttle > 0 {
				set thr to throttle.
				lock throttle to thr - throt_tunning.
			}
			print "Throttling down..." at(8, 0).
		}else{
			lock throttle to 0.
		}
		print "Free falling..." at(8, 0).
	} else if ship:verticalspeed > 0 {
		lock steering to up.
		lock throttle to 0.
		print "Free falling..." at(8, 0).
	}
	if ship:status = "LANDED" {
		lock throttle to 0.
		lock steering to up.
		break.
	}
	if stage:liquidfuel < 0.1 {
		lock throttle to 0.
		lock steering to up.
		break.
	}
}

lock throttle to 0.
set ship:control:pilotmainthrottle to 0.

if ship:status = "LANDED" {
	print "Landed. Waiting for full stop..." at(8, 0).
	lock steering to up.
	wait 5.
	wait until ship:groundspeed <= 0.05 and ship:verticalspeed <= 0.05.
}

if stage:liquidfuel < 0.1 {
	print "Brace for impact!" at(8, 0).
	wait until ship:groundspeed <= 0.05 and ship:verticalspeed <= 0.05.
}

}

function descend_profile{
	parameter profile.
	set count to 0.

	until count >= profile:length {
		descend(profile[count], profile[count+1], profile[count+2], profile[count+3], profile[count+4], profile[count+5]).
		set count to count + 6.
	}
}


descend_profile(DESC_PROFILE).