extends CharacterBody2D

class_name Player

@export var health: float = 100
@export var speed: float = 400
@export var jump_force: float = 800
@export var gravity: float = 1000
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 2000
@onready var animation =$AnimationPlayer

func _physics_process(delta):
	var angle = (get_global_mouse_position() - global_position).angle()
	
	$GunPos.position = Vector2(
		cos(angle),
		sin(angle)
	) * 80.0
		
	if ($GunPos.position.x < 0):
		$GunPos/Gun.scale = Vector2(1.0, -1.0)
	else:
		$GunPos/Gun.scale = Vector2(1.0, 1.0)
	
	apply_gravity(delta)
	move_player()
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta  # Apply gravity

func move_player():
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")  
	if left:
		$Sprite2D.flip_h = true
		animation.play("run")
		velocity.x = -speed
	elif right:
		$Sprite2D.flip_h = false
		animation.play("run")
		velocity.x = speed
	else:
		animation.play("idle")
		velocity.x = 0

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force  # Jumping

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot()

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.position = $GunPos/Gun/BulletExit.global_position
		var direction = (get_global_mouse_position() - global_position).normalized()
		bullet.velocity = direction * bullet_speed
		get_parent().add_child(bullet)
		
func apply_damage(damage: float) -> void:
	health -= damage
		
		
func death():
	if health == 0:
		get_tree().quit()
