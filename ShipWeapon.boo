import UnityEngine

class ShipWeapon(MonoBehaviour):

	# laser
	public laser as GameObject
	private laserSpeed = 200.0f
	private maxLaserFire = 5
	
	private laserTimer = 0.0
	private laserCoolDown = 1.0
	public laserSoundEnabled = true
	public laserSound as AudioClip
	
	# missile
	public missile as GameObject
	private missileSpeed = 120.0f
	public missileAmmo as single
	public maxMissileAmmo = 40
	public startMissileCount = 5
	public missileLaunchSound as AudioClip
	public emptyClipSound as AudioClip
	
	# nuke
	public nuke as GameObject
	private nukeSpeed = 50.0f
	public nukeAmmo as single
	public maxNukeAmmo = 10
	public startNukeCount = 2
	public nukeLaunched = false
	public nukeLaunchSound as AudioClip
	public nukeExplSound as AudioClip
	
	def Start():
		missileAmmo = startMissileCount
		nukeAmmo = startNukeCount
		GetComponent[of AudioSource]().clip = laserSound
		GetComponent[of AudioSource]().rolloffMode = AudioRolloffMode.Linear
		GetComponent[of AudioSource]().volume = 0.25
		
	def Update():
		
		if Input.GetKeyDown("space"):
			FireLaser()
		if Input.GetKeyDown("m"):
			FireMissile()
		if Input.GetKeyDown("n"):
			FireNuke()

		// To keep track of live nukes, since the same key
		// is used to launch AND to detonate nukes.
		// On detonation, nukes are tagged as "Untagged".
		if len(GameObject.FindGameObjectsWithTag("nuke")) == 0: nukeLaunched = false
		else: nukeLaunched = true
		
	def FireLaser():
		if laserSoundEnabled == false:
			GetComponent[of AudioSource]().clip = laserSound
			laserSoundEnabled = true
			GetComponent[of AudioSource]().volume = 0.25
		i = 0
		while i < maxLaserFire:
			lShot = Instantiate(laser, transform.position + Vector3(2*i,0,0), Quaternion.identity) as GameObject
			lShot.transform.Rotate(0,0,90)
			lShot.GetComponent[of Rigidbody]().velocity = Vector3.right * laserSpeed
			i += 1
		GetComponent[of AudioSource]().Play()
			
	def FireMissile():
		if missileAmmo > 0:
			GetComponent[of AudioSource]().clip = missileLaunchSound
			laserSoundEnabled = false
			GetComponent[of AudioSource]().volume = 0.5
			
			mShot = Instantiate(missile, transform.position, Quaternion.identity) as GameObject
			mShot.transform.Rotate(0,0,90)
			mShot.GetComponent[of Rigidbody]().velocity = Vector3.right * missileSpeed
			missileAmmo -= 1
			
			GetComponent[of AudioSource]().Play()
		else:
			GetComponent[of AudioSource]().clip = emptyClipSound
			laserSoundEnabled = false
			GetComponent[of AudioSource]().volume = 0.1
			GetComponent[of AudioSource]().Play()
	
	def FireNuke():
		if nukeLaunched == false:
			if nukeAmmo > 0:
				nShot = Instantiate(nuke, transform.position, Quaternion.identity) as GameObject
				nShot.GetComponent[of Rigidbody]().velocity = Vector3.right * nukeSpeed
				nukeAmmo -= 1
				Ship.playerScore += 5
				laserSoundEnabled = false
				GetComponent[of AudioSource]().clip = nukeLaunchSound
				GetComponent[of AudioSource]().Play()
			else:
				laserSoundEnabled = false
				GetComponent[of AudioSource]().clip = emptyClipSound
				GetComponent[of AudioSource]().volume = 0.1
				GetComponent[of AudioSource]().Play()
		else:
			curNuke = GameObject.FindGameObjectWithTag("nuke")
			curNukeScript as NukeTrigger = curNuke.GetComponent[of NukeTrigger]()
			curNukeScript.detonate = true
			laserSoundEnabled = false
			GetComponent[of AudioSource]().clip = nukeExplSound
			GetComponent[of AudioSource]().volume = 1.0
			GetComponent[of AudioSource]().Play()
	
	def OnGUI():
		GUI.Label(Rect(10,35,60,20), "Missiles:")
		GUI.Label(Rect(75,35,20,20), missileAmmo.ToString())
		
		GUI.Label(Rect(10,60,60,20), "Nukes:")
		GUI.Label(Rect(75,60,20,20), nukeAmmo.ToString())