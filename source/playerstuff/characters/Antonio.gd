extends Character


var lmb = preload("res://source/playerstuff/attacks/Antonio/lmb.tscn")
var rmb = preload("res://source/playerstuff/attacks/Antonio/rmb.tscn")

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
		dash()
		
		cooldowns[0] = 10
		pass
	
	if p[1] == 1 && c[1] <= 2.5: # Left click
		if a[0] >= 1 && c[1] != 0:
			#has a 0.5 attack they can use and has not waited 3 seconds
			
			Swing()
			ammo[0] -= 1
			
			pass
		elif c[1] == 0:
			#has waited at least 3 seconds since last using lclick
			
			Swing()
			
			ammo[0] = 2 #one less than the amount of attacks because attack was just used
			pass
		else: 
			return 
		
		 #will always set cd to 3 seconds unless they havent waited 3 seconds and have no ammo
		
		cooldowns[1] = maxcds[0]
		pass
	
	if p[2] == 1 && c[2] == 0: # Right click
		
		Throw()
		
		cooldowns[2] = maxcds[1]
		pass
	if p[3] == 1: # Shift
		pass
	if p[4] == 1: # Super
		pass
	
	pass


func _physics_process(_delta: float) -> void:
	._physics_process(_delta)
	
	
	pass

func Swing():
	inanim = true
	damage(0, "0", get_node("lookin parent/lookin").global_position, -20)
	var attack = lmb.instance()
	attack.playerWhoShot = name
	attack.team = team
	get_node("lookin parent").add_child(attack)
	attack.global_position = get_node("lookin parent/lookin").global_position
	pass

func Throw():
	var attack = rmb.instance()
	attack.playerWhoShot = name
	attack.team = team
	get_tree().get_nodes_in_group("GameWorld")[0].add_child(attack)
	attack.global_transform = get_node("lookin parent/lookin").global_transform
	pass
