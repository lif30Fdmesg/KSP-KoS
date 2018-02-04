 
function main{
	
	clearscreen.
	
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
	
	lock tarVec to target:position - ship:position.
	lock steering to tarVec:normalized.
	lock optSpeed to sqrt(1.4*ship:sensors:temp*287.053).
	lock speed to sqrt(ship:groundspeed^2 + ship:verticalspeed^2).
	lock throttle to 1.
	set target to vessel("Station1.0").
	
	// wait until ship:partsnamed("liquidengineminiturbo")[0]:children:length = 0 or ship:partsnamed("stackseparatormini")[0]:children:length = 0.
	// stage.
	
	until false{
		print "Speed: "+speed at(0,0).
		print "OptSpeed: "+optSpeed at(0,1).
		
		if(ship:altitude < 13000){
			if(speed > optSpeed){
				if speed > optSpeed + 10{
					set tmp to throttle.
					if throttle > 0{
						lock throttle to 0.
					}
				}else if speed > optSpeed + 5{
					set tmp to throttle.
					if throttle >= 0.1{
						lock throttle to tmp - 0.1.
					}
				}else{
					set tmp to throttle.
					if throttle >= 0.01{
						lock throttle to tmp - 0.01.
					}
				}
			}else{
				if speed < optSpeed - 10{
						set tmp to throttle.
						if throttle < 1{
						lock throttle to 1.
						}
					}else if speed > optSpeed - 5{
						set tmp to throttle.
						if throttle <= 0.9{
							lock throttle to tmp + 0.1.
						}
					}else{
						set tmp to throttle.
						if throttle <= 0.99{
							lock throttle to tmp + 0.01.
						}
					}
			}
		}else{
			lock throttle to 1.
		}
		
		
	}
	
	
}

main.