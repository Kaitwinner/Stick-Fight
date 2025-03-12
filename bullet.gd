extends Area2D

@export var velocity: Vector2

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(_body):
	queue_free()
	
