extends KinematicBody2D

class_name Character

var playerControlled = false
var username = ""
var selectid #defined by child class
var team
var dead = false
var vector : Vector2
var arrowkeys : Vector2
var anim_dir : Vector2
var last_dir : Vector2
var zoom = 1
var playerspeed = 7
var pressed = [0,0,0,0,0] #[lclick, rclick, shift, ult, space] 1 for pressed 0 for not
var cooldowns = [0,0,0,0,0] #[lclick, rclick, shift, ult, space] seconds of cooldown left
var maxcds = [10,10,10,10] #in seconds
var maxhp = 1000
var hp = 1000
var oldpos
signal playerdied()

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	match name:
		"1", "3":
			get_node("red").hide()
			team = "blue"
		"2", "4":
			get_node("blue").hide()
			team = "red"
	
	if playerControlled == true:
		## something creating the character for everyone else
		OnlineMatch.custom_rpc_sync(get_parent(), "createPlayer", [name, username, selectid])
		playerControlled = false
	
	hp = maxhp
	
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Nametag").text = username


func _get_custom_rpc_methods():
	return [
		"UpdatePos",
		"DoAttacks",
		"Die",
		"damage"
	]


func _physics_process(_delta: float) -> void:
	$hpbar/bar.rect_size = Vector2(64.0*(float(hp)/float(maxhp)), 8)
	
	$hpbar/Label.text = str(hp) + "/" + str(maxhp)
	
	z_index = global_position.y
	
	
	if playerControlled && dead == false:
		if OnlineMatch.match_state == OnlineMatch.MatchState.READY or OnlineMatch.match_state == OnlineMatch.MatchState.PLAYING:
			pass
		else:
			return
		
		
		vector = Vector2()
		arrowkeys = Vector2()
		
		if Input.is_action_pressed("ui_down"):
			arrowkeys.y += 1
		if Input.is_action_pressed("ui_left"):
			arrowkeys.x -= 1
		if Input.is_action_pressed("ui_up"):
			arrowkeys.y -= 1
		if Input.is_action_pressed("ui_right"):
			arrowkeys.x += 1
		
		
		#if Input.is_action_pressed("scrldwn"):
		#	print("out")
		#	zoom += 0.02
		#if Input.is_action_pressed("scrlup"):
		#	print("in")
		#	zoom -= 0.02
		
		#zoom = clamp(zoom,0.5, 2)
		
		#get_parent().get_parent().get_node("Camera2D").zoom = Vector2(zoom, zoom)
		#get_parent().get_parent().get_node("Camera2D").scale = Vector2(zoom, zoom)
		
		vector = arrowkeys*playerspeed
		
		get_node("lookin parent").look_at(get_global_mouse_position())
		
		
		if abs(vector.x) == abs(vector.y):
				vector *= (sqrt(2)/2)
		
		vector = move_and_slide(vector * 100)
		
		get_parent().get_parent().get_node("Camera2D").position = position
		
		for i in range(cooldowns.size()):
			cooldowns[i] -= _delta
			cooldowns[i] = clamp(cooldowns[i], 0, 10000)
		
		if Input.is_action_pressed("lclick"):
			pressed[0] = 1
		if Input.is_action_pressed("rclick"):
			pressed[1] = 1
		if Input.is_action_pressed("shift"):
			pressed[2] = 1
		if Input.is_action_pressed("super"):
			pressed[3] = 1
		if Input.is_action_pressed("dash"):
			pressed[4] = 1
		
		
		if pressed != [0,0,0,0,0]:
			OnlineMatch.custom_rpc(self, "DoAttacks", [pressed, cooldowns]) ## make sure to have a DoAttacks function in all oc the character scripts
			DoAttacks(pressed,cooldowns)
			pressed = [0,0,0,0,0]
		
		
		
		
		if get_node("lookin parent").global_transform != oldpos:
			OnlineMatch.custom_rpc(self, "UpdatePos", [global_transform, get_node("lookin parent").rotation, anim_dir])
		
		oldpos = get_node("lookin parent").global_transform
	
	pass



func UpdatePos(current, looking, animdir):
	global_transform = current
	get_node("lookin parent").rotation = looking
	anim_dir = animdir
	

func DoAttacks(p, c):
	print("this should not be printed")
	pass

func Die():
	emit_signal("playerdied")
	var respawntime = 10
	
	self.hide()
	dead = true
	
	global_position = Vector2(-500, -500)
	
	if playerControlled:
		deathtimer(respawntime)
	
	yield(get_tree().create_timer(float(respawntime)), "timeout")
	
	#respawn
	self.show()
	hp = maxhp
	global_position = get_parent().get_parent().get_node("PlayerSpawnPoints/Player" + name).global_position
	dead = false


func deathtimer(time):
	var cd = get_parent().get_parent().get_node("Camera2D/ui/respawncd")
	cd.show()
	cd.text = "Respawn in: " + str(time)
	yield(get_tree().create_timer(1.0), "timeout")
	if time > 0:
		time -= 1
		deathtimer(time)
	else:
		cd.hide()
	


func damage(amount, whohit):
	hp -= amount
	if hp <= 0:
		Die()
	pass
