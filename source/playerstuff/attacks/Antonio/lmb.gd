extends Area2D


var damage = 75
var knockback = 150
var playerWhoShot
var team

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("SwingLeft")
	pass # Replace with function body.

func _physics_process(delta):
	z_index = global_position.y
	



func _on_AntonioLmb_area_entered(area: Area2D):
	if area.get_parent().team != team:
		print("hit player " + str(area.get_parent().name))
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [damage, playerWhoShot, get_parent().global_position, knockback])
	pass # Replace with function body.

func endAnim():
	get_parent().get_parent().inanim = false
