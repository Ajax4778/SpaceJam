import UnityEngine

class Ship (MonoBehaviour): 
    
    // navigation
	private shipThrust = 35.0f
	
	// related objects
	private astGen as GameObject
	private shipMesh as Renderer
	private weapon as ShipWeapon
	
	// health
	private maxHealth = 100.0f
	public curHealth = 100.0f
	public healthBarLen as single
	
	// damage received on collision with other objects
	private damageA = -35
	private damageMA = -20
	private damageR = -40
	private damageT = -100
	private damageTS = -60
	
	public explosion as GameObject
	public shipExpl as GameObject
	
	// bonus item pickup
	private addHealth = 25
	private addMiss = 5
	private addNuke = 1
	
	// player score and lives
	static public playerScore = 0
	private playerLives as single
	private gameOver = false
	private lifeLost = false			// to determine if the "Ship destroyed!" screen should display
		    
	def Start():
		healthBarLen = Screen.width / 3
		playerLives = 3
		astGen = GameObject.FindGameObjectWithTag("LevelGenerator") // caching AsteroidGenerator object
		shipMesh = gameObject.GetComponentInChildren[of Renderer]()	//	caching mesh renderer
		weapon = GameObject.Find("ShipWeapon").GetComponent[of ShipWeapon]() // caching ship's weapon
    
	def Update():
		
		//navigation
		if Input.GetKey("left") and transform.position.x > GameData.minHorizScreen:
			transform.Translate(Vector3.left * shipThrust * Time.deltaTime)
		if Input.GetKey("right") and transform.position.x < GameData.maxHorizScreen:
			transform.Translate(Vector3.right * shipThrust * Time.deltaTime)
		if Input.GetKey("up") and transform.position.z < GameData.maxVertScreen:
			transform.Translate(Vector3.forward * shipThrust * Time.deltaTime)
		if Input.GetKey("down") and transform.position.z > GameData.minVertScreen:
			transform.Translate(Vector3.back * shipThrust * Time.deltaTime)
		
		if lifeLost:
			if Input.GetKeyDown("e"):
				NewLife()
			if Input.GetKeyDown("q"):
				lifeLost = false
				gameOver = true
	
	def OnGUI():
		
		GUI.color = Color.green
		
		if curHealth > 50 and curHealth <= 75:
			GUI.color = Color.yellow
		if curHealth > 25 and curHealth <= 50:
			GUI.color = Color(1.0f,0.55f,0.0f,1.0f)     // orange
		if curHealth <= 25:
			GUI.color = Color.red
		
		if curHealth > 0:
			GUI.Button(Rect(75,10,healthBarLen,20), curHealth.ToString())
		
		GUI.color = Color.white
		GUI.Label(Rect(10,10,60,20), "Health:")
		
		// player score counter
		GUI.Label(Rect(Screen.width - 175, 10, 60, 20), "Score:")
		GUI.color = Color(0.4f,0.6f,1.0f,1.0f)
		GUI.Button(Rect(Screen.width - 110, 10, 100, 20), playerScore.ToString())
		
		//player lives counter
		GUI.color = Color.white
		GUI.Label(Rect(Screen.width - 175, 40, 60, 20), "Lives:")
		GUI.color = Color(0.4f,0.6f,1.0f,1.0f)
		if playerLives > 0:
			for life in range(0, playerLives):
				GUI.Label(Rect(Screen.width - 110 + (20*life), 40, 15, 20), "X")
		
		if gameOver == true:
			GUI.color = Color.red
			GUI.Button(Rect(Screen.width / 4, Screen.height / 4 , Screen.width / 2, Screen.height / 2), "GAME OVER \n \n \n Your score: " + playerScore.ToString())
		
		if lifeLost == true:
			GUI.color = Color.red
			GUI.Button(Rect(Screen.width / 4, Screen.height / 4 , Screen.width / 2, Screen.height / 2), "Ship destroyed! (E) to continue, (Q) to quit.")
	
	def HealthAdj(change as single):
		curHealth = curHealth + change
		if curHealth < 0: curHealth = 0
		if curHealth == 0:
			playerScore -= 500
			LoseLife()
		if curHealth > maxHealth:
			curHealth = maxHealth
		healthBarLen = (Screen.width / 3) * (curHealth/maxHealth)
		
	
	def OnCollisionEnter (other as Collision): // on collsion with other objects
		if other.gameObject.tag == ("asteroid"):
			HealthAdj(damageA)
		if other.gameObject.tag == ("miniAsteroid"):
			HealthAdj(damageMA)
		if other.gameObject.tag == ("robot"):
			HealthAdj(damageR)
			robExpl = Instantiate(explosion, transform.position, transform.rotation) as GameObject
			robExpl.transform.parent = transform
		if other.gameObject.tag == ("turret"):
			HealthAdj(damageT)
		if other.gameObject.tag == ("turretShot"):
			HealthAdj(damageTS)
			expl = Instantiate(explosion, transform.position, transform.rotation) as GameObject
			expl.transform.parent = transform
			Destroy(other.gameObject)
		
		if other.gameObject.tag == ("healthPack"):
			if curHealth < 100: HealthAdj(addHealth)
			elif playerLives < 5: playerLives += 1
			else: playerScore += 50
			Destroy(other.gameObject)
		if other.gameObject.tag == ("missileAmmo"):
			shipMiss as ShipWeapon = gameObject.GetComponentInChildren[of ShipWeapon]()
			if shipMiss.missileAmmo < shipMiss.maxMissileAmmo: shipMiss.missileAmmo += addMiss
			else: playerScore += 10
			Destroy(other.gameObject)
		if other.gameObject.tag == ("nukeAmmo"):
			shipNuke as ShipWeapon = gameObject.GetComponentInChildren[of ShipWeapon]()
			if shipNuke.nukeAmmo < shipNuke.maxNukeAmmo: shipNuke.nukeAmmo += addNuke
			else: playerScore += 25
			Destroy(other.gameObject)
	
	def LoseLife():
		Instantiate(shipExpl, transform.position, transform.rotation)	// Instantiates explosion in place of ship
		gameObject.GetComponent[of Collider]().enabled = false								// Disables ship collider
		shipMesh.enabled = false										// Disables ship renderer
		transform.position = Vector3(GameData.minHorizScreen - GameData.objExt,0,0)	// Moves disabled ship to leftmost extent of game space
		playerLives -= 1
		if playerLives < 0:
			lifeLost = false
			gameOver = true
			Time.timeScale = 0
		else: lifeLost = true
		
		astGen.SetActive(false)					// Deactivates asteroid generation
		weapon.enabled = false					// Disables ship weapons
	
	
	def NewLife():
		if playerLives >= 0:
			HealthAdj(maxHealth)
			weapon.missileAmmo = weapon.startMissileCount
			weapon.nukeAmmo = weapon.startNukeCount
		lifeLost = false
		gameObject.GetComponent[of Collider]().enabled = true
		shipMesh.enabled = true
		transform.position = Vector3(0,0,0)		// Moves new ship to center of screen
		
		astGen.SetActive(true)					// Reactivates asteroid generation
		weapon.enabled = true
		
		// Changes to consider:
		// Ship is not invulnerable to damage when a new life begins, which means that
		// if there is an asteroid near the center when the ship is re-enabled, it may be
		// damaged immediately. The ship should be invulnerable for a few seconds
		// when a new life is started, so that the player can get his or her bearings.