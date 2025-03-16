extends CharacterBody2D

class_name Player

var network_id: int
var input_state = Vector2()

var game_over = preload("res://scenes/UI/game_over.tscn").instantiate()
@export var health: float = 100
@export var speed: float = 400
@export var jump_force: float = 800
@export var gravity: float = 50.0
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 2000
@onready var animation = $AnimationPlayer
@onready var damage = 100

func _process(delta: float):
	if not multiplayer.is_server():
		_client_process(delta)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_server_physics_process()

@rpc("any_peer", "reliable")
func _update_client_input_state(new_state: Vector2):
	input_state = new_state

func _animate():
	if input_state.x != 0:
		$Sprite2D.flip_h = input_state.x < 0
		animation.play("run")
	else:
		animation.play("idle")

func _process_input():
	if network_id != multiplayer.get_unique_id():
		return
	
	var new_input = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		new_input.x += 1
	if Input.is_action_pressed("ui_left"):
		new_input.x -= 1
	if Input.is_action_pressed("ui_down"):
		new_input.y += 1
	if Input.is_action_pressed("ui_up"):
		new_input.y -= 1
	
	if new_input == input_state:
		return
	
	input_state = new_input
	_update_client_input_state.rpc(new_input)

func _client_process(_delta: float):
	_process_input()
	_animate()

func _server_physics_process():
	velocity.x = input_state.x * speed
	_apply_gravity()
	
	move_and_slide()

func _apply_gravity():
	if not is_on_floor():
		velocity.y += gravity
