extends Control

func _on_play_button_down() -> void:
	Lobby.join_game("127.0.0.1")
