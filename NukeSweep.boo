import UnityEngine

class NukeSweep (MonoBehaviour): 
	
	//NukeSweep is NOT the default script for nukes.
	//NukeSweep sets up the nuke as a physical collider
	//that detonates on contact with an asteroid
	//and sweeps all asteroids out to the right.
	//Although NukeSweep is attached to the Nuke prefab, 
	//it is disabled by default.
	//NukeSweep does not contain nuke sound effects, and
	//may not be compatible with all scripts. NukeSweep
	//is simply an illustrative program (it was
	//written before NukeTrigger) to show multiple
	//ways of acheiving similar outcomes.
	
	//See the NukeTrigger script for a Nuke with controlled
	//detonation and a trigger collider to destroy asteroids.
	//NukeTrigger is the default script (and the recommended
	//script) for the Nuke object.
	
	//Enable EITHER NukeSweep OR NukeTrigger, NOT BOTH.

	public detonate = false
	private detScale = 4.0f
	private detSpeed = 2.0f

	def Start ():
		pass
	
	def Update ():
		if detonate == true:
			gameObject.layer = 0
			GetComponent[of Rigidbody]().isKinematic = true
			GetComponent[of Rigidbody]().constraints = (RigidbodyConstraints.FreezePositionY | RigidbodyConstraints.FreezePositionZ | RigidbodyConstraints.FreezeRotation)
			transform.localScale += Vector3(0, 0, detScale)
			gameObject.GetComponent[of Light]().range += detScale
			transform.position.x += detSpeed
	
	def OnCollisionEnter(other as Collision):
		if other.gameObject.tag == ("asteroid") or other.gameObject.tag == ("miniAsteroid"):
			detonate = true
		if other.gameObject.tag == ("miniAsteroid"):
			detonate = true