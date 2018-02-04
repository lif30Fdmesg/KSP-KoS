

if(addons:rt:hasconnection(ship)){
	copypath("0:/ComSat1_0/ascend.ks", "").
}

if(ship:altitude <= ship:orbit:body:atm:height) run ascend.