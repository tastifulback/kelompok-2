extends Line2D
class_name stringer
@onready var ray = $RayCast2D
@onready var tileHit = false
@onready var tileIndex: int
signal enemies(Vector2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().musicEnd.connect(Music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var lastIndex  = get_point_count()-1
	var mouse_pos = get_local_mouse_position()
	if !tileHit:
		set_point_position(lastIndex, mouse_pos)
	ray.target_position = to_local(get_global_mouse_position()) - get_point_position(lastIndex-1)
	ray.position = get_point_position(lastIndex-1)
	
	ray.force_raycast_update()
	
	ray.force_raycast_update()
	if ray.is_colliding():
		var target  = ray.get_collider()
		
		if target is ranged or target is hook or target is heavyEnemy or target is mediumEnemy:
			 
			var hit_global = ray.get_collision_point()
			
	
			if !target.onHit():
				# Move the teleport target 10-20 pixels away from the surface
				
		
				enemies.emit(hit_global)
				add_point(to_local(hit_global),lastIndex)
				ray.add_exception(target)
				
		if target is tiles :
			if tileHit == false:
				var hit_global = ray.get_collision_point()
				var hit_normal = ray.get_collision_normal()
				tileIndex = lastIndex
				var nudged_hit = hit_global + (hit_normal * 2.0) 
				add_point(to_local(nudged_hit), lastIndex)
				tileHit = true
	else:
		if tileHit == true:
			remove_point(lastIndex)
			tileHit = false
	if Input.is_action_just_released("attack"):
		queue_free()
func  Music() -> void:
	queue_free()
