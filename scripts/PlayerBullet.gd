extends KinematicBody

var speed = 100

onready var controller = $"../FPController/LeftHandController"
	
func _ready():
	# buzz the controller for feed back
	if controller:
		controller.rumblePulse(.1)
	
	$BulletSound.play()

func _physics_process(_delta):
	var _result = move_and_slide(-global_transform.basis.z * speed)

# kill the shot after a certain amount of seconds
func _on_LifeTimer_timeout():
	queue_free()

