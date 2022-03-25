extends KinematicBody

const DEFAULT_SPEED = 15
const DEFAULT_DISTANCE = 300

# define default speed
var speed = DEFAULT_SPEED

# make a note of origin point so we can see how far bullet has travelled
onready var origin_point = global_transform.origin

func _physics_process(_delta):
	# If game isn't running, don't bother continuing
	if not Globals.gameRunning:
		return
		
	# When this was instantiated, the bullet was given a direction to look
	# we move back along the z axis.  negative because thats forward
	var _result = move_and_slide(-global_transform.basis.z * speed)
	
	# if bullet has travelled further than the default range, kill it
	if translation.distance_to(origin_point) > DEFAULT_DISTANCE:
		queue_free()
