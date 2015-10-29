import UnityEngine

// This is an incomplete attempt at a physics-based navigation system for Player's ship using applied forces.
// Current default for ship navigation is kinematic and is included in the Ship class. Kinematic navigation,
// which is not as realistic in a space setting, is nevertheless much easier for a player to handle.
// Practicality trumps realism here.

class ShipNavPhysics (MonoBehaviour): 
    
    private shipThrust = 20.0f
    private maxSpeed = 160.0f
    private direc as single
    private shipDrag = 0.1f
    private stopMov = false
        
    def Start():
        pass
    
    def Update():
        stopMov = StayOnScreen()
        if Input.GetAxis("Vertical") > 0:
            direc = 1
        elif Input.GetAxis("Vertical") < 0:
            direc = 2
        elif Input.GetAxis("Horizontal") < 0:
            direc = 3
        elif Input.GetAxis("Horizontal") > 0:
            direc = 4
        else:
            direc = 0
    
    def FixedUpdate():
        if GetComponent[of Rigidbody]().velocity.magnitude < maxSpeed:
            if direc == 1: GetComponent[of Rigidbody]().AddForce(Vector3.forward * shipThrust)
            if direc == 2: GetComponent[of Rigidbody]().AddForce(Vector3.back * shipThrust)
            if direc == 3: GetComponent[of Rigidbody]().AddForce(Vector3.left * shipThrust)
            if direc == 4: GetComponent[of Rigidbody]().AddForce(Vector3.right * shipThrust)
        
        if direc == 0:
            GetComponent[of Rigidbody]().drag = GetComponent[of Rigidbody]().velocity.magnitude * shipDrag
    
    def StayOnScreen():
        ## minHorizScreen for ship as opposed to minHorizObj for asteroid
        ## asteroid must go slightly off screen but ship should not
        if transform.position.x < GameData.minHorizScreen: 
            transform.position.x = GameData.minHorizScreen
            return true
        if transform.position.x > GameData.maxHorizScreen: 
            transform.position.x = GameData.maxHorizScreen
            return true
        if transform.position.z < GameData.minVertScreen: 
            transform.position.z = GameData.minVertScreen
            return true
        if transform.position.z > GameData.maxVertScreen: 
            transform.position.z = GameData.maxVertScreen
            return true
        return false
    
    #alternate for staying on screen
    #if (StayOnScreen()):
    #    lockPos = true
    #   Rigidbody.velocity = Rigidbody.velocity.normalized * 0
    

			
