extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.show()
	if get_node("/root/Savelogin").savedlogin != "*":
		$EmailText.text = get_node("/root/Savelogin").savedlogin
		_on_Login_button_down()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Register_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	var username = $UsernameText.text.strip_edges()
	var password = "11111111"
	var email = $EmailText.text.strip_edges()
	
	var session = yield(Online.nakama_client.authenticate_email_async(email + "@gmail.com", password, username, true), "completed")
	if session.is_exception():
		print(session.get_exception().message)
		get_node("ErrorText").show()
		get_node("ErrorText").text = session.get_exception().message
		$UsernameText.text = ""
		$EmailText.text = ""
	if session.is_exception() == false:
		Online.nakama_session = session
		self.hide()


func _on_Login_button_down() -> void:
	get_parent().get_parent().get_node("sound/uisound/click").play()
	var username = $UsernameText.text.strip_edges()
	var password = "11111111"
	var email = $EmailText.text.strip_edges()
	
	var session = yield(Online.nakama_client.authenticate_email_async(email + "@gmail.com", password, null, false), "completed")
	if session.is_exception():
		print(session.get_exception().message)
		get_node("ErrorText").show()
		get_node("ErrorText").text = session.get_exception().message
		$UsernameText.text = ""
		$EmailText.text = ""
	if session.is_exception() == false:
		Online.nakama_session = session
		get_parent().get_parent().get_node("Players/Camera2D/ui/Username").text = Online.nakama_session.username 
		get_node("/root/Savelogin").savedlogin = email
		self.hide()
		get_parent().get_node("start").hide()

func _input(event):
	if event.is_action_released("ui_accept") and get_parent().get_node("start").visible == false:
		_on_Login_button_down()
		pass



func _on_Back_button_down() -> void:
	get_parent().get_node("start").show()
	get_parent().get_parent().get_node("sound/uisound/back").play()
