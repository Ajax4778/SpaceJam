import UnityEngine

class Missile (MonoBehaviour): 
	
	public missileExplosion as GameObject
	static public damageMissile = -60 // sets damage inflicted by missile.

	def Start ():
		pass
	
	def Update ():
		pass
	
	def OnTriggerEnter(other as Collider): // on collision with a collider such as asteroid, player ship, etc
		if other.gameObject.tag == ("asteroid"):
			Instantiate(missileExplosion, other.gameObject.transform.position, other.gameObject.transform.rotation)
			Destroy(gameObject)
			Destroy(other.gameObject)
			Ship.playerScore += 5
		if other.gameObject.tag == ("miniAsteroid"):
			Instantiate(missileExplosion, other.gameObject.transform.position, other.gameObject.transform.rotation)
			Destroy(gameObject)
			Destroy(other.gameObject)
			Ship.playerScore += 5
		if other.gameObject.tag == ("robot"):
			Instantiate(missileExplosion, other.gameObject.transform.position, other.gameObject.transform.rotation)
			Destroy(gameObject)
			Rob as Robot = other.gameObject.GetComponent[of Robot]()
			Rob.DestroyRobot()
			Ship.playerScore += 50
		if other.gameObject.tag == ("turret"):
			Instantiate(missileExplosion, other.gameObject.transform.position, other.gameObject.transform.rotation)
			Destroy(gameObject)
			Turr as Turret = other.gameObject.GetComponent[of Turret]()
			Turr.Damage(damageMissile)
			Ship.playerScore += 50