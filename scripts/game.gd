extends Node

var main_menu_scene = preload("res://nodes/MainMenu.tscn")
var level_scene = preload("res://nodes/Level.tscn")
var game_over_scene = preload("res://nodes/GameOver.tscn")
var level
var game_over
var main_menu

func _ready():
	main_menu = main_menu_scene.instance()
	add_child(main_menu)

#func _process(delta):
#	var button = get_node_or_null('./MainMenu/Node2D2/PlayButton')
#	var level = level_scene.instance()
#	if button and button.pressed:
#		$MainMenu.queue_free()
#		add_child(level)

func _is_player_dead():
	game_over = game_over_scene.instance()
	add_child(game_over)

func _on_PlayButton_pressed():
	level = level_scene.instance()
	level.set_name("Level")
	main_menu.queue_free()
	add_child(level)
	
func _on_ExitButton_pressed():
	get_tree().quit()
	
func _on_PlayAgainButton_pressed():
	game_over.queue_free()
	level.queue_free()
	
	level = level_scene.instance()
	level.name = "Level"
	add_child(level)
	
func _on_MainMenuButton_pressed():
	main_menu = main_menu_scene.instance()
	game_over.queue_free()
	level.queue_free()
	add_child(main_menu)
