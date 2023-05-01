extends Area


func _on_Dropoff_body_entered(body):
	if body.is_in_group("player"):
		body.set_box(false)
		$AudioStreamPlayer3D.play()
		yield($AudioStreamPlayer3D,"finished")
		queue_free()
