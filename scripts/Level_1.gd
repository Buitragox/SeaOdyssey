extends Node2D
const CONF = preload("res://scripts/config.gd")

class_name Level_1

var level_path = "res://levels/level1.json"
var level_data
var enemy_scene = preload("res://nodes/Enemy.tscn")
var ship_scene = preload("res://nodes/Ship.tscn")
var count = 0
var wave_counter = 0


func get_position():
	var pos_aux = Vector2()
	
	if count % 3 == 0: 
		pos_aux = Vector2(rand_range(CONF.WIDTH/2, CONF.WIDTH + 20), rand_range(-20, 0))
		
	if count % 3 == 1:
		pos_aux = Vector2(rand_range(CONF.WIDTH, CONF.WIDTH + 20), rand_range(0, CONF.HEIGHT))
	
	if count % 3 == 2:
		pos_aux = Vector2(rand_range(CONF.WIDTH/2, CONF.WIDTH + 20), rand_range(CONF.HEIGHT, CONF.HEIGHT + 20))
	
	count += 1
	
	if count > 3:
		count = 0
	
	return pos_aux

	
func _ready():
	randomize()
	var ship = ship_scene.instance()
	ship.add_to_group("ship")
	ship.position = Vector2(CONF.WIDTH/4, CONF.HEIGHT/2)
	add_child(ship)
	
	load_level()
	$Timer.wait_time = level_data.waves[0].delay
	$Timer.start()
	

func _on_Timer_timeout():
	var amount_waves = level_data.waves[wave_counter].enemies.size()
	for i in range(amount_waves):
		var amount_enemy_types = level_data.waves[wave_counter].enemies[i].amount
		for j in range(amount_enemy_types):
			var enemy = enemy_scene.instance()
			enemy.add_to_group("enemies")
			enemy.position = get_position()
			add_child(enemy)
	
	wave_counter += 1
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
	print(level_data)
	
