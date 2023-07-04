extends Node2D



func _get_custom_rpc_methods():
	return [
		"createPlayer"
	]

func createPlayer(id,uname,charid):
	if id != str(OnlineMatch.get_network_unique_id()):
		var character
		
		match charid:
			1:
				character = get_parent().carlos.instance()
			2:
				character = get_parent().antonio.instance()
		
		character.name = str(id)
		character.goto = get_parent().get_node("PlayerSpawnPoints/Player" + str(id)).global_position
		add_child(character)
		character.set_network_master(int(id))
		character.global_position = get_parent().get_node("PlayerSpawnPoints/Player" + str(id)).global_position
		character.username = uname
		
	
	pass
