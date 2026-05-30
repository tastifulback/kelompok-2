extends Area2D
class_name parry
@onready var parryTime = $Timer
signal parryDone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parryTime.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	emit_signal("parryDone")
	queue_free()
