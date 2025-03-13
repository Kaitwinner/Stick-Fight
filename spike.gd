extends StaticBody2D

@onready var player = $"."
@onready var hitbox = $Area2D
func damage(damage: float) -> void:
	
