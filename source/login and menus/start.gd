extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var bRegister
var bLogin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.show()
	bRegister = get_node("Register")
	bLogin = get_node("Login")
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func disableButtons():
	bRegister.disabled = true
	bLogin.disabled = true;
	pass

func enableButtons():
	bRegister.disabled = false
	bLogin.disabled = false
	pass

func _on_Register_button_down() -> void:
	get_parent().get_node("Login/Register").show()
	get_parent().get_node("Login/UsernameText").show()
	get_parent().get_node("Login/UsernameLabel").show()
	get_parent().get_node("Login/Login").hide()
	get_parent().get_node("Login/PasswordLabel").text = "Password: \n(Must be longer \nthan 8 characters)"
	get_parent().get_node("Login/ErrorText").hide()
	get_parent().get_node("Login/EmailText").text = ""
	get_parent().get_parent().get_node("sound/uisound/click").play()
	self.hide()
	pass # Replace with function body.


func _on_Login_button_down() -> void:
	get_parent().get_node("Login/Login").show()
	get_parent().get_node("Login/Register").hide()
	get_parent().get_node("Login/UsernameText").hide()
	get_parent().get_node("Login/UsernameLabel").hide()
	get_parent().get_node("Login/PasswordLabel").text = "Password: "
	get_parent().get_node("Login/ErrorText").hide()
	get_parent().get_node("Login/EmailText").text = ""
	get_parent().get_parent().get_node("sound/uisound/click").play()
	self.hide()
	pass # Replace with function body.
