extends Area2D

@export var damage = 100


#func _ready() -> void:
	#body_entered.connect(on_body_entered)
	
	


#func on_body_entered(body: Node2D) -> void:
	#body.apply_damage()
