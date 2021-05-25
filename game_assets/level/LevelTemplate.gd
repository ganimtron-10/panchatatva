tool
extends Node2D

export (String,FILE) var next_level = ''

func _get_configuration_warning():
	return "Please Provide A Scene Path" if next_level == '' else  ''


func _on_LevelComplete_body_entered(body):
	if body.is_in_group('Player'):
		get_tree().change_scene(next_level)
