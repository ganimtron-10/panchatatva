extends KinematicBody2D

export var speed = 500
export var jumph = -1300
export var damage = 34
export var health = 100
export var animArray = ['Idle','Run','Jump','Fall','Attack1','Hurt','Die']
onready var aSprite = $AnimatedSprite
var velocity = Vector2.ZERO
var isAttacking = false
var isAttacking2 = false
var isAttacking3 = false
var enemyIn = false
var enemy


func _ready():
	GameManager.player = self

func _physics_process(delta):
	if health<=0:
		player_died()
	else:
		$Label.text = str(health)
		get_input()
		

#SelfDefinedFunctions
func get_input():
		velocity.y += GameManager.gravity
		
		if isAttacking2 and Input.is_action_just_pressed("attack1"):
			isAttacking3 = true
			player_anim(8)
		elif isAttacking and Input.is_action_just_pressed("attack1") and !isAttacking3:
			isAttacking2 = true
			player_anim(7)
		elif Input.is_action_just_pressed("attack1") and !isAttacking2:
			isAttacking = true
			player_anim(4)
		elif Input.is_action_pressed("right"):
			velocity.x = speed
			aSprite.flip_h = false
			$AttackArea.scale.x = 1
			if is_on_floor() and !isAttacking:
				player_anim(1)
		elif Input.is_action_pressed("left"):
			velocity.x = -speed
			aSprite.flip_h = true
			$AttackArea.scale.x = -1
			if is_on_floor() and !isAttacking:
				player_anim(1)
		elif !is_on_floor() and !isAttacking:
			player_anim(2)
		else:
			velocity.x = 0
			if !isAttacking:
				player_anim(0)
			
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = jumph
		
		velocity = move_and_slide(velocity,Vector2.UP)

func player_died():
	player_anim(6)
	yield($AnimatedSprite,"animation_finished")
	$Timer.start()
	yield($Timer,"timeout")
	$CollisionShape2D.disabled = true
	visible = false
	queue_free()
	get_tree().change_scene("res://game_assets/menu/GameOverScene.tscn")

func player_anim(animIndex):
	aSprite.animation = animArray[animIndex]

func hit_enemy():
	if enemyIn:
		enemy.health -= damage


#Signals
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == 'Attack1' or $AnimatedSprite.animation == 'Attack2' or $AnimatedSprite.animation == 'Attack3':
		isAttacking = false
		isAttacking2 = false
		isAttacking3 = false

func _on_AttackArea_body_entered(body):
	if body.is_in_group('Enemy'):
		enemy = body
		enemyIn = true

func _on_AttackArea_body_exited(body):
	if body.is_in_group('Enemy'):
		enemyIn = false


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == 'Attack1' or $AnimatedSprite.animation == 'Attack2' or $AnimatedSprite.animation == 'Attack3':
		if $AnimatedSprite.frame == 3:
			hit_enemy()
