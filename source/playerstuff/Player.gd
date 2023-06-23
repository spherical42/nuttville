extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export (bool) var playerControlled = false
export (String) var username = ""
var team = "blue"
var dead = false
var vector := Vector2.ZERO
var arrowkeys : Vector2
var anim_dir : Vector2
var last_dir : Vector2
var camerapos : Vector2
var lookAtVector = 0
var playerspeed = 8
var press_i = false
var press_o = false
var press_p = false
var press_super = false
var charid #comes from selection id 
var maxhp = 1000 #maximum hp
var hp = 1000
var moveset #the id of the moveset
var oldpos
var i_cd = 0
var o_cd = 0
var p_cd = 0
var dynamic = 0
var ultcost
export var Bullet : PackedScene
export var Melee : PackedScene
signal playerdied()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	match name:
		"1":
			get_node("red").hide()
			team = "blue"
		"2":
			get_node("blue").hide()
			team = "red"
		"3":
			get_node("red").hide()
			team = "blue"
		"4":
			get_node("blue").hide()
			team = "red"
	
	
	if playerControlled:
		match charid: # apply selection to the player
			1: #carlos
				maxhp = 700
				hp = maxhp
				moveset = 1
				playerspeed = 10
				
			
			2: #abdul
				maxhp = 1100
				hp = maxhp
				moveset = 2
				playerspeed = 7
				
				
			
			3: #antonio
				maxhp = 800
				hp = maxhp
				moveset = 3
				playerspeed = 8
			
			
			_: 
				pass
		
		OnlineMatch.custom_rpc(self, "syncOthers", [username, charid, moveset, maxhp, playerspeed]) #UPDATE THIS WHENEVER YOU ADD A NEW PARAMETER
	
	slowrpc()
	
	pass # Replace with function body.

func _get_custom_rpc_methods():
	return [
		"UpdatePos",
		"UpdateNonPos",
		"syncOthers",
		"Die",
		"damage"
	]


func _physics_process(_delta: float) -> void:
	
	get_node("Nametag").text = username
	
	$hpbar/bar.rect_size = Vector2(64.0*(float(hp)/float(maxhp)), 8)
	
	$hpbar/Label.text = str(hp) + "/" + str(maxhp)
	
	if anim_dir != Vector2(0, 0):
			last_dir = anim_dir
		
	
	match anim_dir:
		Vector2(1, 0):
			get_node("sprite").frame = 2
		Vector2(1, -1):
			get_node("sprite").frame = 1
		Vector2(0, -1):
			get_node("sprite").frame = 0
		Vector2(-1, -1):
			get_node("sprite").frame = 7
		Vector2(-1, 0):
			get_node("sprite").frame = 6
		Vector2(-1, 1):
			get_node("sprite").frame = 5
		Vector2(0, 1):
			get_node("sprite").frame = 4
		Vector2(1, 1):
			get_node("sprite").frame = 3
		Vector2(0, 0):
			match last_dir:
				_:
					pass
		_:
			pass
	
	
	z_index = global_position.y
	
	if playerControlled && dead == false:
		if OnlineMatch.match_state == OnlineMatch.MatchState.READY or OnlineMatch.match_state == OnlineMatch.MatchState.PLAYING:
			pass
		else:
			return
		
		
		vector = Vector2()
		arrowkeys = Vector2()
		
		if Input.is_action_pressed("ui_down"):
			vector.y += playerspeed
		if Input.is_action_pressed("ui_left"):
			vector.x -= playerspeed
		if Input.is_action_pressed("ui_up"):
			vector.y -= playerspeed
		if Input.is_action_pressed("ui_right"):
			vector.x += playerspeed
		
		if Input.is_action_pressed("downarrow"):
			arrowkeys.y += 1
		if Input.is_action_pressed("leftarrow"):
			arrowkeys.x -= 1
		if Input.is_action_pressed("uparrow"):
			arrowkeys.y -= 1
		if Input.is_action_pressed("rightarrow"):
			arrowkeys.x += 1
		
		
		anim_dir = vector
		
		if anim_dir.x > 0:
			anim_dir.x = 1
		elif anim_dir.x < 0:
			anim_dir.x = -1
		if anim_dir.y > 0:
			anim_dir.y = 1
		elif anim_dir.y < 0:
			anim_dir.y = -1
		
		
		get_node("lookin parent").look_at(get_global_mouse_position())
		
		
		
		
		if abs(vector.x) == abs(vector.y):
			vector *= (sqrt(2)/2)
		
		
		
		vector = move_and_slide(vector * 100)
		
		
		
		
		camerapos.y = position.y + 32
		camerapos.x = position.x
		
		get_parent().get_parent().get_node("Camera2D").position = position
		
		i_cd -= 1
		o_cd -= 1
		p_cd -= 1
		
		i_cd = clamp(i_cd, 0, 10000)
		o_cd = clamp(o_cd, 0, 10000)
		p_cd = clamp(p_cd, 0, 10000)
		
		## remeber to update cooldowns
		
		if Input.is_action_pressed("i"):
			if i_cd == 0:
				press_i = true
				match moveset:
					1:
						i_cd = 240
					2:
						i_cd = 240
					3:
						i_cd = 240
					_:
						pass
		
		if Input.is_action_pressed("o"):
			if o_cd == 0:
				press_o = true
				match moveset:
					1:
						o_cd = 30
					2:
						o_cd = 30
					3:
						o_cd = 30
					_:
						pass
		
		if Input.is_action_pressed("p"):
			if p_cd == 0:
				press_p = true
				match moveset:
					1:
						p_cd = 720
					2:
						p_cd = 360
					3:
						p_cd = 360
					_:
						pass
		
		if Input.is_action_pressed("super"):
			pass
		
		if Input.is_action_just_pressed("dash"):
			pass
		
		if get_node("lookin parent").global_transform != oldpos:
			OnlineMatch.custom_rpc(self, "UpdatePos", [global_transform, get_node("lookin parent").rotation, anim_dir])
		
		oldpos = get_node("lookin parent").global_transform




