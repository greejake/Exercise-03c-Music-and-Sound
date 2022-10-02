extends Node

var VP = Vector2.ZERO
var level = 0
var score = 0
var lives = 0
var time = 0
var starting_in = 0

var color_rotate = 0
var color_rotate_amount = 10
var color_rotate_index = 0.01



var sway_index = 0
var sway_period = 0.1


export var default_starting_in = 4
export var default_lives = 5
var colors = [
	Color8(224,49,49)
	,Color8(255,146,43)
	,Color8(255,212,59)
	,Color8(148,216,45)
	,Color8(34,139,230)
	,Color8(132,94,247)
	,Color8(190,75,219)
	,Color8(134,142,150)
]

func _ready():
	randomize()
	position.x = new_position.x
	position.y = -100
	$Tween.interpolate_property(self, "position", position, new_position, time_appear + randf()*2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	if score >= 100: color_index = 0
	elif score >= 90: color_index = 1
	elif score >= 80: color_index = 2
	elif score >= 70: color_index = 3 
	elif score >= 60: color_index=  4
	elif score >= 50: color_index = 5
	elif score >= 40: color_index = 6
	else: color_index = 7
	$ColorRect.color = colors[color_index]
	sway_initial_position = $ColorRect.rect_position
	sway_randomizer = Vector2(randf()*6-3.0, randf()*6-3.0)
	color_distance = Global.color_position.distance_to(global_position)  / 100
	if Global.color_rotate >= 0:
		$ColorRect.color = colors[(int(floor(color_distance + Global.color_rotate))) % len(colors)]
		color_completed = false
	elif not color_completed:
		$ColorRect.color = colors[color_index]
		color_completed = true
	var pos_x = (sin(Global.sway_index)*(sway_amplitude + sway_randomizer.x))
	var pos_y = (cos(Global.sway_index)*(sway_amplitude + sway_randomizer.y))
	$ColorRect.rect_position = Vector2(sway_initial_position.x + pos_x, sway_initial_position.y + pos_y)

func _physics_process(_delta):
	if color_rotate >= 0:
		color_rotate -= color_rotate_index
		color_rotate_index *= 1.05
	else:
		color_rotate_index = 0.1
	sway_index += sway_period

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		var Pause_Menu = get_node_or_null("/root/Game/UI/Pause_Menu")
		if Pause_Menu == null or starting_in > 0:
			get_tree().quit()
		else:
			if Pause_Menu.visible:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_tree().paused = false
				Pause_Menu.hide()
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true
				Pause_Menu.show()

func _resize():
	VP = get_viewport().size

func reset():
	level = 0
	score = 0
	lives = default_lives
	starting_in = default_starting_in

func update_score(s):
	score += s
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_score()

func update_lives(l):
	lives += l
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_lives()
	if lives <= 0:
		end_game(false)

func update_time(t):
	time += t
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_time()
	if time <= 0:
		end_game(false)

func next_level():
	level += 1
	var _scene = get_tree().change_scene("res://Game.tscn")

func end_game(success):
	if success:
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
	else:
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
