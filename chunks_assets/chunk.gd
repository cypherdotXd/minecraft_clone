extends Spatial

const CHUNK_SIZE:int = 30
const STEP_SIZE:float = 0.5

var thread:Thread = Thread.new()
var noise:OpenSimplexNoise = OpenSimplexNoise.new()
var hexagon_mesh = preload("res://chunks_assets/untitled.obj")
var offset:Vector3
var chunks:Array = []
var x_size:float = hexagon_mesh.get_aabb().size.x
var y_size:float = hexagon_mesh.get_aabb().size.y
var z_size:float = hexagon_mesh.get_aabb().size.z
var max_height:float = 17
var positions:Array

func _ready():
	for i in range(3):
		for j in range(3):
			spawn_hexagons_at_positions(generate_gridmap([i,j]))

func _process(delta):
	print(Engine.get_frames_per_second())

func generate_gridmap(arr)->Array:
	var x_index:int = arr[0]
	var y_index:int = arr[1]
	var position:Vector3 = Vector3.ZERO
	
	var positions:Array = []
	positions.resize(CHUNK_SIZE)
	for x in range(CHUNK_SIZE):
		positions[x] = []
		positions[x].resize(CHUNK_SIZE)
		for z in range(CHUNK_SIZE):
			var y:float = floor(noise.get_noise_2d(x_index*CHUNK_SIZE+x, y_index*CHUNK_SIZE+z) * max_height) * STEP_SIZE
			if y_index % 2 == 0:
				offset = Vector3(x_index * x_size * CHUNK_SIZE, 0, y_index*((CHUNK_SIZE*x_size)-(CHUNK_SIZE*x_size*0.25)/tan(deg2rad(60))))
			else:
				offset = Vector3(x_index * x_size * CHUNK_SIZE+(0.5*x_size), 0, y_index*((CHUNK_SIZE*x_size)-(CHUNK_SIZE*x_size*0.25)/tan(deg2rad(60))))					
			if z % 2 == 0:
				position = Vector3(x*x_size, y, z-(z*(x_size*0.5)/tan(deg2rad(60))))
			else:
				position= Vector3((x*x_size)+(x_size*0.5), y, z-(z*(x_size*0.5)/tan(deg2rad(60))))
			position += offset
			positions[x][z] = position
	return positions

func spawn_hexagons_at_positions(var positions:Array)->Array:
	var blocks:Array = []
	blocks.resize(CHUNK_SIZE)
	for x in range(CHUNK_SIZE):
		blocks[x] = []
		blocks[x].resize(CHUNK_SIZE)
		for z in range(CHUNK_SIZE):
			var material:SpatialMaterial = SpatialMaterial.new()
			var mesh_instance:MeshInstance = MeshInstance.new()
			mesh_instance.mesh = hexagon_mesh
			mesh_instance.create_trimesh_collision()
			mesh_instance.transform.origin = positions[x][z]
			if positions[x][z].y < 0:
				material.albedo_color = Color.blue
			if positions[x][z].y == 0:
				material.albedo_color = Color.burlywood
			if positions[x][z].y > 0 and positions[x][z].y < (max_height*0.5-4)*STEP_SIZE:
				material.albedo_color = Color.aquamarine
			if positions[x][z].y > (max_height*0.5-4)*STEP_SIZE:
				material.albedo_color = Color.white
			mesh_instance.set_surface_material(0, material)
			add_child(mesh_instance)
			#-storing mesh_instances in an 
			blocks[x][z] = mesh_instance
	return blocks
