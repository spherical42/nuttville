extends Character



func _ready():
	selectid = 1
	maxhp = 800
	playerspeed = 5
	maxcds = [2,2,6,10] #[lclick, rclick, shift, space] seconds of cooldown
	._ready()

func _get_custom_rpc_methods():
	return [
		"UpdatePos",
		"DoAttacks",
		"Die",
		"damage"
	]


func DoAttacks(p, c):
	if p[0] == 1 && c[0] == 0: # Left click
		print("lclick")
		
		
		
		cooldowns[0] = maxcds[0]
		pass
	
	if p[1] == 1 && c[1] == 0: # Right click
		print("rclick")
		
		
		
		cooldowns[1] = maxcds[1]
		pass
	
	if p[2] == 1: # Shift
		pass
	if p[3] == 1: # Super
		pass
	if p[4] == 1: # Dash
		pass
	
	pass


func _physics_process(_delta: float) -> void:
	._physics_process(_delta)
	
	
	pass
