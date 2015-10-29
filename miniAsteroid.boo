import UnityEngine

class miniAsteroid (MonoBehaviour): 
	
	// Read class Asteroid for explanatory notes before reading this class.
	// Most notes in that class apply to this one.

	public speed as double
	public direc as Vector3
	
	private destroy as bool
	private outScreen as bool
	
	private astHealth = 10
	
	// damage received on collision with other objects
	private damageA = -4
	private damageMA = -1
	private damageS = -10
	
	// mini-asteroids break up into rubble
	public rubble as GameObject
	private minRubble = 5
	private maxRubble = 10
	private minSpeedR = 30.0f
	private maxSpeedR = 55.0f
	


	def Start ():
		
		speed = GetComponent[of Rigidbody]().velocity.magnitude
			
	def Update ():
		GetComponent[of Rigidbody]().velocity = GetComponent[of Rigidbody]().velocity.normalized * speed
		
		if astHealth == 0:
			BreakUp()
	
	def OnCollisionEnter (astColl as Collision):
		if astColl.gameObject.tag == ("asteroid"):
			Damage(damageA)
		if astColl.gameObject.tag == ("miniAsteroid"):
			Damage(damageMA)
		if astColl.gameObject.tag == ("Player"):
			Ship.playerScore -= 10
			Damage(damageS)
			
			
	def Damage(reduce as single):
		astHealth = astHealth + reduce
		if astHealth < 0:
			astHealth = 0
	
	def BreakUp ():
		for i in range(1, Random.Range(minRubble, maxRubble)):
				speedR = Random.Range(minSpeedR, maxSpeedR)
				clone as GameObject
				clone = Instantiate(rubble, Vector3(transform.position.x, 0, transform.position.z), Quaternion.identity)
				clone.GetComponent[of Rigidbody]().velocity = GetComponent[of Rigidbody]().velocity.normalized * speedR
			Destroy(gameObject)
