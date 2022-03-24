extends KinematicBody

signal asteroid_dead

# define a random speed for each unit

var time_alive = 0
var alive = true

var rot_x_speed 	= .2
var rot_y_speed 	= .2
var speed 			= 5
var size = 1

var health = size * 2

func _ready():
	resize(size)
	
var rot_value = Vector3()

func _physics_process(delta):
	time_alive += delta
	
	# if this asteroid is 200 units behind player, kill this instance
	if global_transform.origin.z > 200:
		queue_free()
		return
	
	# calculate rotation
	rot_value.x += rot_x_speed * delta
	rot_value.y += rot_y_speed * delta
	rot_value.x = clamp(rot_value.x,0,360)
	rot_value.y = clamp(rot_value.y,0,360)
	
	# rotate the asteroid
	$AsteroidBody.rotation = rot_value
	
	# move the asteroid based on its movement heading
	var _result = move_and_slide(-global_transform.basis.z * speed)

func resize(scale):
	set_scale(Vector3(scale, scale, scale))

func _on_Area_body_entered(body):
	if time_alive > 2:
		if body.is_in_group("PlayerBullet"):
			
			# Kill the bullet
			body.queue_free()
			
			if health > 1:
				# take away some health
				health -= 1
				return
			
			# health is less than 1.. time to die
			emit_signal("asteroid_dead", self)
		
		if body.is_in_group("Asteroid"):
			print("Asteroids collided")
			emit_signal("asteroid_dead", self)

