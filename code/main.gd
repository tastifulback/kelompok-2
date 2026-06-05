extends Node2D
signal playerDead


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$transition/AnimationPlayer.play('fade_out')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_dead() -> void:
	emit_signal("playerDead")
