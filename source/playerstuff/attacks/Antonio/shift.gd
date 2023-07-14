extends Area2D


var damage = 50
var knockback = 50
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
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [damage, playerWhoShot])
		$AnimationPlayer.stop(false)
		removeCol()
		yield(get_tree().create_timer(0.3), "timeout")
		$AnimationPlayer.seek(0.13, true)
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [damage, playerWhoShot])
		yield(get_tree().create_timer(0.3), "timeout")
		$AnimationPlayer.seek(0.17, true)
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [damage, playerWhoShot, $CollisionShape2D.global_position, knockback])
		endAnim()
		queue_free()
	pass # Replace with function body.

func endAnim():
	get_parent().get_parent().inanim = false
	

func removeCol():
	$CollisionShape2D.disabled = true
