extends Node3D

@onready var dialogue_text: RichTextLabel = get_tree().current_scene.get_node("dialogue_box/canvas/Container/dialogue_text")
@onready var dialogue_animation: AnimationPlayer = get_tree().current_scene.get_node("dialogue_box/canvas/AnimationPlayer")
@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var dialogue_box = get_tree().current_scene.get_node("dialogue_box/canvas")

@export var dialogues: Array[String]

var current_dialogue: int = -1
var started: bool = false
var in_body: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if started:
			if dialogue_animation.is_playing():
				dialogue_animation.pause()
				dialogue_text.visible_ratio = 1
			else:
				continue_dialogue()
		elif in_body:
			var vec_to_point = player.camera.global_position - self.global_position
			if vec_to_point.angle_to(player.camera.global_transform.basis.z) < deg_to_rad(45):
				start_dialogue()

func start_dialogue():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	player.speed = 0.0
	player.sens_mod = 0.0
	dialogue_box.visible = true
	#player.camera.look_at(self.global_position)
	noises.process_pings = false
	started = true
	continue_dialogue()

func end_dialogue():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.speed = player.DEFAULT_SPEED
	player.sens_mod = player.DEFAULT_SENS
	dialogue_box.visible = false
	noises.process_pings = true
	started = false
	current_dialogue = -1

func continue_dialogue():
	current_dialogue += 1
	if current_dialogue < dialogues.size():
		if !dialogue_box.visible:
			dialogue_box.visible = true
		dialogue_text.text = dialogues[current_dialogue]
		dialogue_animation.play("RESET")
		dialogue_animation.play("typing")
	else:
		end_dialogue()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		in_body = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		in_body = false
