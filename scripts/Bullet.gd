extends KinematicBody

var speed = 100

onready var controller = $"../FPController/LeftHandController"
onready var main = get_tree().current_scene
onready var Explosion = preload("res://scenes/ExplosionParticles.tscn")

func _ready():
	# rumble controller for haptic feedback of the gun firing
	# checks to see if controller exists first.  If not, likely not in VR
	
	if controller:
		controller.rumblePulse(.1)

func _physics_process(_delta):
	move_and_slide(-global_transform.basis.z * speed)

func _on_LightTimer_timeout():
	$OmniLight.visible = false

func _on_LifeTimer_timeout():
	queue_free()

func _on_Area_body_entered(body):
	if body.is_in_group("Enemies"):
		var explosion = Explosion.instance()
		
		main.add_child(explosion)
		controller.rumblePulse(1)
		explosion.transform.origin = body.transform.origin
		explosion.explode()
		body.queue_free()
		queue_free()