func UpdatePos(current, looking, animdir):
	global_transform = current
	get_node("lookin parent").rotation = looking
	anim_dir = animdir
	



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
	

func shoot(shootpos, playerWhoShot, damage, _team):
	var bullet = Bullet.instance()
	get_tree().get_nodes_in_group("GameWorld")[0].add_child(bullet)
	bullet.playerWhoShot = playerWhoShot
	bullet.team = _team
	bullet.transform = shootpos
	bullet.damage = damage


func melee(shootpos, playerWhoShot, damage, _team):
	var melee = Melee.instance()
	get_node("lookin parent").add_child(melee)
	melee.playerWhoShot = playerWhoShot
	melee.team = _team
	melee.global_transform = shootpos
	melee.damage = damage


func damage(amount, whohit):
	hp -= amount
	if hp <= 0:
		Die()
	pass


func UpdateNonPos(ipress, opress, ppress, playerwhoshot):
	match moveset:
		1: #carlos
			if ipress:
				pass
			if opress:
				shoot($"lookin parent/lookin".global_transform, playerwhoshot, 75, team)
			if ppress:
				pass
			if press_super:
				pass
		2: #abdul
			if ipress:
				pass
			if opress:
				melee($"lookin parent/lookin".global_transform, playerwhoshot, 100, team)
			if ppress:
				pass
			if press_super:
				pass
		3: #antonio
			if ipress:
				pass
			if opress:
				shoot($"lookin parent/lookin".global_transform, playerwhoshot, 75, team)
			if ppress:
				pass
			if press_super:
				pass
		_: 
			pass


func slowrpc():
	if playerControlled:
		
		if OnlineMatch.match_state == OnlineMatch.MatchState.READY or OnlineMatch.match_state == OnlineMatch.MatchState.PLAYING:
			pass
		else:
			return
		
		
		OnlineMatch.custom_rpc(self, "UpdateNonPos", [press_i, press_o, press_p, name])
		
		## this part is so that the shooting is synced up
		UpdateNonPos(press_i, press_o, press_p, name)
		
		press_i = false
		press_o = false
		press_p = false
		##
		
		yield(get_tree().create_timer(0.05), "timeout")
		slowrpc()



func syncOthers(gamertag, ch, mvst, mhp, psp):
	#to run at the beginning of the game from everyone as their character
	#to tell everyone all of the data of their character
	username = gamertag
	charid = ch
	moveset = mvst
	maxhp = mhp
	hp = maxhp
	playerspeed = psp
	
	pass



