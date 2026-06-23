extends CharacterBody2D

const TILE_SIZE = 16
var is_moving = false
const SPEED = 0.1
const TEMPS_VOTE = 6

var time_left
var nb_round_left = round(8 * 1.75)
var timer

@onready var anim = $AnimatedSprite2D
@onready var canvas = $"../DarknessCanvasLayer"  
@onready var tilemap = get_parent().get_node("labyrinthe"+str(GameManager.get_level_number())+"/labyrinthe") 

signal time_changed(new_value)
signal round_changed(new_value)
signal gagner()
signal perdu()

const API_URL = "https://projets.iut-orsay.fr/prjs4-wmsaad/projetS4_api/api/api.php/"
const GET_DIRECTION = "direction"
const DELETE_VOTE = "vote" # Vérifie bien si c'est 'vote' ou 'vot' dans ton projet
const UP = "haut"
const DOWN = "bas"
const LEFT = "gauche"
const RIGHT = "droite"

func _ready():
	snap_to_grid()
	canvas.color = Color(1, 1, 1, 1)
	is_moving = true
	
	await get_tree().create_timer(1.0).timeout
	var tween = create_tween()
	tween.tween_property(canvas, "color", Color(0.1, 0.1, 0.1, 1), 2.0)
	await tween.finished
	
	is_moving = false
	_wipe_base() # Nettoyage forcé au départ
	
	timer = Timer.new()
	add_child(timer)
	time_left = TEMPS_VOTE
	timer.wait_time = 1.0
	timer.connect("timeout", _on_timeout)
	timer.start()
	
	time_changed.emit(TEMPS_VOTE)
	round_changed.emit(nb_round_left)

func snap_to_grid():
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))

func _on_timeout():
	if time_left == 0:
		time_changed.emit("Calcul...")
		time_left = TEMPS_VOTE
		_get_direction() 
		
		if nb_round_left <= 0:
			_stop_timer()
			perdu.emit()
		else:
			nb_round_left -= 1
			round_changed.emit(nb_round_left)
	else:
		time_left -= 1
		time_changed.emit(time_left)

func _stop_timer():
	timer.stop()

func _wipe_base():
	print("--- TENTATIVE DE WIPE ---")
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(func(result, response_code, headers, body):
		print("WIPE terminé. Code: ", response_code, " Réponse: ", body.get_string_from_utf8())
		http.queue_free()
	)
	# Tentative de DELETE sur /vote
	http.request(API_URL + DELETE_VOTE, [], HTTPClient.METHOD_DELETE)

func _get_direction():
	if is_moving: return
	
	print("--- FETCH DIRECTION ---")
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_response_direction.bind(http))
	http.request(API_URL + GET_DIRECTION)

func _on_response_direction(result, response_code, headers, body, http):
	http.queue_free()
	var txt = body.get_string_from_utf8()
	print("Réponse API reçue: ", txt)
	
	var json = JSON.parse_string(txt)
	var best_dir = ""
	
	if json is Dictionary:
		best_dir = json.get("direction", "")
	elif json is Array and json.size() > 0:
		best_dir = json[0].get("direction", "")

	if best_dir != "" and best_dir != null:
		print("Direction à traiter: ", best_dir)
		
		# On lance le mouvement
		var dir_vec = Vector2.ZERO
		if best_dir == RIGHT: dir_vec = Vector2.RIGHT
		elif best_dir == LEFT: dir_vec = Vector2.LEFT
		elif best_dir == UP: dir_vec = Vector2.UP
		elif best_dir == DOWN: dir_vec = Vector2.DOWN
		
		if dir_vec != Vector2.ZERO:
			await move_until_intersection(dir_vec)
		
		# QUOI QU'IL ARRIVE (mouvement réussi ou mur), ON VIDE LA BASE
		_wipe_base()
	else:
		print("Aucun vote trouvé.")

func move_until_intersection(direction):
	snap_to_grid()
	
	if check_collision(direction):
		print("Mur immédiat, mouvement annulé.")
		return

	is_moving = true
	play_walk_animation(direction)

	while true:
		if check_collision(direction): break

		var target = position + direction * TILE_SIZE
		var tween = create_tween()
		tween.tween_property(self, "position", target, SPEED)
		await tween.finished
		
		snap_to_grid()
		check_victory()
		
		if is_at_intersection(direction): break

	is_moving = false
	anim.play("idle")

func check_victory():
	if tilemap.is_player_on_exit(position):
		_stop_timer()
		gagner.emit()

func play_walk_animation(dir):
	if dir == Vector2.RIGHT: anim.play("right")
	elif dir == Vector2.LEFT: anim.play("left")
	elif dir == Vector2.UP: anim.play("up")
	elif dir == Vector2.DOWN: anim.play("idle")
	
func check_collision(dir):
	return test_move(transform, dir * TILE_SIZE)

func is_at_intersection(current_dir):
	var side_1 = Vector2(current_dir.y, -current_dir.x)
	var side_2 = Vector2(-current_dir.y, current_dir.x)
	return !check_collision(side_1) or !check_collision(side_2)
