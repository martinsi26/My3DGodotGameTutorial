extends CharacterBody3D

class_name Player

const SPEED = 15
const JUMP_VELOCITY = 10

var health = 9
var iframes =  false

signal death

func _ready():
	pass
	
func _process(delta: float) -> void:
	if(velocity.x == 0 && velocity.z == 0 && is_on_floor()):
		$Helper.idle()
	elif(is_on_floor()):
		$Helper.run()

func default_movement(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$Helper.jump()
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("Rotate_Right"):
		rotate_y(-0.1)
	if Input.is_action_pressed("Rotate_Left"):
		rotate_y(0.1)
	
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Foward", "Move_Back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
		velocity.z = move_toward(velocity.z,0,SPEED)
	
	move_and_slide()
func _on_hitbox_body_entered(body: Node3D) -> void:
	take_damage()

func take_damage():
	if(!iframes):
		iframes = true
		health -= 3
		$IFrameTimer.start()
		if(health <= 0):
			died()

func died() -> void:
	set_physics_process(false)
	set_process(false)
	$CollisionShape3D.disabled = true
	$Helper/AnimationPlayer.stop()
	$CROW.current = true
	$Helper.death()

func _on_i_frame_timer_timeout() -> void:
	iframes = false

func _on_helper_dead() -> void:
	queue_free()
	emit_signal("death")
