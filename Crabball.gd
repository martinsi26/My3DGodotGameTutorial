extends CharacterBody3D

var speed = 40
signal damage

func _ready() -> void:
	velocity = Vector3(int(randf()*100),int(randf()*100),int(randf()*100)).normalized() * speed
	
	
func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(velocity * delta)
	
	if collision_info:
		if(collision_info.get_collider() is Player):
			emit_signal("damage")
		velocity = velocity.bounce(collision_info.get_normal())

	
