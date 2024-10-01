extends Node3D

const CAMERA = preload("res://CameraEnum.gd")
var crab_scene = load("res://Crabball.tscn")
var score = 0
var crab_pot = []

var sens = 0.2
var current_cam = CAMERA.STATIC

@onready var cameras = [$STATIC, $Player/FIRST, $Player/ThirdPivot/SpringArm3D/THIRD, $Player/CROW, $CAMERA]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.position = $PlayerSpawn.position
	$STATIC.current = true
	
func _input(event: InputEvent) -> void:
	if current_cam == CAMERA.CAMERA:
		if event is InputEventMouseMotion:
			$CAMERA.rotate_y(deg_to_rad(-event.relative.x*sens))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("Change_Camera"):
		change_camera()

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
	$CanvasLayer/HUD.end_game()

func game_over():
	get_tree().quit()
	
func _on_player_damaged():
	$Player.take_damage()
	$CanvasLayer/HUD.update_health($Player.health)

func _on_score_timer_timeout() -> void:
	score += 1
	$CanvasLayer/HUD.update_score(score)


func _on_end_game_timer_timeout() -> void:
	game_over() 
	
func change_camera():
	if(current_cam == CAMERA.CAMERA):
		current_cam = CAMERA.STATIC
		$Player.current_cam = CAMERA.STATIC
	else:
		current_cam += 1
		$Player.current_cam += 1
	if current_cam == CAMERA.FIRST or current_cam == CAMERA.THIRD:
		$Player.cam_can_move = true
	else:
		$Player.cam_can_move = false
	cameras[current_cam].current = true
