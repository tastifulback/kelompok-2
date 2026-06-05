extends CharacterBody2D
class_name player
@onready var dashTime = $dashTime
@onready var reloadTime = $reloadTime
@export var reloadHowMany : int = 5
@onready var isReloading : bool = false
@onready var STRING = preload("uid://dq7vh3iffl7ms")
@onready var PARRY = preload("uid://uqebod7rsle3")

@onready var stringMusic = $AudioStreamPlayer2D
@onready var reloadGraphic = $AnimatedSprite2D
@onready var enemyList = PackedVector2Array([])
@onready var enemyN : int = 0
@export var SPEED : float = 350.0
@export var JUMP_VELOCITY: float = -500.0
@onready var dashAllow : bool = true
@onready var respawn : Vector2
@onready var directionP : float
@onready var doneParry : bool = false
@onready var isATK : bool = false
signal musicEnd
signal dead

func _ready() -> void:
	reloadGraphic.play("0")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_on_floor():
		dashAllow = true
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("shift"):
		if dashTime.is_stopped() and dashAllow:
			SPEED = 1050
			dashTime.start()
			dashAllow = false
	if Input.is_action_just_pressed("w")  and is_on_floor() or Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("s") and !is_on_floor():
		velocity.y = -JUMP_VELOCITY
	if Input.is_action_just_pressed("attack"):
		if reloadTime.is_stopped():
			Engine.time_scale = 0.0
			stringSpawn()
	if Input.is_action_just_pressed("parry"):
		if doneParry ==false:
			parrying()
			doneParry = true
		
	if Input.is_action_just_released("attack"):
		if isReloading == false:
			stringMusic.stop()
			isATK = true
			reloadGraphic.play(str(int(reloadHowMany - int(enemyList.size()))))
			Engine.time_scale = 1.0
			reloadHowMany -= int(enemyList.size())
			reloadTime.start()
			isReloading = true
			enemyKill()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("a", "d")
	if global_position < get_global_mouse_position():
		directionP = 1
	if global_position >= get_global_mouse_position():
		directionP = -1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func stringSpawn() ->void :
	stringMusic.play()
	var Line : stringer = STRING.instantiate()
	add_child(Line)
	Line.ray.add_exception(self)
	Line.ray.add_exception(Bullet)
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
	isATK = false

func _on_dash_time_timeout() -> void:
	dashTime.stop()
	SPEED = 350

func _on_reload_time_timeout() -> void:
	if reloadHowMany > 0:
		print("reload")
		reloadTime.start()
		reloadHowMany -= 1
		reloadGraphic.play(str(reloadHowMany))

	else: 
		isReloading = false
		reloadTime.stop()
		reloadHowMany = 5
		reloadGraphic.play("0")

func parrying()-> void:
	var p : parry = PARRY.instantiate()
	p.position = to_local(position)
	if directionP > 0:
		p.scale.x = 1
	else:
		p.scale.x = -1
	p.parryDone.connect(doneParrying)
	p.area_entered.connect(_on_parry_area_entered)
	
	add_child(p)
	
	
func doneParrying() -> void:
	if doneParry == true:
		doneParry = false
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is checkPoint:
		respawn = area.global_position
	if doneParry == false and isATK == false:
		if area is Bullet or area is deadzone or area is heavyAttack or area is medium:
			reloadHowMany = 5
			reloadGraphic.play("0")
			reloadTime.stop()
			isReloading = false
			SPEED = 350
			stringMusic.stop()
			emit_signal("dead")
			position = respawn
	
func _on_parry_area_entered(area: Area2D) -> void:
	if area is medium or area is Bullet or area is heavyAttack:
		reloadTime.stop()
		reloadGraphic.play("0")
		isReloading = false
		reloadHowMany = 5


func _on_audio_stream_player_2d_finished() -> void:
	if isReloading == false:
			emit_signal("musicEnd")
			reloadGraphic.play(str(int(reloadHowMany - int(enemyList.size()))))
			Engine.time_scale = 1.0
			reloadHowMany -= int(enemyList.size())
			reloadTime.start()
			isReloading = true
			enemyKill()
