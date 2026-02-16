extends CharacterBody3D

@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1
const SPEED = 5.0
var mouse_captured: bool = false
var look_dir: Vector2
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	capture_mouse()

func _process(_delta: float) -> void:
	get_parent().get_node("MainShader").mesh.material.set_shader_parameter("noise_position", global_position)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward: Vector3 = camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	var walk_dir: Vector3 = Vector3(forward.x, 0, forward.z).normalized()
	velocity = velocity.move_toward(walk_dir * SPEED * input_dir.length(), 100 * delta)
	move_and_slide()

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
