extends Line2D
class_name string
@onready var ray = $RayCast2D
@onready var hitmark = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var lastIndex  = get_point_count()-1
	var mouse_pos = get_global_mouse_position()
	set_point_position(lastIndex, mouse_pos)
	ray.position = get_point_position(lastIndex)
	ray.target_position = to_local(get_global_mouse_position()) - ray.position
	if ray.is_colliding():
		var target  = ray.get_collider()
		
		if target is test:
			var hit = to_local(ray.get_collision_point())
			if !target.onHit():
				
				add_point(hit)
				print("added")
