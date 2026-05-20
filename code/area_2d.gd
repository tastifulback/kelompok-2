extends CharacterBody2D
class_name test
@onready var area = $Area2D
@onready var hitmark = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	pass



func onHit() -> bool:
	if hitmark == false:
		hitmark = true
		return false
	else:
		return true
		
	




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player:
		queue_free()
