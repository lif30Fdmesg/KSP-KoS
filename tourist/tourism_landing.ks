lock steering to ship:srfretrograde.
set warpmode to "rails".
set warp to 3.
wait until ship:longitude > -120 and ship:longitude < -110.
set warp to 2.
wait until ship:longitude > -100 and ship:longitude < -95.
set warp to 1.
wait until ship:longitude > -93 and ship:longitude < -92.
set warp to 0.
wait until ship:longitude > -88.3 and ship:longitude < -88.
set warpmode to "physics".
ag1 on.
lock throttle to 1.
wait until sqrt(ship:verticalspeed^2+ship:groundspeed^2) < 900.
lock throttle to 0.
wait 1.
lock steering to prograde.
wait 10.
stage.
wait 10.
lock steering to ship:srfretrograde.
wait until ship:altitude < ship:orbit:body:atm:height - 5000.
set warp to 3.
wait until ship:altitude < 7000.
unlock steering.
wait until alt:radar < 50.
set warp to 0.
wait until ship:status = "LANDED" or ship:status = "splashed".
if (ship:status = "landed" ) lock steering to UP.
