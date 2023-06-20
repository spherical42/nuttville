extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var team = null
var pos = 0
var spd
signal gameover()


func _physics_process(delta: float) -> void:
	
	
	var players = get_parent().get_parent().get_node("Players").get_node("PlayersSpawnUnder").get_children()
	var dir = 0
	
	for p in players:
		var dist = global_position.distance_to(p.global_position)
		
		if dist > 1200:
			dist = 1200
		
		if p.dead == true:
			dist = 1200
		
		dist = 1200 - dist
		
		if p.team == "red":
			dist *= -1
			
		dir += dist/45
	
	pos += dir*delta
	
	if pos <= -1344:
		emit_signal("gameover", "red")
	if pos >= 1344:
		emit_signal("gameover", "blue")
	position.x = lerp(position.x - 3712, pos, 0.5) + 3712
	get_node("Label").text = str(position.x - 3712)

