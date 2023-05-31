extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_released("ui_cancel") and get_parent().get_node("start").visible == true:
		get_node("grey_out").visible = not get_node("grey_out").visible
		get_node("mExit").visible = not get_node("mExit").visible
		get_node("No").visible = not get_node("No").visible
		get_node("Yes").visible = not get_node("Yes").visible
		
		if get_node("grey_out").visible == true:
			get_parent().get_node("start").disableButtons()
			pass
		else:
			get_parent().get_node("start").enableButtons()
			pass
		pass
		
	pass

func _ready():
	self.visible = true
	get_node("Yes").hide()
	get_node("No").hide()
	get_node("grey_out").hide()
	get_node("mExit").hide()
	pass # Replace with function body.
	

func _on_Yes_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_No_button_up()->void:
	get_parent().get_node("start").enableButtons()
	get_node("grey_out").visible = false
	get_node("mExit").visible = false
	get_node("No").visible = false
	get_node("Yes").visible = false
	pass # Replace with function body.
