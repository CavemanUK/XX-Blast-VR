extends KinematicBody

# define default speed
var speed = Globals.ENEMY_DEFAULT_BULLET_SPEED

# make a note of origin point so we can see how far bullet has travelled
onready var origin_point = global_transform.origin

func _physics_process(_delta):
	# If game is initialising, don't bother continuing
	if Globals.gameStatus == Globals.GameInitialising:
		return
		
	# When this was instantiated, the bullet was given a direction to look
	# we move back along the z axis.  negative because thats forward
	var _result = move_and_slide(-global_transform.basis.z * speed)
	
	# if bullet has travelled further than the default range, kill it
	if translation.distance_to(origin_point) > Globals.ENEMY_DEFAULT_BULLET_DISTANCE:
		queue_free()


