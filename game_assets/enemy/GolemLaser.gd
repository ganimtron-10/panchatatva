extends Area2D

export var laserdamage = 15

func _on_AnimatedSprite_animation_finished():
	queue_free()
	

func _on_GolemLaser_body_entered(body):
	if body.is_in_group('Player'):
		body.health -= laserdamage
