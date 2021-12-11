extends WorldEnvironment

export var noise:OpenSimplexNoise
export var x:float
export var z:float

var chunks:Dictionary = {}
var chunk_scene = preload("res://chunks_assets/Chunk.tscn")
var thread:Thread

func _ready():
	thread = Thread.new()
	var chunk_instance = chunk_scene.instance()
	chunk_instance.generate_chunk(noise, 0, 0)
	add_child(chunk_instance)
	var chunk_instance_01 = chunk_scene.instance()
	chunk_instance_01.generate_chunk(noise, 0, 1)
	add_child(chunk_instance_01)

func add_chunk():
	var key = str(x) + "," + str(z)
	if not thread.is_active():
		pass
