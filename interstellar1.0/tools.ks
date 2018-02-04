

//list ship:partsnamed("kzprocfairingside1") in shell.
set shell to ship:partsnamed("kzprocfairingside1").
from {declare local i is 0.} until i = shell:length step {set i to i+1.} do {
	ship:partsnamed("kzprocfairingside1")[i]:getmodule("proceduralfairingdecoupler"):doevent("jettison").
}
wait 1.

//list ship:partsnamed("1x3spanels") in sol.
set sol to ship:partsnamed("1x3spanels").
from {declare local i is 0.} until i = sol:length step {set i to i+1.} do {
	ship:partsnamed("1x3spanels")[i]:getmodule("moduledeployablesolarpanel"):doevent("extend solar panel").
}
set sol to ship:partsnamed("solarpanels2").
from {declare local i is 0.} until i = sol:length step {set i to i+1.} do {
	ship:partsnamed("solarpanels2")[i]:getmodule("moduledeployablesolarpanel"):doevent("extend solar panel").
}
wait 1.
//ship:partsnamed("minilandingleg")[0]:getmodule("modulewheeldeployment"):doevent("extend").
//ship:partsnamed("landingleg1")[0]:getmodule("modulewheeldeployment"):doevent("extend").
wait 1.
//run transfer.