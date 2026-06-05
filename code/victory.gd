extends Area2D

@onready var victory =$Label
@onready var Currpos : Vector2
@onready var sprite = $AnimatedSprite2D
signal currCheckpoint(Currpos)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")
	victory.visible  =false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is player:
		victory.visible  = true
		sprite.play("red")
		
	
