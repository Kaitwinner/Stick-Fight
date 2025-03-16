extends Node

const PORT = 8910

var peer = ENetMultiplayerPeer.new()

var players = {}
var players_ready = 0

const PLAYERS_NEEDED = 2

func _ready() -> void:
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)

func create_game() -> Error:
	var error = peer.create_server(PORT)
	if error:
		return error
	
	multiplayer.multiplayer_peer = peer
	
	return OK

func join_game(address: String) -> Error:
	var error = peer.create_client(address, PORT)
	if error:
		return error
	
	multiplayer.multiplayer_peer = peer
	
	_register_player_local(multiplayer.get_unique_id())
	
	return OK

@rpc("authority", "call_local", "reliable")
func _start_game():
	get_tree().current_scene.start_game()

func _register_player_local(id: int) -> void:
	players[id] = { "id": id }

@rpc("any_peer", "reliable")
func _register_player(id: int):
	_register_player_local(id)

@rpc("any_peer", "reliable")
func _set_ready(_id: int):
	players_ready += 1
	
	if players_ready == PLAYERS_NEEDED:
		_start_game.rpc()

func _peer_connected(id: int) -> void:
	if id == 1:
		return

	_register_player_local(id)
	
	if multiplayer.is_server():
		return
	
	_register_player.rpc_id(id, multiplayer.get_unique_id())
	
	if len(players) == PLAYERS_NEEDED:
		_set_ready.rpc_id(1, multiplayer.get_unique_id())

func _peer_disconnected(id: int) -> void:
	players.erase(id)
