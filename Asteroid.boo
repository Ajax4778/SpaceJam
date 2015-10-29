import UnityEngine

class Asteroid (MonoBehaviour): 
	
	public speed as single
	public direc as Vector3
	
	// setting range of asteroid speeds
	private minSpeed = 10.0f
	private maxSpeed = 35.0f
	
	// setting angular range of generated asteroids' directions,
	// along the x and z axes
	private minXRot = -1.0f
	private maxXRot = 0.0f
	private minZRot = -0.5f
	private maxZRot = 0.5f
	
	
	public destroy as bool			//boolean to determine if asteroid should be destroyed
	private outScreen as bool		//boolean to determine if asteroid has left the screen limits
	
	private astHealth = 30			// hit points of asteroid
	
	//damage received on collision with other objects
	private damageA = -3	//on collision with other asteroids
	private damageMA = -1	//on collision with mini asteroids
	private damageS = -30	//on collision with player ship
	
	//breaking up into mini asteroids
	public miniAst as GameObject
	private minBreakUp = 3		//min number of mini-asteroids created on breakup
	private maxBreakUp = 6		//max number of miniAsteroid-asteroids created on breakup
	private minSpeedMA = 20.0f	//min speed of mini-asteroids
	private maxSpeedMA = 45.0f	//max speed of mini-asteroids
	

	def Start ():
		speed = Random.Range(minSpeed, maxSpeed)		// assigns random speed within specified range
		direc = Vector3(Random.Range(minXRot, maxXRot), 0, Random.Range(minZRot, maxZRot))		//assigns random direction within specified range
		GetComponent[of Rigidbody]().velocity = direc.normalized * speed	// assigns velocity based on above speed and direction
			
	def Update ():
		GetComponent[of Rigidbody]().velocity = GetComponent[of Rigidbody]().velocity.normalized * speed	// prevents loss of energy due to collisions by keeping asteroid speed constant
		
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
		
			
	def Damage(reduce as single):		// Function to reduce asteroid hitpoints by the argument "reduce",
										// based on collision damage variables above
		astHealth = astHealth + reduce
		if astHealth < 0:
			astHealth = 0		// to prevent negative hitpoints
	
	def BreakUp ():
		for i in range(1, Random.Range(minBreakUp, maxBreakUp)):
			// Code below assigns random position for each mini-asteroid relative to the position
			// of the original asteroid. Also assigns speed within specified range.
			x = Random.Range(transform.position.x - 1, transform.position.x + 1)
			z = Random.Range(transform.position.z - 1, transform.position.z + 1)
			speedMA = Random.Range(minSpeedMA, maxSpeedMA)
			clone as GameObject
			clone = Instantiate(miniAst, Vector3(x, 0, z), Quaternion.identity) 	// Instantiates clones of the mini-asteroid object,
																					// with position and speed specified above.
			clone.GetComponent[of Rigidbody]().velocity = GetComponent[of Rigidbody]().velocity.normalized * speedMA
		Destroy(gameObject)
	
		// Future changes:
			// Sound effects for asteroid destruction. The audio file
			// will probably need to be played from a source other than the asteroid,
			// because the sound should not abruptly stop once the asteroid object
			// is destroyed.
		