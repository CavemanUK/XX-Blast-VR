extends KinematicBody

const DEFAULT_SPEED = 100

var speed = DEFAULT_SPEED
var active = false

onready var controller = $"../FPController/LeftHandController"
	
func _physics_process(_delta):
	if active:
		var _result = move_and_slide(-global_transform.basis.z * speed)

func _on_LifeTimer_timeout():
	deactivate()

func _on_Area_body_entered(body):
	if active:
		
		var main = get_tree().current_scene
		
		if body.is_in_group("Enemy"):
			var explosion = Globals.EnemyExplosion.instance()
		
			main.add_child(explosion)
			controller.rumblePulse(1)
			explosion.transform.origin = body.transform.origin
			explosion.explode()
			body.deactivate()
			deactivate()

		if body.is_in_group("Asteroid"):
			# player laser has no effect on asteroids and is absorbed
			deactivate()

func deactivate():
	visible = false
	global_transform.origin = Vector3(5000,5000,5000)
	active = false
	
	$LifeTimer.stop()

func activate():
	active = true
	visible = true
	speed = DEFAULT_SPEED
	$BulletSound.play()
	$LifeTimer.start()
	
	if controller:
		controller.rumblePulse(.1)
