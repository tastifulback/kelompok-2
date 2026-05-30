extends Area2D
class_name heavyAttack
@onready var time = $Timer
signal attackDone
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	emit_signal("attackDone")
	queue_free()
	


func _on_area_entered(area: Area2D) -> void:
	if area is parry:
		emit_signal("attackDone")
		queue_free()
