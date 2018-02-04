copypath("0:/tourist/ascend_tourism.ks", "").
copypath("0:/tourist/tourism_landing.ks", "").

if ship:orbit:body:name = "Kerbin" and ship:altitude < 300 {
	print "Starting ascend sequence...".
	run ascend_tourism(75000, 90).
	run tourism_landing.
}else{
	run tourism_landing.
}
