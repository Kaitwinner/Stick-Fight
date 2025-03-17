extends Node2D

@onready var sync = $MultiplayerSynchronizer  # Reference to the MultiplayerSynchronizer

func set_authority(network_id: int) -> void:
	sync.set_multiplayer_authority(network_id)  # Assign authority

func _process(_delta: float) -> void:
	if sync.get_multiplayer_authority() != multiplayer.get_unique_id():
		return  # Only the authority should update the rotation

	var new_rotation = (get_global_mouse_position() - global_position).angle()
	
	if rotation != new_rotation:  # Only update if the rotation changed
		rotation = new_rotation  # Update rotation locally
