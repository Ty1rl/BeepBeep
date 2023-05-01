extends VehicleBody

onready var camera = $InterpolatedCamera
onready var box = $Body/Box
onready var pointer = $InterpolatedCamera/Pointer
onready var audio = $AudioStreamPlayer3D

var pitch:float
var target:Vector3

func _ready():
	camera.set_as_toplevel(true)

func _unhandled_key_input(event):
	set_engine_force((Input.get_action_strength("forward") - Input.get_action_strength("backward"))*100)
	set_steering((Input.get_action_strength("left") - Input.get_action_strength("right"))*10)
	set_brake(Input.get_action_strength("brake"))
	
	if event.is_action_pressed("reset"):
		global_transform.origin = global_transform.origin + Vector3(0,1,0)
		rotation = Vector3(0,rotation.y,0)

func _physics_process(delta):
	camera.look_at(global_transform.origin,Vector3.UP)
	pointer.look_at(target,Vector3.UP)
	pitch = lerp(pitch,get_engine_force()*.01,delta)
	pitch = clamp(pitch,0.25,2)
	audio.set_pitch_scale(pitch)

func set_box(new_bool:bool):
	box.visible = new_bool

func _on_City_new_objective(target_pos):
	target = target_pos


func _on_Menu_restart():
	set_box(false)
