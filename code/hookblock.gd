extends StaticBody2D
class_name hook


@onready var hitmark = false
func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("attack"):
		hitmark = false



func onHit() -> bool:
	if hitmark == false:
		hitmark = true
		return false
	else:
		return true
		
	
