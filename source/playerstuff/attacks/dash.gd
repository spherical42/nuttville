extends Area2D

var damage = 0
var knockback = 150
var playerWhoShot
var team


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("dash")
	pass # Replace with function body.



func _on_Area2D_area_entered(area):
	if area.get_parent().team != team:
		print("hit player " + str(area.get_parent().name))
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [damage, playerWhoShot, global_position, knockback])
	pass # Replace with function body.
