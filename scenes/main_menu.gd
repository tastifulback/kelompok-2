extends Control

var button_type = null
func _on_start_pressed() -> void:
	button_type = 'start'
	$transition.show()
	$transition/transition_time.start()
	$transition/AnimationPlayer.play('fade_in')
func _on_exit_pressed() -> void:
	button_type = 'exit'
	$transition.show()
	$transition/transition_time.start()
	$transition/AnimationPlayer.play('fade_in')

func _on_transition_time_timeout() -> void:
	if button_type == 'start' :
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
		
	else :
		get_tree().quit()
