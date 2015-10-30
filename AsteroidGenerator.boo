import UnityEngine

class AsteroidGenerator (MonoBehaviour): 
	
	private minAst = 5
	private maxAst = 10
	
	private astTimer = 2.0
	private astCoolDown as double
	// astTimer setting defaults to
	// Moderate difficulty level.
	
	private robotProb = 0.15
	// probability of Robot generation.
	
	private turretProb = 0.08
	// probability of Turret generation
	
	public static startScreen = true		//boolean to determine if the starting screen is displayed
	public pauseGame = false				//boolean to determine if game is paused
	
	// difficulty levels
	private diffEasy = 3.0
	private diffModerate = 2.0
	private diffHard = 1.0
	private diffImpossible = 0.5
	private diffLevel as string

	
	public asteroid as Asteroid
	public robot as Robot
	public turret as Turret
	
	def Awake ():
		Time.timeScale = 0
		startScreen = true		// start screen is displayed on awake

	def Start ():
		astCoolDown = astTimer
		
	
	def Update ():
		if startScreen == true:
			if Input.GetKeyDown("1"):
				StartGame(diffEasy)
			if Input.GetKeyDown("2"):
				StartGame(diffModerate)
			if Input.GetKeyDown("3"):
				StartGame(diffHard)
			if Input.GetKeyDown("4"):
				StartGame(diffImpossible)

		if astCoolDown > 0: astCoolDown -= Time.deltaTime
		if astCoolDown <= 0:
			astCoolDown = 0
			if startScreen == false: AstGen()
		
		if Input.GetKeyDown("p") and not startScreen:
			pauseGame = not pauseGame
			if Time.timeScale == 1: Time.timeScale = 0
			else: Time.timeScale = 1		
		
	
	def OnGUI():
		if startScreen == true:
			GUI.color = Color.cyan
			GUI.Button(Rect(Screen.width / 4, Screen.height / 8 , Screen.width / 2, Screen.height / 3), "SpaceJam 2013 \n \n Choose difficulty level by number: \n [1] Were it so easy. \n [2] Less than twelve parsecs. \n [3] Don't panic. \n [4] Resistance is futile.")
			GUI.Button(Rect(Screen.width / 4, Screen.height * 0.55, Screen.width / 2, Screen.height / 3), "Thrusters: [arrow keys]    Lasers: [spacebar]    Missiles: [M]  \n \n  Nukes: [N] to deploy and [N] again to detonate \n \n Pause: [P] ")
		
		if startScreen == false:
			GUI.color = Color.white
			GUI.Label(Rect(10,85,60,20), "Difficulty:")
			GUI.Label(Rect(75,85,70,20), diffLevel)
		
		if pauseGame and not startScreen:
			GUI.color = Color.cyan
			GUI.Button(Rect(Screen.width / 4, Screen.height / 4 , Screen.width / 2, Screen.height / 2), "PAUSED: Press P to continue.")
							
	def StartGame(diff as double):
		astTimer = diff
		startScreen = false
		levels = {3.0:'Easy', 2.0:'Moderate', 1.0:'Hard', 0.5:'Impossible'}
		diffLevel = levels[diff]
		Time.timeScale = 1
	
	def AstGen ():		//asteroid generation
		for i in range(1, Random.Range(minAst, maxAst)):
			x = Random.Range(GameData.maxHorizScreen + GameData.astGenExt, GameData.maxHorizObj)
			z = Random.Range(GameData.minVertScreen, GameData.maxVertScreen)
			astClone = Instantiate(asteroid, Vector3(x, 0, z), Quaternion.identity) as Asteroid
			astClone.transform.Rotate(Random.Range(0, 360), Random.Range(0, 360), Random.Range(0, 360))
			astCoolDown = astTimer
		//set condition for robot generation
		if Random.Range(0,100) < robotProb * 100:
			robotClone = Instantiate(robot, Vector3(x, 0, z), Quaternion.identity) as Robot
			robotClone.transform.Rotate(Random.Range(0, 360), Random.Range(0, 360), Random.Range(0, 360))
		//set condition for turret generation
		if Random.Range(0,100) < turretProb * 100:
			Instantiate(turret, Vector3(x, 0, z), Quaternion.identity)