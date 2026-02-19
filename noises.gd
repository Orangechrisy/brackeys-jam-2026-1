extends Node

var shader_array: Array[Vector4] = []
var index: int = 0
var process_pings: bool = true

func _ready() -> void:
	shader_array.resize(10)

func _process(delta: float) -> void:
	if process_pings:
		for i in shader_array.size():
			shader_array[i].w -= delta / 2.0;
		get_tree().current_scene.get_node("MainShader").mesh.material.set_shader_parameter("noise_points", shader_array)

func add_to_array(pos: Vector3, _t: float):
	shader_array[index] = Vector4(pos.x, pos.y, pos.z, 1.0)
	index = (index + 1) % 10
