extends Control

var world = preload("res://World.tscn").instantiate()

func _on_button_button_down() -> void:
	get_tree().root.add_child(world)



func _on_button_2_button_down() -> void:
	get_tree().quit()
