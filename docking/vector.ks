 // declare parameter sh_base is ship.
 // declare parameter v1_base is v(0,0,0).
 
 
// function vec{
	// declare parameter sh is ship.
	// declare parameter v1 is v(0,0,0).

	// vecdraw(
		// ship:position,
		// v1,
		// rgb(0,1,1),
		// "",
		// 10,
		// true,
		// 0.01
	// ).
	
	
// }


// vec(sh_base, v1_base).

set counter to 0.

when true then{

	if counter > 10 {
	
		clearvecdraws().
		vecdraw(
			ship:position,
			target:position - ship:position,
			YELLOW,
			"",
			1,
			true,
			0.2
		).
		set counter to 0.
		
	}

	set counter to counter + 1.	

	preserve.
}

wait until false.
