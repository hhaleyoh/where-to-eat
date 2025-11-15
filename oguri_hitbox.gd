extends Area2D

var mouse_on = false
@onready var sprite = $AnimatedSprite2D

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed and mouse_on:
		print("click")

func _mouse_enter():
	mouse_on = true
		
func _mouse_exit():
	mouse_on = false

func _ready() -> void:
	sprite.animation
