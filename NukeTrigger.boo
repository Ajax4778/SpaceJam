import UnityEngine

class NukeTrigger (MonoBehaviour): 

	public detonate = false		// Boolean to determine whether nuke has detonated.
	private detScale = 4.0f		// Scale of expansion on detonation.
	private detSpeed = 2.0f		// Speed of nuke after detonation.

	
	def Update ():
		if detonate == true:
			GetComponent[of Rigidbody]().isKinematic = true
			GetComponent[of Rigidbody]().constraints = (RigidbodyConstraints.FreezePositionY | RigidbodyConstraints.FreezePositionZ | RigidbodyConstraints.FreezeRotation)
			transform.localScale += Vector3(0, 0, detScale)			//Explode on detonation, expand on z-axis, which is the only relevant axis in this case.
			gameObject.GetComponent[of Light]().range += detScale						//The range of the nuke's light source also expands on detonation.
			transform.position.x += detSpeed						//Nuke moves at "detSpeed" along x-axis after detonation.
			gameObject.tag = ("Untagged")							//Set detonated nuke as "untagged" OffScreenObject that it interacts with ALL objects.
			gameObject.layer = 9									//Keep nuke in "Weapons" layer. Possibly redundant line of code if layer is already specfied manually.
			
	
	def OnTriggerEnter(other as Collider):			// On collision with other objects/colliders
		if other.gameObject.tag == ("asteroid"):
			nukedAst as Asteroid = other.gameObject.GetComponent[of Asteroid]() //Access script of nuked Asteroid
			nukedAst.BreakUp()													//Destroy the nuked asteroid, using the function "BreakUp"
																				//in class Asteroid.
			Ship.playerScore += 5
			detonate = true					//If undetonated nuke collides with asteroid, it should detonate. If it is already detonated
											//before the collision, detonate will remain "true".
		if other.gameObject.tag == ("miniAsteroid"):
			nukedMiniAst as miniAsteroid = other.gameObject.GetComponent[of miniAsteroid]()	//Access script of nuked mini-asteroid.
			nukedMiniAst.BreakUp()															//Destroy nuked mini-asteroid using BreakUp
																							//in class miniAsteroid.
			Ship.playerScore += 3
			detonate = true			// See note above; applies to all further "detonate = true".
		if other.gameObject.tag == ("robot"):
			nukedRobot as Robot = other.gameObject.GetComponent[of Robot]()		//Access script of detonated robot, as above for asteroid/mini-asteroid.
			nukedRobot.DestroyRobot()											//Destroy using DestroyRobot in class Robot.
			Ship.playerScore += 20
			detonate = true
		if other.gameObject.tag == ("turret"):
			nukedTurr as Turret = other.gameObject.GetComponent[of Turret]()	//Access script of nuked turret.
			nukedTurr.DestroyTurret()											//Destroy using DestroyTurret in class Turret.
			Ship.playerScore += 50
			detonate = true
		if detonate == true:
			//Below code destroys all bonus items that a detonated nuke encounters, and also destroys the projectiles shot by turrets ("turretShot").
			if other.gameObject.tag == ("missileAmmo") or other.gameObject.tag == ("nukeAmmo") or other.gameObject.tag == ("healthPack") or other.gameObject.tag == ("turretShot"):
				Destroy(other.gameObject)