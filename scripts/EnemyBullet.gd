extends KinematicBody

#define default speed
const DEFAULT_SPEED = 30
var speed = DEFAULT_SPEED
var active = false

# When this was instantiated, the bullet was given a direction to look
# physics process sends the back along the z axis.  negative because thats forward
func _physics_process(_delta):
	if active:
		var _result = move_and_slide(global_transform.basis.z * speed)

# when timeout out on the Life Timer, kill the bullet
func _on_LifeTimer_timeout():
	deactivate()

# check if enemy bullet hit an enemy
# if so, remove bullet but don't do anything to the enemy unit	
func _on_Area_body_entered(body):
	if body.is_in_group("Enemies"):
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
	$LifeTimer.start()

