copypath("0:/command/ascend.ks", "").
	//copypath("0:/landing.ks", "").
	//copypath("0:/ascend.ks", "").
	copypath("0:/command/transfer.ks", "").
	copypath("0:/command/parking.ks", "").
	copypath("0:/command/tools.ks", "").

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
