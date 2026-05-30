extends Node2D
@onready var HEAVY = preload("uid://dj8qs3qhhcy0f")
@onready var dead : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	spawn()
	dead = false
	parent.playerDead.connect(on_playerDead)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn() -> void:
	var enemy : heavyEnemy = HEAVY.instantiate()
	enemy.position = position
	enemy.dead.connect(enemyDied)
	get_parent().add_child.call_deferred(enemy)
func on_playerDead():
	if dead == true:
		spawn()
		dead = false
		
func enemyDied() -> void:
	dead = true
