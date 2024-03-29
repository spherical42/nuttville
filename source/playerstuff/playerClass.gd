extends KinematicBody2D

class_name Character

var dash = preload("res://source/playerstuff/attacks/dash.tscn")

var playerControlled = false
var username = ""
var selectid #defined by child class
var team
var dead = false
var inanim = false
var vector : Vector2
var arrowkeys : Vector2
var anim_dir : Vector2
var last_dir : Vector2
var knockdist = Vector2(0,0)
var zoom = 1
var playerspeed = 300
var pressed = [0,0,0,0,0] #[space, lclick, rclick, shift, ult] 1 for pressed 0 for not
var cooldowns = [0,0,0,0] #[space, lclick, rclick, shift] current seconds of cooldown left
var ammo = [1,1,1] #[lclick, rclick, shift] unused by non ammo based attacks
var maxcds = [10,10,10] #[lclick, rclick, shift] in seconds
var maxhp = 1000
var hp = 1000
var elapsed = 0.0
var oldpos
var goto # set in playersspawnunder
signal playerdied()

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	if get_parent().get_parent().blue.has(name):
		get_node("red").hide()
		team = "blue"
	if get_parent().get_parent().red.has(name):
		get_node("blue").hide()
		team = "red"
	
	if playerControlled == true:
		## something creating the character for everyone else
		OnlineMatch.custom_rpc_sync(get_parent(), "createPlayer", [name, username, selectid])
		goto = global_position
		playerControlled = false # gets set back to true in game manager script
	
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
		
		if !inanim:
			if Input.is_action_pressed("ui_down"):
				arrowkeys.y += 1
			if Input.is_action_pressed("ui_left"):
				arrowkeys.x -= 1
			if Input.is_action_pressed("ui_up"):
				arrowkeys.y -= 1
			if Input.is_action_pressed("ui_right"):
				arrowkeys.x += 1
			
			get_node("lookin parent").look_at(get_global_mouse_position())
		
		
		vector = arrowkeys*playerspeed*_delta
		
		
		
		
		if abs(vector.x) == abs(vector.y):
				vector *= (sqrt(2)/2)
		
		vector = move_and_slide(vector * 100)
		
		get_parent().get_parent().get_node("Camera2D").position = position
		
		for i in range(cooldowns.size()):
			cooldowns[i] -= _delta
			cooldowns[i] = clamp(cooldowns[i], 0, 10000)
		
		if !inanim:
			if Input.is_action_pressed("dash"):
				pressed[0] = 1
			if Input.is_action_pressed("lclick"):
				pressed[1] = 1
			if Input.is_action_pressed("rclick"):
				pressed[2] = 1
			if Input.is_action_pressed("shift"):
				pressed[3] = 1
			if Input.is_action_pressed("super"):
				pressed[4] = 1
		
		
		elapsed += _delta
		
		if inanim:
			if knockdist.length() >= 5:
				knockdist = lerp(Vector2(0,0),knockdist,0.9)
				move_and_slide(knockdist*(1/_delta))
			elif knockdist.length() < 5 && knockdist.length() > 1:
				inanim = false
				knockdist = Vector2(0,0)
			
			
			
			pass
		
		
		
		
		if get_node("lookin parent").global_transform != oldpos && elapsed >= 0.05:
			OnlineMatch.custom_rpc(self, "UpdatePos", [global_position, get_node("lookin parent").rotation, anim_dir])
			
		
		if pressed != [0,0,0,0,0] && elapsed >= 0.05:
			OnlineMatch.custom_rpc(self, "DoAttacks", [pressed, cooldowns, ammo]) ## make sure to have a DoAttacks function in all oc the character scripts
			DoAttacks(pressed,cooldowns,ammo)
			pressed = [0,0,0,0,0]
			elapsed = 0.0
		
		
		oldpos = get_node("lookin parent").global_transform
	elif playerControlled == false:
		global_position = lerp(global_position, goto, 0.35)
	
	
	pass



func UpdatePos(current, looking, animdir):
	#global_position = current
	goto = current
	get_node("lookin parent").rotation = looking
	anim_dir = animdir



func DoAttacks(p, c, a):
	#this is overwritten by the character's script
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
	


func damage(amount, whohit, knockorigin=null, knockintensity=null):
	
	
	hp -= amount
	if hp <= 0:
		Die()
		return
	hp = clamp(hp,0,maxhp)
	
	
	if knockintensity != null:
		#knockback
		print("doing knockback")
		knockorigin = get_node("lookin parent").global_position - knockorigin
		knockorigin = knockorigin.normalized()
		knockdist = knockorigin * knockintensity
		inanim = true
		pass
	pass

func dash():
	inanim = true
	damage(0, "0", get_node("lookin parent/lookin").global_position, -100)
	var dh = dash.instance()
	dh.playerWhoShot = name
	dh.team = team
	get_tree().get_nodes_in_group("GameWorld")[0].add_child(dh)
	dh.global_position = get_node("lookin parent").global_position
	
