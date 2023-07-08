extends Area2D


var damage = 100
var knockback = 40
var playerWhoShot
var team
var issplit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("throw")
	pass # Replace with function body.


func _physics_process(delta):
	z_index = global_position.y
	


func split():
	damage = 50
	issplit = true
	pass


func _on_rmb_area_entered(area):
	if area.get_parent().team != team:
		print("hit player " + str(area.get_parent().name))
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [damage, playerWhoShot, $kb.global_position, knockback])
		if issplit == false:
				queue_free()
	if area.get_parent().team == team && area.get_parent().name != playerWhoShot:
		print("hit player " + str(area.get_parent().name))
		if OnlineMatch.is_network_master_for_node(self):
			OnlineMatch.custom_rpc_sync(area.get_parent(), "damage", [-damage, playerWhoShot])
		if issplit == false:
				queue_free()
	pass # Replace with function body.
