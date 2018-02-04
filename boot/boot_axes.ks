
set counter to 0.

when true then {

	set counter to counter + 1.

	if counter = 10{
	set counter to 0.
		clearvecdraws().
		set z to vecdraw(
				v(0,0,0),
				ship:facing:forevector,
				rgb(0,0,1),
				"Z",
				10,
				true,
				0.01	
			).
		set y to vecdraw(
			v(0,0,0),
			ship:facing:topvector,
			rgb(0,1,0),
			"Y",
			10,
			true,
			0.01
		).
		set x to vecdraw(
			v(0,0,0),
			ship:facing:starvector,
			rgb(1,0,0),
			"X",
			10,
			true,
			0.01	
		).
	}
	preserve.
}


until false {}.



