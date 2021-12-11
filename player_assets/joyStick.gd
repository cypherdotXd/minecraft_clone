extends Node2D

signal use_move_vector
var radius:Vector2 = Vector2(12,12)

func _process(delta):
	if $Background/Button.position.length() > Vector2(256, 256).length():
		$Background/Button.position = Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		$Background/Button.set_global_position(event.position)
		var move_vector:Vector3
		move_vector.x = -$Background/Button.position.normalized().x
		move_vector.z = -$Background/Button.position.normalized().y
		if $Background/Button.position.length() > Vector2(256, 256).length():
			move_vector = Vector3.ZERO
		emit_signal("use_move_vector", move_vector)
