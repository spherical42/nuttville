extends Character



func _ready():
	selectid = 1
	maxhp = 800
	playerspeed = 9
	._ready()


func _physics_process(_delta: float) -> void:
	._physics_process(_delta)
	
	pass

func DoAttacks(p):
	if p[0] == 1: # Left click
		pass
	if p[1] == 1: # Right click
		pass
	if p[2] == 1: # Shift
		pass
	if p[3] == 1: # Super
		pass
	if p[4] == 1: # Dash
		pass
	
	pass
