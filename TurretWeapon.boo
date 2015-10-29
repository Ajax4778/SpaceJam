import UnityEngine

class TurretWeapon (MonoBehaviour): 
	
	// NOTE: All instances of "missile" in this class refer to the red spheres shot by Turrets,
	// and not the blue capsules shot by the Player.
	
	public missile as GameObject
	public target as Transform
	private turretTransform as Transform
	private direc as Vector3

	private missileSpeed = 150
	private missileTimer = 1.5f
	private missileCoolDown = 1.5f
	
	
	def Start ():
		turretTransform = transform											// Cache turret transform
		target = GameObject.FindGameObjectWithTag("Player").transform		// Sets turret target as Player
	
	def Update ():
		direc = target.position - turretTransform.position

		FireMissile()
		
		if missileCoolDown > 0:
			missileCoolDown -= Time.deltaTime


	def FireMissile():
		if missileCoolDown <= 0:
			mShot = Instantiate(missile, transform.position, transform.rotation) as GameObject
			mShot.transform.Rotate(90,0,0)
			mShot.GetComponent[of Rigidbody]().velocity = direc.normalized * missileSpeed
			missileCoolDown = missileTimer