tool
extends Button

export (String,FILE) var scene = ''

func _on_Play_button_down():
	get_tree().change_scene(scene)

func _get_configuration_warning():
	return "Please Provide A Scene Path" if scene == '' else  ''
