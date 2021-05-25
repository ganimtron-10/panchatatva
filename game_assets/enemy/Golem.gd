extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 200
var pos
var dir = 1
var player
var playerdistance = 0
var playerIn = false
var attack1Player = false
var armshoot = false
var lasershoot = false
export var health = 100
var die
var GolemArm = preload("res://game_assets/enemy/GolemArm.tscn")
var GolemLaser = preload("res://game_assets/enemy/GolemLaser.tscn")

export var Meeledamage = 50

func _ready():
	pos = position
	GameManager.boss = self
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
	
	if $LaserAttack.is_colliding():
		if $LaserAttack.get_collider().is_in_group('Player'):
			lasershoot = true
			enemy_anim()
			yield($AnimatedSprite,"animation_finished")
			lasershoot = false
	elif $ArmAttack.is_colliding():
		if $ArmAttack.get_collider().is_in_group('Player'):
			armshoot = true
			enemy_anim()
			yield($AnimatedSprite,"animation_finished")
			armshoot = false
	
	
	flipper()
	enemy_anim()
	
	velocity = move_and_slide(velocity)

func enemy_anim():
	if die:
		$AnimatedSprite.animation = 'Dead'
	elif attack1Player:
		$AnimatedSprite.animation = 'Attack1'
	elif armshoot:
		$AnimatedSprite.animation = 'ArmShoot'
	elif lasershoot:
		$AnimatedSprite.animation = 'Laser'
	elif velocity.x != 0:
		$AnimatedSprite.animation = 'Glowing'
	else:
		$AnimatedSprite.animation = 'Idle'

func flipper():
	if dir == -1:
		$Areas.scale.x = -1
		$ArmAttack.cast_to.x = -500
		$LaserAttack.cast_to.x = -200
		$AnimatedSprite.flip_h = true
	else:
		$Areas.scale.x = 1
		$ArmAttack.cast_to.x = 500
		$LaserAttack.cast_to.x = 200
		$AnimatedSprite.flip_h = false

func hit_player():
	player.health -= Meeledamage

func enemy_died():
	die = true
	enemy_anim()
	yield($AnimatedSprite,"animation_finished")
	queue_free()

func shoot(spwan,part):
	var obj = part.instance()
	spwan.add_child(obj)
	obj.global_position = spwan.global_position
	obj.global_rotation = spwan.global_rotation


#Signals
func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == 'Attack1':
		if $AnimatedSprite.frame == 4:
			hit_player()
	if $AnimatedSprite.animation == 'ArmShoot':
		if $AnimatedSprite.frame == 7:
			shoot($Areas/ArmSpwanner,GolemArm)
	if $AnimatedSprite.animation == 'Laser':
		if $AnimatedSprite.frame == 5:
			shoot($Areas/ArmSpwanner,GolemLaser)


func _on_PlayerDetector_body_entered(body):
	if body.is_in_group('Player'):
		playerIn = true


func _on_PlayerDetector_body_exited(body):
	if body.is_in_group('Player'):
		playerIn = false


func _on_Attack1Area_body_entered(body):
	if body.is_in_group('Player'):
		attack1Player = true


func _on_Attack1Area_body_exited(body):
	if body.is_in_group('Player'):
		attack1Player = false

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)
