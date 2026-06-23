extends TileMapLayer

# coordonnée de la sortie (modifiable dans l'inspecteur)
@export var exit_cell: Vector2i = Vector2i(16, 8)

# Called when the node enters the scene tree
func _ready() -> void:
	pass

# fonction pour savoir si le joueur est sur la sortie
func is_player_on_exit(player_position: Vector2) -> bool:
	var player_cell = local_to_map(player_position)
	return player_cell == exit_cell
	
func check_win(player):
	if is_player_on_exit(player.position):
		print("Victoire")
