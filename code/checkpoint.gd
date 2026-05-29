extends Area2D
class_name checkPoint

@onready var Currpos : Vector2
@onready var sprite = $AnimatedSprite2D
signal currCheckpoint(Currpos)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is player:
		sprite.play("red")
		Currpos = body.position
		currCheckpoint.emit(Currpos)
	
