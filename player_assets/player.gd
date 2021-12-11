extends KinematicBody

var mouse_sens = 0.3
var camera_anglev=0
var is_mouse_captured:float = true
var input:Vector3
export var speed:float

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	GameState.player_position = transform.origin
	transform.origin += input * speed * delta
	if Input.is_action_pressed("mouse_lock"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		is_mouse_captured = true
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_mouse_captured = false

#func _physics_process(delta):
#	move_and_slide(speed * input)
	
func _input(event):
	if is_mouse_captured:
		if event is InputEventMouseMotion:
			rotate_object_local(Vector3.UP, deg2rad(-event.relative.x*mouse_sens))
			rotate_object_local(Vector3.LEFT, deg2rad(-event.relative.y*mouse_sens))

func _on_JoyStick_use_move_vector(move_vector):
	input = move_vector
