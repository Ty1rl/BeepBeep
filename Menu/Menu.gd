extends Control

signal restart

onready var main = $CenterContainer/Main
onready var settings = $CenterContainer/Settings
onready var timer = $Timer

var score:int
var prev_score:int
var high_score:int

func _ready():
	get_tree().paused = true

func _unhandled_key_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		main.visible = true
		timer.set_paused(true)

func _on_PlayButton_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	main.visible = false
	if timer.is_stopped():
		timer.start(60)
		score = 0
	timer.set_paused(false)

func _on_SettingsButton_pressed():
	main.visible = false
	settings.visible = true

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_BackButton_pressed():
	main.visible = true
	settings.visible = false

func _on_VolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)


func _on_FullscreenButton_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)


func _on_Timer_timeout():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	main.visible = true
	if score > high_score:
		high_score = score
		$CenterContainer/Main/HighScoreLabel.set_text("HighScore: "+str(high_score))
	emit_signal("restart")

func _physics_process(delta):
	$HUD/TimerLabel.set_text(str(timer.get_time_left()))
	$HUD/ScoreLabel.set_text(str(score))

func _on_City_score_update(new_score):
	score = new_score
