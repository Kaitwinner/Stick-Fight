extends Area2D

@onready var gamer = $"."
@onready var hitbox = $Area2D

func _ready() -> void:
	area_entered.connect(on_area_entered)



func on_area_entered(body: Node2D) -> void:
	body.apply_damage()
