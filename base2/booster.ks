
when true then {
	for foo in ship:partsdubbed("proceduraltankliquid"){
	
		
		if foo:hasparent = false {
		
			ship:partsdubbed("rd180engine")[0].shutdown.
			
			set ship:control:fore to ship:facing:forevector.
			set ship:control:top to ship:facing:topvector.
			set ship:control:starboard to ship:facing:starvector.
		
			
			for foo1 in engines {
				if foo1:ignition = false{
					if (foo1:name <> "rd180engine") {foo1:activate.}
				}
			
			}
			
		}else preserve.
		
	}

}

wait until false.