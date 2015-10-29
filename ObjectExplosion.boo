import UnityEngine

class ObjectExplosion (MonoBehaviour): 
	
	private explosionTimer = 2.0
	private explosionFade as double

	def Start ():
		explosionFade = explosionTimer
	
	def Update ():
		explosionFade -= Time.deltaTime
		if explosionFade <= 0: gameObject.GetComponent[of ParticleEmitter]().emit = false
		// Ceases particle emission once explosionFade counts down to zero.
		// This allows the "explosion" particle system to fade after
		// a given time set by "explosionTimer".