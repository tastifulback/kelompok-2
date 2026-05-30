extends CharacterBody2D
class_name mediumEnemy

@export var speed := 50.0
@export var CHASE_SPEED := 300
@export var ACCELERATION := 300

var GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction : Vector2
var right_bounds : Vector2
var left_bounds : Vector2
@onready var atack = preload("uid://bbmhx1xagrw85")
@onready var collider
@onready var ray_cast_horizontal: RayCast2D = $Sprite2D/RayCastHorizontal
@onready var ray_cast_down: RayCast2D = $Sprite2D/RayCastDown
@onready var ray_cast_wall: RayCast2D = $Sprite2D/RayCastWall
@onready var rayatk = $Sprite2D/RayCastattack
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var atkWait: Timer = $attackWait
@onready var chase: Timer = $chase
@onready var hasAtk : bool =false

@onready var hitmark : bool = false
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
	look_for_player()
	change_direction()
	handle_movement(delta)

func look_for_player():
	if rayatk.is_colliding():
		if !hasAtk and collider is player:
				atkWait.start()
				hasAtk = true
				CHASE_SPEED = 0
	if ray_cast_horizontal.is_colliding():
		collider = ray_cast_horizontal.get_collider()
		if collider is player:
			chase_player()
			
			
		elif current_state == states.CHASE:
			stop_chase()
	elif current_state == states.CHASE:
		stop_chase()

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
		velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELERATION * delta)
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
			ray_cast_horizontal.target_position = Vector2(125, 0)
			ray_cast_wall.target_position = Vector2(25, 0)
			rayatk.target_position = Vector2(27, 0)
			ray_cast_down.position.x = 100
		else:
			sprite_2d.flip_h = false
			ray_cast_horizontal.target_position = Vector2(-125, 0)
			ray_cast_wall.target_position = Vector2(-25, 0)
			rayatk.target_position = Vector2(-27, 0)
			ray_cast_down.position.x = -100

func flip_enemy():
	sprite_2d.flip_h = !sprite_2d.flip_h
	if sprite_2d.flip_h:
		ray_cast_horizontal.target_position = Vector2(125, 0)
		ray_cast_wall.target_position = Vector2(25, 0)
		rayatk.target_position = Vector2(27, 0)
		ray_cast_down.position.x = 100
	else:
		ray_cast_horizontal.target_position = Vector2(-125, 0)
		ray_cast_wall.target_position = Vector2(-25, 0)
		rayatk.target_position = Vector2(-27, 0)
		ray_cast_down.position.x = -100

func attack() -> void:
	var atk : medium = atack.instantiate()
	atk.position = to_local(position)
	atk.attackDone.connect(attackDone)
	if sprite_2d.flip_h:
		atk.scale.x = 1
	else:
		atk.scale.x = -1
	add_child(atk)
		
	
func onHit() -> bool:
	if hitmark == false:
		hitmark = true
		return false
	else:
		return true
		
	

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func _on_chase_timeout() -> void:
	current_state = states.WANDER


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player:
		print("dead")
		emit_signal("dead")
		queue_free()
		

func attackDone() -> void:
	hasAtk = false
	CHASE_SPEED = 300

func _on_attack_wait_timeout() -> void:
	attack()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is deadzone:
		print("dead")
		emit_signal("dead")
		queue_free()
