extends Spatial

export var max_size:float
export var min_size:float
export var player_distance:float
export var distance_from_sun:float
export var angular_speed:float
export var position:Vector3
export var is_vertical:bool = false

var player_in_contact:bool = false
var velocity:Vector3
var angle:float
var speed:float

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector3.ONE * 3 * max_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	angle += angular_speed*delta
	player_distance = (transform.origin - GameState.player_position).length()
	if player_distance < max_size+10:
		player_in_contact = true
	else:
		player_in_contact = false


func _physics_process(delta):
	velocity.x = cos(deg2rad(angle))*distance_from_sun
	if is_vertical:
		velocity.y = sin(deg2rad(angle))*distance_from_sun
	else:
		velocity.z = sin(deg2rad(angle))*distance_from_sun
	translation = (10*position) + velocity
