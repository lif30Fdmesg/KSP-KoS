copypath("0:/landing.ks", "").
copypath("0:/ascend.ks", "").
copypath("0:/transfer.ks", "").
copypath("0:/parking.ks", "").

set target to mun.


if ship:orbit:body:name = "Kerbin" and ship:altitude < 300 {
	print "Starting ascend sequence...".
	run ascend.
}

if ship:orbit:body:name = "Kerbin" and ship:altitude > ship:orbit:body:atm:height {
	run transfer.
}

if ship:orbit:body:name <> "kerbin" and ship:apoapsis < 0 {
	run parking.
}
