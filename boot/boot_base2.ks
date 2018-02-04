
	if(addons:rt:hasconnection(ship)){	
		copypath("0:/base2/ascend.ks", "").
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
				if (act_eng[x]:availablethrust < 300) set bool to true.
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
	

if ship:orbit:body:name = "Kerbin" and ship:altitude < 300 {
	print "Starting ascend sequence...".
	run ascend(75000, 90).
}else{
}
