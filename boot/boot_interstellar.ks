
	if(addons:rt:hasconnection(ship)){	
		copypath("0:/interstellar1.0/landing.ks", "").
		copypath("0:/interstellar1.0/ascend.ks", "").
		copypath("0:/interstellar1.0/transfer.ks", "").
		copypath("0:/interstellar1.0/parking.ks", "").
		copypath("0:/interstellar1.0/tools.ks", "").
		copypath("0:/interstellar1.0/landing_probe.ks", "").
	}
	
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

if ship:orbit:body:name = "Kerbin" and ship:altitude < 300 {
	print "Starting ascend sequence...".
	run ascend(75000, 90).
}else{
}
