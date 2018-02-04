function translate{
	
	declare parameter vector is v(0,0,0).
	if vector:mag > 1 vector:normalized.
	 	
	set ship:control:fore to vector * ship:facing:forevector.
	set ship:control:starboard to vector * ship:facing:starvector.
	set ship:control:top to vector * ship:facing:topvector.

}

function killVelocity{
	sas off.
	rcs on.
	lock relativeVelocity to ship:velocity:orbit - target:velocity:orbit.
	until relativeVelocity:mag < 0.1 {		
		translate(-1 * relativeVelocity).
		clearvecdraws().
	}
	translate(v(0,0,0)).
	
	if ship:dockingports:length <> 0{
		for foo in ship:dockingports{
			if foo:state = "ready" set dockingPort to foo.
		}
	}
		
	for foo in target:dockingports{
		if foo:state = "ready" and (foo:nodetype = dockingPort:nodetype){
			set targetPort to foo.
			set check to true.
			break.
		}
		set check to false.
	}
	
	if check = false {
		return -1.
	}
	translate(v(0,0,0)).
	rcs off.
	
}

function facePort{
	
	declare parameter dockingPort.
	dockingPort:getmodule("ModuleDockingNode"):doevent("control from here").
	
	rcs on.
		
	lock steering to -1 * targetPort:portfacing:vector.
	wait until vang(ship:facing:vector, -1 * targetPort:portfacing:vector) < 5.
	rcs off.
	clearvecdraws().
	translate(v(0,0,0)).
	return targetPort.
}

function approachPort{

	declare parameter distance is 0.
	declare parameter speed is 1.
		
	rcs on.
	lock steering to target:position.
	lock aproachVector to targetPort:nodeposition - dockingPort:nodeposition + (targetPort:portfacing:vector*distance).
	until ship:dockingports[0]:state <> "ready" {
		lock distanceVector to targetPort:nodeposition - dockingPort:nodeposition.
		translate(aproachVector:normalized*speed - (ship:velocity:orbit - target:velocity:orbit)).
		if vang(ship:facing:forevector, distanceVector) < 5 and abs(distanceVector:mag - distance) < 1 {			
			translate(aproachVector * speed - (ship:velocity:orbit - target:velocity:orbit)).
		}
		if vang(ship:facing:forevector, distanceVector) < 1 and abs(distanceVector:mag - distance) < 0.1 {			
			break.		
		}
		clearvecdraws().
	}
	rcs off.
	translate(v(0,0,0)).
}

function finalAproach{

	declare parameter distance to 5.
	declare parameter speed to 5.
	declare parameter aproachSpeed to 0.1.
	
	rcs on.
	lock aproachVector to targetPort:nodeposition - dockingPort:nodeposition + (targetPort:portfacing:vector*distance).
	until ship:dockingports[0]:state <> "ready" {
		lock distanceVector to targetPort:nodeposition - dockingPort:nodeposition.
		translate(aproachVector:normalized*speed - (ship:velocity:orbit - target:velocity:orbit)).
		if vang(ship:facing:forevector, distanceVector) < 5 and abs(distanceVector:mag - distance) < 1 {			
			translate(aproachVector:normalized * speed - (ship:velocity:orbit - target:velocity:orbit)).
		}
		if vang(ship:facing:forevector, distanceVector) < 1 and abs(distanceVector:mag - distance) < 0.1 {			
			until targetPort:nodeposition:mag - dockingPort:nodeposition:mag < 0.5{	
				translate(aproachVector * speed - (ship:velocity:orbit - target:velocity:orbit)).
				set distance to distance - aproachSpeed/10.
				wait 0.1.
			}
			break.
		}
	
		clearvecdraws().
	}
	rcs off.
	translate(v(0,0,0)).
	set ship:control:neutralize to true.

}


function preDocking{

  parameter distance, speed.
  dockingPort:getmodule("ModuleDockingNode"):doevent("control from here").

  LOCK sideDirection TO targetPort:SHIP:FACING:STARVECTOR.
  IF abs(sideDirection * targetPort:PORTFACING:VECTOR) = 1 {
    LOCK sideDirection TO targetPort:SHIP:FACING:TOPVECTOR.
  }
  LOCK distanceOffset TO sideDirection * distance.
  if (target:position - ship:position - distanceOffset):mag > (target:position - ship:position + distanceOffset):mag{
  
	lock distanceOffset to -1 * sideDirection* distance.
  
  }
  
  rcs on.
  lock steering to target:position - ship:position.
  LOCK approachVector TO targetPort:NODEPOSITION - dockingPort:NODEPOSITION + distanceOffset.
  LOCK relativeVelocity TO SHIP:VELOCITY:ORBIT - targetPort:SHIP:VELOCITY:ORBIT.

  UNTIL FALSE {
    translate((approachVector:normalized * speed) - relativeVelocity).
	if approachVector:MAG < 20{
		translate((approachVector:normalized * 5) - relativeVelocity).
	}else if approachVector:MAG < 10{
		translate((approachVector:normalized) - relativeVelocity).
	}
	IF approachVector:MAG < 2 BREAK.
    	
  }

  translate(V(0,0,0)).
  rcs off.
  

}



function main{


	killVelocity.
	preDocking(200,10).
	approachPort(80,5).
	approachPort(60,5).
	approachPort(40,5).
	approachPort(20,5).
	approachPort(10,2).
	finalAproach(5,1, 0.1).
	
	
	
	
}

main.