extends Area2D
class_name Bullet
@export var dirr : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween= create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", dirr,0.25 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if  !body is ranged: 
		queue_free()
