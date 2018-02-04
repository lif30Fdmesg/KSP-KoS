


if(addons:rt:hasconnection(ship) = false){
	
	ship:partsnamed("commdish")[0]:getmodule("modulertantenna"):setfield("target", "ComSat1").
	ship:partsnamed("commdish")[1]:getmodule("modulertantenna"):setfield("target", "ComSat2").
	ship:partsnamed("commdish")[0]:getmodule("modulertantenna"):doaction("toggle", true).
	ship:partsnamed("commdish")[1]:getmodule("modulertantenna"):doaction("toggle", true).
	
	for foo in ship:partsnamed("rtlongantenna2"){

		foo:getmodule("modulertantenna"):doaction("toggle", true).

	}
}

wait 10.
if addons:rt:hasconnection(ship) = false reboot.

copypath("0:/docking/docking.ks", "").




