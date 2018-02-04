if(ship:partsdubbed("rtshortdish2"):length > 0){
	if(ship:partsdubbed("rtshortdish2")[0]:getmodule("modulertantenna"):getfield("status")="off"){
		ship:partsdubbed("rtshortdish2")[0]:getmodule("modulertantenna"):doevent("activate").
		ship:partsdubbed("rtshortdish2")[0]:getmodule("modulertantenna"):setfield("target", "kerbin").
	}
}

if(addons:rt:hasconnection(ship)){
	copypath("0:/moon_reacher/landing.ks", "").
	copypath("0:/moon_reacher/ascend.ks", "").
	copypath("0:/moon_reacher/transfer.ks", "").
	copypath("0:/moon_reacher/parking.ks", "").
	copypath("0:/moon_reacher/tools.ks", "").
}

set target to mun.


if ship:orbit:body:name = "Kerbin" and ship:altitude < 300 {
	print "Starting ascend sequence...".
	run ascend(75000, 90).
}

if ship:orbit:body:name = "Kerbin" and ship:periapsis > ship:orbit:body:atm:height {
	run transfer.
}

if ship:orbit:body:name <> "kerbin" and ship:apoapsis < 0 {
	run parking.
}
