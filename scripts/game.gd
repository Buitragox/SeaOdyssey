extends Node

#===== Constants =====

const MAX_LEVELS = 2

#===== Variables =====

var main_menu_scene = preload("res://nodes/MainMenu.tscn")
var level_scene = preload("res://nodes/Level.tscn")
var game_over_scene = preload("res://nodes/GameOver.tscn")
var level_complete_scene = preload("res://nodes/LevelComplete.tscn")
var win_scene = preload("res://nodes/Win.tscn")

var level
var level_complete
var game_over
var main_menu
var win

var level_count = 1
var cont = 0

var level_st = {"1" : load("res://sounds/kim-lightyear-legends-109307.mp3"),
				"2" : load("res://sounds/chiptune-grooving-142242.mp3"),
				"3" : load("res://sounds/gaming-8bit-music-hyperloop-by-infraction-amp-alexi-action-124334.mp3")}

var level_sfx = {"1" : load("res://sounds/win-sfx-38507.mp3"),
				 "2" : load("res://sounds/kl-peach-game-over-iii-142453.mp3"),
				 "3" : load("res://sounds/dark-evil-piano-32205.mp3")}

#==== Godot Funcs ====

func _ready():
	$MainMenuMusic.playing = true
	main_menu = main_menu_scene.instance()
	add_child(main_menu)
	
#===== in game signals =====
	
func _level_is_finished():
	$MusicLevels.stop()
	
	if level_count == MAX_LEVELS:
		$Win.play()
		
		win = win_scene.instance()
		add_child(win)
		cont += 1
		
	else:
		$LevelComplete.play()
		level_complete = level_complete_scene.instance()
		add_child(level_complete)
		cont += 1

func _is_player_dead():
	$MusicLevels.stop()
	$GameOver.play()
	game_over = game_over_scene.instance()
	add_child(game_over)
	
	
#===== Button signals =====

func _on_PlayButton_pressed():
	$MainMenuMusic.playing = false
	$StartEffect.stream = level_sfx[str(level_count)]
	$StartEffect.play()
	level = level_scene.instance()
	level.name = "Level"
	main_menu.queue_free()
	add_child(level, true)
	
func _on_PlayAgainButton_pressed():
	var nextPath = "res://levels/level%d.json" % level_count
	
	$StartEffect.stream = level_sfx[str(level_count)]
	$StartEffect.play()
	
	game_over.queue_free()
	level.free()
	
	level = level_scene.instance()
	level.level_path = nextPath
	level.name = "Level"
	add_child(level, true)
	
func _on_NextLevelButton_pressed():
	level_count +=1
	$LevelComplete.stop()
	
	print(level_count)
	var sfx = level_sfx[str(level_count)]
	sfx.set_loop(false)
	$StartEffect.stream = sfx
	$StartEffect.play()
	
	var nextPath = "res://levels/level%d.json" % level_count
	
	level_complete.queue_free()
	level.free()
	level = level_scene.instance()
	level.level_path = nextPath
	level.name = "Level"
	add_child(level, true)
	cont = 0
	
func _on_MainMenuButton_pressed():
	$MusicLevels.stop()
	$MainMenuMusic.playing = true
	main_menu = main_menu_scene.instance()
	game_over.free()
	level.queue_free()
	add_child(main_menu)
	
func _on_MainMenuButtonFromWin_pressed():
	$MusicLevels.stop()
	$MainMenuMusic.playing = true
	main_menu = main_menu_scene.instance()
	win.queue_free()
	level.queue_free()
	add_child(main_menu)
	
func _on_ExitButton_pressed():
	get_tree().quit()
	

#==== Music Signals ====

func _on_StartEffect_finished():
	$MusicLevels.stream = level_st[str(level_count)]
	$MusicLevels.play()
