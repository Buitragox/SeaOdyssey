extends Node2D
const CONF = preload("res://scripts/config.gd")

signal level_complete

class_name Level


var level_path = "res://levels/level1.json"
var level_data

var enemy_scenes = {"normal": preload("res://nodes/Enemy.tscn"),
					"shotgun": preload("res://nodes/EnemyShotgun.tscn"),
					"chaser": preload("res://nodes/EnemyChaser.tscn")}

var ship_scene = preload("res://nodes/Ship.tscn")
var count = 0
var wave_counter = 0
var score = 0
var text
var bg_modulate = Color("#268fbe")


func get_position():
	var pos_aux = Vector2()
	
	if count % 4 == 0: 
		pos_aux = Vector2(rand_range(CONF.WIDTH/2.0, CONF.WIDTH + 20), rand_range(-20, 0))
		
	if count % 4 == 1:
		pos_aux = Vector2(rand_range(CONF.WIDTH, CONF.WIDTH + 20), rand_range(0, CONF.HEIGHT))
		
	if count % 4 == 2:
		pos_aux = Vector2(rand_range(CONF.WIDTH, CONF.WIDTH + 20), rand_range(0, CONF.HEIGHT))
	
	if count % 4 == 3:
		pos_aux = Vector2(rand_range(CONF.WIDTH/2.0, CONF.WIDTH + 20), rand_range(CONF.HEIGHT, CONF.HEIGHT + 20))
	
	count += 1
	
	if count > 3:
		count = 0
	
	return pos_aux

	
func _ready():
	connect("level_complete", get_node("/root/Game"), "_level_is_finished")
	
	randomize()
	var ship = ship_scene.instance()
	ship.add_to_group("ship")
	ship.position = Vector2(CONF.WIDTH/4.0, CONF.HEIGHT/2.0)
	add_child(ship)
	
	var bg_sprites = get_tree().get_nodes_in_group("background")
	for i in range(bg_sprites.size()):
		bg_sprites[i].modulate = bg_modulate
	
	load_level()
	$Timer.wait_time = level_data.waves[0].delay
	$Timer.start()
	
func _process(_delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	var total_waves = level_data.waves.size()
	
	if enemies.size() == 0 and wave_counter >= total_waves:
		emit_signal("level_complete")
	

func _on_Timer_timeout():
	var amount_waves = level_data.waves[wave_counter].enemies.size()
	for i in range(amount_waves):
		var amount_enemy_types = level_data.waves[wave_counter].enemies[i].amount
		var type = level_data.waves[wave_counter].enemies[i].type
		var enemy_scene = enemy_scenes[type]
		for _j in range(amount_enemy_types):
			var enemy = enemy_scene.instance()
			enemy.add_to_group("enemies")
			enemy.position = get_position()
			add_child(enemy)
	
	wave_counter += 1
	$Interface/WaveLabel.text = "Wave: %d / %d" % [wave_counter, level_data.waves.size()]
	if wave_counter < level_data.waves.size():
		
		$Timer.wait_time = level_data.waves[wave_counter].delay
		$Timer.start()
	else:
		$Timer.paused = true


func load_level():
	var file = File.new()
	if not file.file_exists(level_path):
		return
	file.open(level_path, File.READ)
	level_data = parse_json(file.get_as_text())
	file.close()
	

func _on_enemy_dead():
	score += 50
	text = "Score: %s" % score
	$Interface/ScoreLabel.text = text
