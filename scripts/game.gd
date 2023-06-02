extends Node

var main_menu_scene = preload("res://nodes/MainMenu.tscn")
var level_scene = preload("res://nodes/Level.tscn")
var game_over_scene = preload("res://nodes/GameOver.tscn")
var level_complete_scene = preload("res://nodes/LevelComplete.tscn")

var level
var level_complete
var game_over
var main_menu

func _ready():
	main_menu = main_menu_scene.instance()
	add_child(main_menu)
	
func _level_is_finished():
	level_complete = level_complete_scene.instance()
	add_child(level_complete)

func _is_player_dead():
	game_over = game_over_scene.instance()
	add_child(game_over)

func _on_PlayButton_pressed():
	level = level_scene.instance()
	level.name = "Level"
	main_menu.queue_free()
	add_child(level, true)
	
func _on_ExitButton_pressed():
	get_tree().quit()
	
func _on_PlayAgainButton_pressed():
	game_over.queue_free()
	level.free()
	
	level = level_scene.instance()
	level.name = "Level"
	add_child(level, true)
	
func _on_NextLevelButton_pressed():
	pass
	
func _on_MainMenuButton_pressed():
	main_menu = main_menu_scene.instance()
	game_over.queue_free()
	level.queue_free()
	add_child(main_menu)
