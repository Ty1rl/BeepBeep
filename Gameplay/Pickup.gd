extends Area


func _on_Pickup_body_entered(body):
	if body.is_in_group("player"):
		body.set_box(true)
		$AudioStreamPlayer3D.play()
		yield($AudioStreamPlayer3D,"finished")
		queue_free()
