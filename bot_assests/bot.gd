extends KinematicBody

var root_transform
var y_rotation_speed:float = -1
var forward_speed:float = 120
var gravity:float = -25
var velocity:Vector3
var input:Vector2
var shift:float = 0
var space:float = 1
var precision:float = 0.05
var jump_angle:float = 0.523
var jump_velocity2d:Vector2 = Vector2.ZERO
var current_jump_time:float = 0
var max_jump_time:float = 0
var jumping:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	update_input(precision)
	# -----Position------
	root_transform = $AnimationTree.get_root_motion_transform()
	#  gravity logic
	if is_grounded():
		velocity.y = 0
	else:
		velocity.y += gravity*delta
	# shift-sprint logic
	if Input.is_action_pressed("run"):
		$AnimationTree["parameters/walking/blend_position"] = stepify(2*input.y, 0.1)
		y_rotation_speed = -1.3
	else:
		$AnimationTree["parameters/walking/blend_position"] = stepify(input.y, 0.1)
		y_rotation_speed = -1

	
	# applying positions
	velocity = (root_transform.origin * forward_speed) + (Vector3.UP*velocity.y) 
	velocity = move_and_slide_with_snap(transform.basis * velocity, Vector3(0,-0.5,0))
	
	# ------Rotation------
	rotation_degrees = Vector3(0,rotation_degrees.y,10*stepify(input.x,0.1)*stepify(input.y,0.1)*stepify(shift,0.1))
	# y moving rotation
	if is_moving():
		rotate_object_local(Vector3.UP, y_rotation_speed*stepify(input.x,0.1)*delta)
	# y not moving rotation
	$AnimationTree["parameters/standing/blend_amount"] = stepify(input.x,0.1)
	rotate_object_local(Vector3.UP, root_transform.basis.get_euler().y)
	if(is_moving()):
		$AnimationTree["parameters/transition/current"] = 0
	else:
		$AnimationTree["parameters/transition/current"] = 1
	
	
func update_input(precision)->void:
	if Input.is_action_pressed("ui_left") and input.x > -1:
		input.x -= precision
	elif input.x < 0:
		input.x += precision
	if Input.is_action_pressed("ui_right") and input.x < 1:
		input.x += precision
	elif input.x > 0:
		input.x -= precision
	if Input.is_action_pressed("ui_down") and input.y > -1:
		input.y -= precision
	elif input.y < 0:
		input.y += precision
	if Input.is_action_pressed("ui_up") and input.y < 1:
		input.y += precision
	elif input.y > 0:
		input.y -= precision
	# Shift run
	if Input.is_action_pressed("run") and shift < 1:
		shift += precision
	elif shift > 0:
		shift -= precision
	# Space jump
	if Input.is_action_pressed("jump") and space < 1:
		space += precision
	elif space > 0:
		space -= precision
func is_moving()->bool:
	var is_moving:bool = input.y > 0.1 or input.y < -0.1
	return is_moving
func is_grounded()->bool:
	var grounded:bool = $RayCast1.is_colliding() and $RayCast2.is_colliding()
	return grounded
func projectile_motion(var angle:float, var xy_velocity:Vector2, var time:float)->Vector3:
	var projectile_velocity:Vector3
	projectile_velocity.z = xy_velocity.x * cos(angle)
	projectile_velocity.y = ((xy_velocity.y*sin(angle)) + (gravity*time))
	return projectile_velocity
