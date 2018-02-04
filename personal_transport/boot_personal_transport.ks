copypath("0:/personal_transport/ascend_simple.ks", "").
	//copypath("0:/landing.ks", "").
	//copypath("0:/ascend.ks", "").
	//copypath("0:/transfer.ks", "").
	//copypath("0:/parking.ks", "").
	//copypath("0:/tools.ks", "").

if ship:orbit:body:name = "Kerbin" and ship:altitude < 300 {
	print "Starting ascend sequence...".
	run ascend_simple(75000, 90).
}else{
}
