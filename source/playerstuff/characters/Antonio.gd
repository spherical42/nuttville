extends Character



func _ready():
	selectid = 2
	maxhp = 1000
	playerspeed = 240
	maxcds = [3,4,3] #[lclick, rclick, shift] seconds of cooldown
	._ready()

func _get_custom_rpc_methods():
	return [
		"UpdatePos",
		"DoAttacks",
		"Die",
		"damage"
	]


func DoAttacks(p, c, a):
	if p[0] == 1 && c[0] == 0: # Space
		
		cooldowns[0] = 10
		pass
	
	if p[1] == 1 && c[1] <= 2.5: # Left click
		if a[0] >= 1 && c[1] != 0:
			#has a 0.5 attack they can use and has not waited 3 seconds
			
			#(attack code)
			
			pass
		elif c[1] == 0:
			#has waited at least 3 seconds since last using lclick
			
			#(attack code)
			
			ammo[0] = 2 #one less than the amount of attacks because attack was just used
			pass
		else: 
			return 
		
		 #will always set cd to 3 seconds unless they havent waited 3 seconds and have no ammo
		
		cooldowns[1] = maxcds[0]
		pass
	
	if p[2] == 1: # Right click
		pass
	if p[3] == 1: # Shift
		pass
	if p[4] == 1: # Super
		pass
	
	pass


func _physics_process(_delta: float) -> void:
	._physics_process(_delta)
	
	
	pass
