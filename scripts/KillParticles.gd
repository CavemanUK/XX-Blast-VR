extends Spatial

func explode():
	$CPUParticles.emitting = true

func _on_Timer_timeout():
	queue_free()
