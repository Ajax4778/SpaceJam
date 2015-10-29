import UnityEngine

class Robot (MonoBehaviour):
	
	public target as Transform
	private robTransform as Transform
	private distance as Vector3
	
	//private robotThrust = 10000
	private robotHealth = 60
	
	// setting robot speed range and attack speed
	private minSpeed = 15.0f
	private maxSpeed = 30.0f
	private attackSpeed = 75.0f
	
	// setting angular range of generated robots' directions
	private minXRot = -1.0f
	private maxXRot = 0.0f
	private minZRot = -0.5f
	private maxZRot = 0.5f
	
	// boolean to determine whether robot has been activated
	private activate = false
	
	public robotMaterial as Material
	public astMaterial as Material
	public robotExpl as GameObject
	public robotAsteroid as Asteroid
	
	def Start ():
		robTransform = transform 											// cache the robot's tranform
		target = GameObject.FindGameObjectWithTag("Player").transform		// set robot's target as Player
		
		speed = Random.Range(minSpeed, maxSpeed)
		direc = Vector3(Random.Range(minXRot, maxXRot), 0, Random.Range(minZRot, maxZRot))
		GetComponent[of Rigidbody]().velocity = direc.normalized * speed
		
			
	def FixedUpdate():
		
		if activate:
			//robotPos.position = Vector3.MoveTowards(robotPos.position, target.position, (robotThrust/distance.magnitude) * Time.deltaTime)
			GetComponent[of Rigidbody]().velocity = distance.normalized * attackSpeed
		else:
			GetComponent[of Rigidbody]().velocity = GetComponent[of Rigidbody]().velocity.normalized * GetComponent[of Rigidbody]().velocity.magnitude 
			// If robot is deactivated and becomes a normal asteroid
			// it maintains the speed it had as a robot.
			// Otherwise, the deactivated robot would have zero velocity as an asteroids, since
			// asteroids get their speed from class AsteroidGenerator and not from their own Asteroid scripts.
			
	def Update():
		
		distance = target.position - robTransform.position
		if distance.magnitude < 75: activate = true		// robot activates on proximity to Player

		if robotHealth <= 0:
			DestroyRobot()
		
		if robTransform.position.x < target.position.x:
			activate = false // Robot deactivates and becomes a normal asteroid if it passes the Player's x position.
		
		if activate:
			gameObject.GetComponent[of Renderer]().material = robotMaterial // Robot de-cloakes on activation to reveal itelf.
		else:
			gameObject.GetComponent[of Renderer]().material = astMaterial

	def OnCollisionEnter (other as Collision):
		if other.gameObject.tag == ("Player"):
			Ship.playerScore -= 25
			DestroyRobot()
			
	def Damage(reduce as single):
		robotHealth = robotHealth + reduce 
		if robotHealth < 0:
			robotHealth = 0
	
	def DestroyRobot():
		Instantiate(robotExpl, transform.position, transform.rotation)
		Destroy(gameObject)