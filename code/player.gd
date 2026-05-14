extends CharacterBody2D
class_name player
@onready var STRING = preload("uid://dq7vh3iffl7ms")
@onready var enemyList = PackedVector2Array([])
@onready var enemyN = 0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("w") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("s") and !is_on_floor():
		velocity.y = -JUMP_VELOCITY
	if Input.is_action_just_pressed("attack"):
		stringSpawn()
	if Input.is_action_just_released("attack"):
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
	Line.global_position = global_position
	Line.enemies.connect(enemyListFunc)
	Line.set_point_position(0, Vector2.ZERO) 
	Line.set_point_position(1, Line.get_local_mouse_position())

	
func enemyListFunc(enemy):
	enemyList.append(enemy)
	print(enemyList)
	
func enemyKill():
	for i in range(enemyList.size()):
		global_position = enemyList[i]
	enemyList.clear()
	
	
