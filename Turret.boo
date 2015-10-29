import UnityEngine

class Turret (MonoBehaviour): 
	
	public target as Transform
	private turretTransform as Transform
	private direc as Vector3
	
	private turretSpeed = 40
	private rotationSpeed = 5  
	private turretHealth = 180
	
	public turretExpl as GameObject
	
	public extraLife as GameObject
	private extraLifeSpeed = 25.0f
	private extraLifeAppear = false
	
	def Start ():
		turretTransform = transform // Cache turret's transform
		target = GameObject.FindGameObjectWithTag("Player").transform // Set turret's target as Player
				
	def Update ():
		direc = target.position - turretTransform.position
		turretTransform.rotation = Quaternion.Slerp(turretTransform.rotation, Quaternion.LookRotation(direc), rotationSpeed * Time.deltaTime)
		// above line rotates the turret to face Player's ship
		
	def FixedUpdate():
		GetComponent[of Rigidbody]().velocity = Vector3.left * turretSpeed
			
	
	def Damage(reduce as single):
		turretHealth = turretHealth + reduce
		if turretHealth <= 0:
			extraLifeAppear = true
			DestroyTurret()
			
	def OnCollisionEnter(other as Collision):
		if other.gameObject.tag == ("Player"):
			DestroyTurret()
	
	def DestroyTurret():
		Instantiate(turretExpl, transform.position, transform.rotation)
		Ship.playerScore += 200
		if extraLifeAppear:
			life = Instantiate(extraLife, transform.position, transform.rotation) as GameObject
			life.GetComponent[of Rigidbody]().velocity = Vector3.left * extraLifeSpeed
			// Known bug: multiple extraLife objects are sometimes created, due to weapons (like Laser) colliding
			// with Turret within the brief period that Turret is being destroyed.
			// Problem could be solved by placing extraLife in a new layer, but a simpler solution
			// is probably possible. Or, even simpler, Turrets could be made invulnerable to lasers.
		Destroy(gameObject)