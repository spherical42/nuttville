extends KinematicBody2D

class_name Player

var playerControlled = false
var username = ""
var team
var dead = false
var arrowkeys : Vector2
var anim_dir : Vector2
var last_dir : Vector2
var playerspeed
var Lclick = false
var Rclick = false
var shiftpress = false
var ultpress = false
var spacepress
var maxhp
var hp
var oldpos
signal playerdied()

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	match name:
		"1", "3":
			get_node("red").hide()
			team = "blue"
		"2", "4":
			get_node("blue").hide()
			team = "red"
	
	



