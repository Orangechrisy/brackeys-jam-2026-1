extends CharacterBody3D

@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1
const SPEED = 5.0
var mouse_captured: bool = false
var look_dir: Vector2
@onready var camera: Camera3D = $Camera3D
@onready var timer: Timer = $Timer

var shader_array: Array[Vector4] = []
var index: int = 0

func _ready() -> void:
	capture_mouse()
	shader_array.resize(10)
	_on_timer_timeout()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward: Vector3 = camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	var walk_dir: Vector3 = Vector3(forward.x, 0, forward.z).normalized()
	velocity = velocity.move_toward(walk_dir * SPEED * input_dir.length(), 100 * delta)
	if timer.paused == false and velocity == Vector3(0.0, 0.0, 0.0):
		timer.paused = true
	elif timer.paused == true and velocity != Vector3(0.0, 0.0, 0.0):
		timer.paused = false
	move_and_slide()

func _on_timer_timeout() -> void:
	shader_array = add_to_array(shader_array, global_position, Time.get_ticks_msec()/1000.0)
	print(shader_array)
	timer.start()

func _process(delta: float) -> void:
	for i in shader_array.size():
		shader_array[i].w -= delta / 2.0;
	get_parent().get_node("MainShader").mesh.material.set_shader_parameter("noise_points", shader_array)

func add_to_array(a: Array, pos: Vector3, _t: float):
	a[index] = Vector4(pos.x, pos.y, pos.z, 1.0)
	index = (index + 1) % 10
	return a

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed(&"escape"): get_tree().quit()

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
