extends KinematicBody

var speed = 100

onready var controller = $"../FPController/LeftHandController"
onready var main = get_tree().current_scene

func _ready():
	# rumble controller for haptic feedback of the gun firing
	# checks to see if controller exists first.  If not, likely not in VR
	
	if controller:
		controller.rumblePulse(.1)

func _physics_process(_delta):
	move_and_slide(-global_transform.basis.z * speed)

func _on_LifeTimer_timeout():
	queue_free()

func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		var explosion = Preloads.EnemyExplosion.instance()
		
		main.add_child(explosion)
		controller.rumblePulse(1)
		explosion.transform.origin = body.transform.origin
		explosion.explode()
		body.queue_free()
		queue_free()

	if body.is_in_group("Asteroid"):
		# player laser has no effect on asteroids and is absorbed
		queue_free()
