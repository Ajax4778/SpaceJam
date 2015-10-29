import UnityEngine

class GameData (MonoBehaviour): 
	
	// Using an orthographic camera of size 43.8 units.
	
	// Setting min and max extent of visible screen. Player ship is constrained to this area.
	static public minHorizScreen = -85.0f
	static public maxHorizScreen = 85.0f
	static public minVertScreen = -42.0f
	static public maxVertScreen = 42.0f
	
	// Extension outside the visible screen for non-player objects to travel before
	// they are destroyed. (Without this, larger objects would be destroyed when they are still partly visible because
	// their centers are outside the visible extent of the screen.)
	static public objExt = 20.0f
	
	// Extension beyond the visible screen where asteroids and bonus items are generated.
	static public astGenExt = 10.0f
	
	// Min and max extent of game space, outside which all objects are destroyed.
	static public minHorizObj = minHorizScreen - objExt
	static public maxHorizObj = maxHorizScreen + objExt
	static public minVertObj = minVertScreen - objExt
	static public maxVertObj = maxVertScreen + objExt
