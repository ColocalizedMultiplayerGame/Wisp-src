extends Node2D

const ROWS = 16
const COLS = 28

var maze = []

@onready var tilemap_mur = $murs
@onready var tilemap_sol = $sol

func _ready():
	initialize_maze()
	generate_maze()
	draw_maze()

func initialize_maze():
	maze.clear()
	for r in range(ROWS):
		var row = []
		for c in range(COLS):
			row.append(1)
		maze.append(row)

func generate_maze():
	for r in range(ROWS):
		for c in range(COLS):
			maze[r][c] = 1

	carve_passages(ROWS-2, round(COLS/2)) #commencer l'algo à partir du milieu de la ligne du bas mais ça flop

func carve_passages(r, c):
	var directions = [
		Vector2(-2, 0),
		Vector2(0, 2),
		Vector2(2, 0),
		Vector2(0, -2)
	]

	directions.shuffle()

	for dir in directions:
		var new_r = r + int(dir.x)
		var new_c = c + int(dir.y)

		if new_r > 0 and new_r < ROWS - 1 and new_c > 0 and new_c < COLS - 1 and maze[new_r][new_c] == 1:
			maze[r + int(dir.x/2)][c + int(dir.y/2)] = 0
			maze[new_r][new_c] = 0
			carve_passages(new_r, new_c)

func draw_maze():
	for r in range(1,ROWS-1):
		for c in range(1,COLS-1):
			var pos = Vector2i(c, r)

			if maze[r][c] == 0:
				tilemap_mur.set_cell(pos, 1, Vector2i(2, 0)) 
			#else:
			#	tilemap_sol.set_cell(pos, 1, Vector2i(5, 6)) 
