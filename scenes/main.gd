extends Node2D

var menu_scene = preload("res://scenes/UI/menu.tscn")
var world_scene = preload("res://scenes/world.tscn")

var menu: Node

func _ready():
	if "--server" in OS.get_cmdline_args():
		Lobby.create_game()
	else:
		menu = menu_scene.instantiate()
		add_child(menu)

func start_game() -> void:
	if menu:
		remove_child(menu)
	
	add_child(world_scene.instantiate())
