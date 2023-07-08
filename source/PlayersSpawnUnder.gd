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
		
		
		character.set_network_master(int(id))
		var teamid # alright this part is confusing but it makes it go to the correct spot
		match get_parent().blue.find(str(id)):
			0:
				teamid = 1
			1:
				teamid = 3
			_:
				match get_parent().red.find(str(id)):
					0:
						teamid = 2
					1:
						teamid = 4
		
		
		character.goto = get_parent().get_node("PlayerSpawnPoints/Player" + str(teamid)).global_position
		add_child(character)
		character.global_position = get_parent().get_node("PlayerSpawnPoints/Player" + str(teamid)).global_position
		character.username = uname
	
	
	pass
