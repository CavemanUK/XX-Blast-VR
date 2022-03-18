extends KinematicBody

# define a random speed for each unit
var speed = rand_range(15,30)
onready var heading = global_transform.basis.z 
onready var main = get_tree().current_scene
onready var player = $"../Player"

var rot_x_speed = rand_range(.1,.4)
var rot_y_speed = rand_range(.1,.4)

var asteroid_scale = rand_range(0.05,0.4)

var rot_value = Vector3()

func _ready():
	set_scale(scale)

func _physics_process(delta):
	# find out distance between player and this asteroid
	var distance_to_player = translation.distance_to(player.global_transform.origin)
	
	if distance_to_player > 500:
		# asteroid too far away, lets kill so another can be spawned
		queue_free()
	else:
		
		rot_value.x += rot_x_speed * delta
		rot_value.y += rot_y_speed * delta
		
		
		rot_value.x = clamp(rot_value.x,0,360)
		rot_value.y = clamp(rot_value.y,0,360)
		
		
		rotation = rot_value
		#set_rot(get_rot() + rot_speed * delta)
		# still nearby, calculate new position
		move_and_slide( heading * speed)
