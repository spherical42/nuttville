extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var timeToLive = 0.5
var damage = 100
var playerWhoShot
var team


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	z_index = global_position.y
	
	timeToLive -= delta
	if timeToLive < 0.0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_melee_area_entered(area: Area2D) -> void:
	print("hit player " + str(area.get_parent().name))
	if area.get_parent().name != playerWhoShot && area.get_parent().team != team:
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [damage, playerWhoShot])
		queue_free()
	pass # Replace with function body.
