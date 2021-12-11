extends MeshInstance

const CHUNK_SIZE:int = 30
const HEX_SIZE:float = 0.3
const HEX_THICKNESS:float = 0.3
const TRIS_IN_HEX:int = 4
const VERTS_IN_TRIS:int = 3
const STEP_SIZE:float = HEX_THICKNESS

var offset:Vector3
var chunks:Array = []
var max_height:float = 25
var positions:Array
var mat:SpatialMaterial
var noise:OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	var mat = SpatialMaterial.new()
	mat.vertex_color_use_as_albedo = true
	var arr_mesh:ArrayMesh = ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, generate_chunk([0,0]))
	mesh = arr_mesh
	mesh.surface_set_material(0, mat)

func generate_chunk(arr)->Array:
	var x_index   :int   = arr[0]
	var y_index   :int   = arr[1]
	var x_hex_size:float = 1.72*HEX_SIZE
	var y_hex_size:float = 2.00*HEX_SIZE
	
	var mesh_data_arr = []
	mesh_data_arr.resize(Mesh.ARRAY_MAX)
	
	var hex_center:Vector3 = Vector3.ZERO
	var offset:Vector3 = Vector3(x_index*CHUNK_SIZE*x_hex_size, 0, y_index*CHUNK_SIZE*y_hex_size)
	
	var verts:Array = []
	verts.resize(VERTS_IN_TRIS * TRIS_IN_HEX * CHUNK_SIZE * CHUNK_SIZE)
	var vert_colors:Array = []
	vert_colors.resize(VERTS_IN_TRIS * TRIS_IN_HEX * CHUNK_SIZE * CHUNK_SIZE)
	
	for x in range(CHUNK_SIZE):
		for z in range(CHUNK_SIZE):
			
			var y:float = floor(noise.get_noise_2d(x_index*CHUNK_SIZE+x, y_index*CHUNK_SIZE+z) * max_height) * STEP_SIZE
			
			if z % 2 == 0:
				hex_center = Vector3( x*x_hex_size, y, z*(y_hex_size-(0.5*x_hex_size)/tan(deg2rad(60))))+offset
			else:
				hex_center = Vector3( (x*x_hex_size)+(x_hex_size*0.5), y, z*(y_hex_size-(0.5*x_hex_size)/tan(deg2rad(60))))+offset
			
			verts = add_face(verts, hex_center)
			
			for i in range(TRIS_IN_HEX):
				vert_colors.append(Color.red)
				vert_colors.append(Color.green)
				vert_colors.append(Color.blue)
			
	mesh_data_arr[Mesh.ARRAY_VERTEX] = verts
	mesh_data_arr[Mesh.ARRAY_COLOR] = PoolColorArray(vert_colors)
	return mesh_data_arr
	
func add_face(var verts:Array, var center:Vector3)->Array:
	
	var a1:Vector3 = Vector3( 0   , 0,  1  ) * HEX_SIZE
	var b1:Vector3 = Vector3( 0.86, 0,  0.5) * HEX_SIZE
	var c1:Vector3 = Vector3( 0.86, 0, -0.5) * HEX_SIZE
	var d1:Vector3 = Vector3( 0   , 0, -1  ) * HEX_SIZE
	var e1:Vector3 = Vector3(-0.86, 0, -0.5) * HEX_SIZE
	var f1:Vector3 = Vector3(-0.86, 0,  0.5) * HEX_SIZE
	
	verts.append(b1 + center)
	verts.append(a1 + center)
	verts.append(f1 + center)
	
	verts.append(b1 + center)
	verts.append(f1 + center)
	verts.append(e1 + center)
	
	verts.append(c1 + center)
	verts.append(b1 + center)
	verts.append(e1 + center)
	
	verts.append(d1 + center)
	verts.append(c1 + center)
	verts.append(e1 + center)
	
	return verts
