extends KinematicBody

#define default speed
const DEFAULT_SPEED = 30
var speed = DEFAULT_SPEED

func _ready():
	$LifeTimer.start()

# When this was instantiated, the bullet was given a direction to look
# physics process sends the back along the z axis.  negative because thats forward
func _physics_process(_delta):
	var _result = move_and_slide(global_transform.basis.z * speed)

# when timeout out on the Life Timer, kill the bullet
func _on_LifeTimer_timeout():
	queue_free()

# check if enemy bullet hit an enemy
# if so, remove bullet but don't do anything to the enemy unit	
func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		queue_free()

