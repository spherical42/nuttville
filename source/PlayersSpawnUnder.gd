extends Node2D



func _get_custom_rpc_methods():
	return [
		"createPlayer"
	]

func createPlayer(id,usrname,charid):
	if id != str(OnlineMatch.get_network_unique_id()):
		var character
		
		match charid:
			1:
				character = get_parent().carlos.instance()
			2:
				character = get_parent().antonio.instance()
		
		character.name = str(id)
		add_child(character)
		character.set_network_master(int(id))
		character.position = get_parent().get_node("PlayerSpawnPoints/Player" + str(id)).position
		character.username = usrname
		
	
	pass
