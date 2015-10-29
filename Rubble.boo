import UnityEngine

class Rubble (MonoBehaviour): 

	public speed as double
	public direc as Vector3
	
	private outScreen as bool
			

	def Start ():
		speed = GetComponent[of Rigidbody]().velocity.magnitude
			
	def Update ():
		GetComponent[of Rigidbody]().velocity = GetComponent[of Rigidbody]().velocity.normalized * speed //Maintains constant speed despite collisions
	
	def OnCollisionEnter (astColl as Collision):
		//If rubble collides with any object, it is destroyed.
		//This code is redundant in the default setting, in which rubble is in a separate layer
		//called "Rubble" that does not collide with any of the other layers.
		if astColl.gameObject.tag == ("asteroid"):
			Destroy(gameObject)
		if astColl.gameObject.tag == ("miniAsteroid"):
			Destroy(gameObject)
		if astColl.gameObject.tag == ("Player"):
			Destroy(gameObject)
		if astColl.gameObject.tag == ("nuke"):
			Destroy(gameObject)
		
	
	