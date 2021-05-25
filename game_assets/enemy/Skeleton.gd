extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 300
var pos
var dir = 1
var player
var playerdistance = 0
var playerIn = false
var attack1Player = false
var attack2Player = false
export var health = 60
var die = false
export var damage = 5



func _ready():
	pos = position
	GameManager.enemy = self
	player = GameManager.player
	set_physics_process(false)

func _physics_process(delta):
	if health<=0:
		enemy_died()
	else:
		movement()
	


#SelfDefinedFunctions
func movement():
	velocity.y += GameManager.gravity
	
	if playerIn:
		playerdistance = position.direction_to(player.position)
		if playerdistance.x>0:
			dir = 1
		else:
			dir = -1
		velocity.x = speed * dir
	else:
		velocity.x = 0
	
	flipper()
	enemy_anim()
	
	velocity = move_and_slide(velocity)

func enemy_anim():
	if die:
		$AnimatedSprite.animation = 'Dead'
	elif attack1Player:
		$AnimatedSprite.animation = 'Attack'
	elif velocity.x != 0:
		$AnimatedSprite.animation = 'Walk'
	else:
		$AnimatedSprite.animation = 'Idle'

func flipper():
	if dir == -1:
		$Areas.position.x = -32
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.offset.x = 15
	else:
		$Areas.position.x = 44
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.offset.x = 0

func hit_player():
	player.health -= damage

func enemy_died():
	die = true
	enemy_anim()
	yield($AnimatedSprite,"animation_finished")
	queue_free()

#Signals
func _on_PlayerDectector_body_entered(body):
	if body.is_in_group('Player'):
		playerIn = true

func _on_PlayerDectector_body_exited(body):
	if body.is_in_group('Player'):
		playerIn = false

func _on_AttackArea_body_entered(body):
	if body.is_in_group('Player'):
		attack1Player = true

func _on_AttackArea_body_exited(body):
	if body.is_in_group('Player'):
		attack1Player = false

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == 'Attack':
		if $AnimatedSprite.frame == 4:
			hit_player()

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)
