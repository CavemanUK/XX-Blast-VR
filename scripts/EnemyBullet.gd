extends KinematicBody

var spd = 1

func _physics_process(delta):
	move_and_collide(-global_transform.basis.z * spd)

func _on_LightTimer_timeout():
	$OmniLight.visible = false

func _on_LifeTimer_timeout():
	queue_free()

