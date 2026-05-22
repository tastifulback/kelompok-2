extends CharacterBody2D
class_name player
@onready var dashTime = $dashTime
@onready var reloadTime = $reloadTime
@export var reloadHowMany = 5
@onready var STRING = preload("uid://dq7vh3iffl7ms")
@onready var enemyList = PackedVector2Array([])
@onready var enemyN = 0
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("shift"):
		if dashTime.is_stopped():
			SPEED *= 3
			dashTime.start()
	if Input.is_action_just_pressed("w") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("s") and !is_on_floor():
		velocity.y = -JUMP_VELOCITY
	if Input.is_action_just_pressed("attack"):
		if reloadTime.is_stopped():
			stringSpawn()
			
		
	if Input.is_action_just_released("attack"):
		reloadHowMany -= int(enemyList.size())
		reloadTime.start()
		enemyKill()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("a", "d")
	if direction:
		
			
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func stringSpawn() ->void :
	var Line : stringer = STRING.instantiate()
	get_parent().add_child(Line)
	Line.ray.add_exception(self)
	Line.global_position = global_position
	Line.enemies.connect(enemyListFunc)
	Line.set_point_position(0, Vector2.ZERO) 
	Line.set_point_position(1, Line.get_local_mouse_position())

	
func enemyListFunc(enemy):
	enemyList.append(enemy)
func enemyKill():
	if !enemyList.is_empty():
		var tween= create_tween()
		tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)	
		for i in range(enemyList.size()):
			
			
			tween.tween_property(self, "global_position", enemyList[i],0.18 )
		
	enemyList.clear()

	
	





func _on_dash_time_timeout() -> void:
	dashTime.stop()
	SPEED /= 3


func _on_reload_time_timeout() -> void:
	if reloadHowMany > 0:
		print("reload")
		reloadTime.start()
		reloadHowMany -= 1
		
	
	else: 
		reloadTime.stop()
		reloadHowMany = 5
		
