import UnityEngine

// Destroys any object that leaves the maximum extent of the game space as defined in the GameData class.

class OffScreenObject (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		if transform.position.x < GameData.minHorizObj or transform.position.x > GameData.maxHorizObj or transform.position.z < GameData.minVertObj or transform.position.z > GameData.maxVertObj:
			Destroy(gameObject)
		
		