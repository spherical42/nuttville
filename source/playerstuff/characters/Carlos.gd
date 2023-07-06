extends Character



func _ready():
	selectid = 1
	maxhp = 800
	playerspeed = 300
	maxcds = [2,2,6] #[lclick, rclick, shift] seconds of cooldown
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
	
	if p[1] == 1 && c[1] == 0: # Left click
		print("lclick")
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
