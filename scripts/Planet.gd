extends Spatial


var rotationspeed = -1
var rot_x = 0
var rot_y = 0
var rot_z = 0

func _process(delta):
	rot_x += 0
	rot_y += rotationspeed * delta
	rot_z += 0
	
	rot_x = lock_into_rotation(rot_x)
	rot_y = lock_into_rotation(rot_y)
	rot_z = lock_into_rotation(rot_z)
	
	rotation_degrees = Vector3(rot_x,rot_y,rot_z)

func lock_into_rotation(angle):
	var result = fmod(angle, 360)
	# check if negative number
	if result < 0: result += 360
	return result
