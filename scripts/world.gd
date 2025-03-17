extends Node2D

func _spawn_players():
	var player_scene = preload("res://scenes/player.tscn")
	
	var player_spawns = $Map1/PlayerSpawns.get_children()
	var spawn_counter = 0
	
	for player_info in Lobby.players.values():
		var player = player_scene.instantiate()
		
		player.network_id = player_info["id"]
		player.name = str(player_info["id"])
		player.global_position = player_spawns[spawn_counter].global_position
		
		spawn_counter += 1
		
		add_child(player)

func _ready() -> void:
	_spawn_players()
