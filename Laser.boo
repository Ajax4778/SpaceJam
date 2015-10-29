import UnityEngine

class Laser (MonoBehaviour): 
	
	static public damageLaser = -6	// sets damage inflicted by laser

	def Start ():
		pass
	
	def Update ():
		pass
	
	def OnTriggerEnter(other as Collider):
		if other.gameObject.tag == ("asteroid"):
			Ast as Asteroid = other.gameObject.GetComponent[of Asteroid]()
			Ast.Damage(damageLaser)
			Ship.playerScore += 2
			Destroy(gameObject)
		if other.gameObject.tag == ("miniAsteroid"):
			MiniAst as miniAsteroid = other.gameObject.GetComponent[of miniAsteroid]()
			MiniAst.Damage(damageLaser)
			Ship.playerScore += 1
			Destroy(gameObject)
		if other.gameObject.tag == ("robot"):
			Rob as Robot = other.gameObject.GetComponent[of Robot]()
			Rob.Damage(damageLaser)
			Ship.playerScore += 10
			Destroy(gameObject)
		if other.gameObject.tag == ("turret"):
			Turr as Turret = other.gameObject.GetComponent[of Turret]()
			Turr.Damage(damageLaser)
			Ship.playerScore += 10
			Destroy(gameObject)