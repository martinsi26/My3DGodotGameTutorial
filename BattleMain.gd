extends Node3D

var crab_scene = load("res://Crabball.tscn")
var score = 0
var crab_pot = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.position = $PlayerSpawn.position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()


func spawn_enemy() -> void:
	var crabball = crab_scene.instantiate()
	crab_pot.append(crabball)
	add_child(crabball)
	crabball.position = $EnemySpawns.get_children()[randi_range(0,3)].position
	crabball.damage.connect(_on_player_damaged)


func _on_player_death() -> void:
	$SpawnTimer.paused = true
	$ScoreTimer.paused = true
	for crabball in crab_pot:
		crabball.queue_free()
	$EndGameTimer.start()

func game_over():
	get_tree().quit()


func _on_player_damaged():
	$Player.take_damage()


func _on_score_timer_timeout() -> void:
	score += 1


func _on_end_game_timer_timeout() -> void:
	game_over() 
	
