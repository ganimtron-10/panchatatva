extends Area2D

export var armspeed = 200
export var armdamage = 10

func _ready():
	set_as_toplevel(true)

func _process(delta):
	move_local_x(delta*armspeed)


func _on_GolemArm_body_entered(body):
	queue_free()
	if body.is_in_group('Player'):
		body.health -= armdamage
