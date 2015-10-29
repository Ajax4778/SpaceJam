import UnityEngine

class BonusGenerator (MonoBehaviour): 
	
	public health as GameObject
	public missAmmo as GameObject
	public nukeAmmo as GameObject
	
	private speed as double
	private maxBonusSpeed = 50.0f
	private minBonusSpeed = 5.0f
	
	private bonusTimer = 15.0
	private bonusCoolDown as double
	
	private bonusHeight = 4.0 		// Bonus objects travel above the game's plane
									// at a height of "bonusHeight", so that they
									// remain in front of other objects in the game view.
	
	def Start ():
		bonusCoolDown = bonusTimer		// sets a cool down time of "bonusCoolDown" between each instance
										// of bonus object generation.
	
	def Update ():
		if bonusCoolDown > 0: bonusCoolDown -= Time.deltaTime
		if bonusCoolDown <= 0:
			bonusCoolDown = 0
			if AsteroidGenerator.startScreen == false: BonusGen()  // to prevent generation of bonus items during the start screen
	
	def BonusGen():
		x = Random.Range(GameData.maxHorizScreen + GameData.astGenExt, GameData.maxHorizObj)
		z = Random.Range(GameData.minVertScreen, GameData.maxVertScreen)
		speed = Random.Range(minBonusSpeed, maxBonusSpeed)
		
		select = Random.Range(0,100) //to determine which Bonus is generated
		if select <= 15:
			healthClone = Instantiate(health, Vector3(x, bonusHeight, z), Quaternion.identity) as GameObject
			healthClone.transform.Rotate(Random.Range(0, 360), Random.Range(0, 360), Random.Range(0, 360))
			healthClone.GetComponent[of Rigidbody]().velocity = Vector3.left * speed
			healthClone.tag = ("healthPack")
		elif select <= 40:
			nukeClone = Instantiate(nukeAmmo, Vector3(x, bonusHeight, z), Quaternion.identity) as GameObject
			nukeClone.transform.Rotate(Random.Range(0, 360), Random.Range(0, 360), Random.Range(0, 360))
			nukeClone.GetComponent[of Rigidbody]().velocity = Vector3.left * speed
			nukeClone.tag = ("nukeAmmo")
		elif select <= 85:
			missClone = Instantiate(missAmmo, Vector3(x, bonusHeight, z), Quaternion.identity) as GameObject
			missClone.transform.Rotate(Random.Range(0, 360), Random.Range(0, 360), Random.Range(0, 360))
			missClone.GetComponent[of Rigidbody]().velocity = Vector3.left * speed
			missClone.tag = ("missileAmmo")
		bonusCoolDown = bonusTimer