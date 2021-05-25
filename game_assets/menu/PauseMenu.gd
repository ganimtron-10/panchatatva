extends Control

onready var scene_tree = get_tree()
var paused = false setget set_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()

func set_paused(value):
	paused = value
	scene_tree.paused = value
	self.visible = value

func _on_Retry_button_down():
	get_tree().paused = false
	get_tree().reload_current_scene()
	

func _on_MainMenu_button_down():
	get_tree().paused = false
	get_tree().change_scene("res://game_assets/menu/StartScene.tscn")


func _on_Quit_button_up():
	get_tree().paused = false
	get_tree().quit()
