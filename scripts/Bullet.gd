extends KinematicBody

var spd = 100

onready var main = get_tree().current_scene
var Explosion = preload("res://scenes/KillParticles.tscn")

func _physics_process(delta):
	move_and_collide(Vector3(0,0,-spd * delta))

func _on_LightTimer_timeout():
	$OmniLight.visible = false

func _on_LifeTimer_timeout():
	queue_free()

func _on_Area_body_entered(body):
	print("entered body")
	
	if body.is_in_group("Enemies"):
		var explosion = Explosion.instance()
		main.add_child(explosion)
		explosion.transform.origin = body.transform.origin
		explosion.explode()
		body.queue_free()
		queue_free()
