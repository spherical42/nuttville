extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var speed = 2000
var playerWhoShot 
var timeToLive = 0.5
var damage = 100
var nutt = "projectile"
var team
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 2000
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	
	timeToLive -= delta
	if timeToLive < 0:
		queue_free()
	position += transform.x * speed * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass



func _on_Bullet_area_entered(area: Area2D) -> void:
	print("hit player " + str(area.get_parent().name))
	if area.get_parent().name != playerWhoShot && area.get_parent().team != team:
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [damage, playerWhoShot])
		queue_free()
	pass # Replace with function body.
