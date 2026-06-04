extends Area2D
class_name Bullet
@export var dirr : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	position += transform.x * 1000 * delta


func _on_body_entered(body: Node2D) -> void:
	if  body is player: 
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is parry or area is deadzone:
		queue_free()
