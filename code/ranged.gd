extends CharacterBody2D
class_name ranged
@export var speed := 50.0
@export var CHASE_SPEED := 300
@export var ACCELERATION := 300

var GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction : Vector2
var right_bounds : Vector2
var left_bounds : Vector2
@onready var hitmark : bool = false
@onready var BULLET = preload("uid://ds8gin3qog4x5")
@onready var collider

@onready var detect : Area2D = $detection
@onready var ray_cast_down: RayCast2D = $Sprite2D/RayCastDown
@onready var ray_cast_wall: RayCast2D = $Sprite2D/RayCastWall
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var reload: Timer = $reload
@onready var chase: Timer = $chase
signal dead

enum states {
	WANDER,
	CHASE
}

var current_state = states.WANDER

func _ready():
	
	left_bounds = position + Vector2(-125, 0)
	right_bounds = position + Vector2(125, 0)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)

	change_direction()
	handle_movement(delta)

	
func chase_player() -> void:
	chase.stop()
	current_state = states.CHASE

func stop_chase() -> void:
	if chase.time_left <= 0:
		chase.start()

func handle_movement(delta: float) -> void:
	if current_state == states.WANDER:
		velocity = velocity.move_toward(direction * speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO * CHASE_SPEED, ACCELERATION * delta)
	move_and_slide()

func change_direction() -> void:
	if current_state == states.WANDER:
		if not ray_cast_down.is_colliding():
			flip_enemy()
		if ray_cast_wall.is_colliding():
			var collider = ray_cast_wall.get_collider()
			if collider != player:
				flip_enemy()
		if sprite_2d.flip_h:
			direction = Vector2(1, 0)
		else:
			direction = Vector2(-1, 0)
	else:
		
		direction = (collider.position - position).normalized()
		direction.x = sign(direction.x)
		direction.y = 0
		if direction.x > 0:
			sprite_2d.flip_h = true
			
			ray_cast_wall.target_position = Vector2(15, 0)
			ray_cast_down.position.x = 20
		else:
			sprite_2d.flip_h = false
			
			ray_cast_wall.target_position = Vector2(-15, 0)
			ray_cast_down.position.x = -20
		if reload.is_stopped():
			bulletspawn()
			reload.start()

func flip_enemy():
	sprite_2d.flip_h = !sprite_2d.flip_h
	if sprite_2d.flip_h:
		
		ray_cast_wall.target_position = Vector2(15, 0)
		ray_cast_down.position.x = 20
	else:
		
		ray_cast_wall.target_position = Vector2(-15, 0)
		ray_cast_down.position.x = -20

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func bulletspawn() -> void:
	var bull : Bullet = BULLET.instantiate()
	bull.position = self.position
	bull.look_at(collider.position)
	bull.dirr = to_global(collider.position)	
	get_parent().add_child(bull)
	
	

func _on_chase_timeout() -> void:
	current_state = states.WANDER


func _on_detection_body_entered(body: Node2D) -> void:
	if body is player:
		collider = body
		chase_player()
	


func _on_detection_body_exited(body: Node2D) -> void:
	if body is player:
		stop_chase()
func onHit() -> bool:
	if hitmark == false:
		hitmark = true
		return false
	else:
		return true
		
	





func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is deadzone or area is atkArea:
		emit_signal("dead")
		queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is player:
		emit_signal("dead")
		queue_free()
