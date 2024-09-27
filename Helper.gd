extends Node3D

signal dead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Idle")

func run():
	$AnimationPlayer.play("Running")
func idle():
	$AnimationPlayer.play("Idle")
func jump():
	$AnimationPlayer.play("Jump")
func death():
	$AnimationPlayer.pause()
	$AnimationPlayer.play("Death")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "Death"):
		emit_signal("dead")
