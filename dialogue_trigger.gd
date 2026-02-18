extends Node3D

@onready var dialogue_text: RichTextLabel = get_tree().current_scene.get_node("dialogue_box/canvas/dialogue_text")
@onready var dialogue_animation: AnimationPlayer = get_tree().current_scene.get_node("dialogue_box/canvas/AnimationPlayer")
@onready var player: CharacterBody3D = get_tree().current_scene.get_node("player")
@onready var dialogue_box = get_tree().current_scene.get_node("dialogue_box/canvas")

@export var dialogues: Array[String]
@export var interacted_with: Node3D

var current_dialogue = -1
var started = false

func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact"):
		if started:
			continue_dialogue()

func start_dialogue(body):
	print("in body")
	if body == player:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.speed = 0.0
		#player.sensitivity = 0.0
		dialogue_box.visible = true
		player.camera.look_at(interacted_with.global_transform.origin)
		# stop light dimming?
		player.process_pings = false
		started = true
		continue_dialogue()

func end_dialogue():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.speed = player.DEFAULT_SPEED
	player.sensitivity = player.DEFAULT_SENS
	dialogue_box.visible = false
	player.process_pings = true
	started = false

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
