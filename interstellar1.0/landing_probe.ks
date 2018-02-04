
//deploy parachutes
//deploy legs 
// start comunication (omni-directional)
// start elect. panels (6x1 pannels)


wait until ship:altitude < ship:orbit:body:atm:height.
sas off.
lock steering to srfprograde.
ship:partsdubbed("rc.stack")[0]:getmodule("realchutemodule"):doevent("arm parachute").
//ship:partsdubbed("rc.stack"):getmodule("realchutemodule"):doevent("deploy chute").
wait until ship:groundspeed < 100 or alt:radar < 3000.
ship:partsdubbed("minilandingleg")[0]:getmodule("modulewheeldeployment"):doevent("extend").
wait until ship:status = "landed".
lock steering to heading(0, -90).
wait until ship:verticalspeed < 0.01 and ship:groundspeed < 0.01.
unlock steering.
set sol to ship:partsnamed("solarpanels2").
from {declare local i is 0.} until i = sol:length step {set i to i+1.} do {
	ship:partsnamed("solarpanels2")[i]:getmodule("moduledeployablesolarpanel"):doevent("extend solar panel").
}

if(ship:partsdubbed("commdish"):length > 0){
	if(ship:partsdubbed("commdish")[0]:getmodule("modulertantenna"):getfield("status")="off"){
		ship:partsdubbed("commdish")[0]:getmodule("modulertantenna"):doevent("activate").
		ship:partsdubbed("commdish")[0]:getmodule("modulertantenna"):setfield("target", "kerbin").
	}
}

if(ship:partsdubbed("rtlongantenna2"):length > 0){
	if(ship:partsdubbed("rtlongantenna2")[0]:getmodule("modulertantenna"):getfield("status")="off"){
		ship:partsdubbed("rtlongantenna2")[0]:getmodule("modulertantenna"):doevent("activate").
	}
}

if(ship:partsdubbed("surfantenna"):length > 0){
	if(ship:partsdubbed("surfantenna")[0]:getmodule("modulertantenna"):getfield("status")="on"){
		ship:partsdubbed("surfantenna")[0]:getmodule("modulertantenna"):doevent("deactivate").
	}
}