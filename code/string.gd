extends Line2D
class_name stringer
@onready var ray = $RayCast2D
signal enemies(Vector2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var lastIndex  = get_point_count()-1
	var mouse_pos = get_local_mouse_position()
	ray.target_position = to_local(get_global_mouse_position()) - get_point_position(lastIndex)
	ray.position = get_point_position(lastIndex)
	
	ray.force_raycast_update()
	set_point_position(lastIndex, mouse_pos)
	if ray.is_colliding():
		var target  = ray.get_collider()
		print(target)
		if target is test:
			var hit_global = ray.get_collision_point()
			var normal = ray.get_collision_normal() # The direction the wall is facing
	
			if !target.onHit():
				# Move the teleport target 10-20 pixels away from the surface
				var safe_teleport_spot = hit_global + (normal) 
		
				enemies.emit(safe_teleport_spot)
				add_point(to_local(hit_global))
				print("added")
	if Input.is_action_just_released("attack"):
		queue_free()
