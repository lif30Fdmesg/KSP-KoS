clearscreen.
sas off.
print "Status: ".

declare parameter longit is 90.

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
			lock throttle to (thr + 0.1).
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