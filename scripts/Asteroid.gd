extends KinematicBody

signal asteroid_dead

# define a random speed for each unit

onready var main = get_tree().current_scene
onready var player = $"../../../GameWorld/Player"

var time_alive = 0
var alive = true

var rot_x_speed 	= rand_range(.2,.5)
var rot_y_speed 	= rand_range(.2,.5)
var speed 			= rand_range(70,140)
var asteroid_scale 	= rand_range(0.01,0.4)

var health = asteroid_scale * 15

func _ready():
	resize(asteroid_scale)
	
var rot_value = Vector3()

func _physics_process(delta):
	time_alive += delta
	if player:
		var distance_to_player = translation.distance_to(player.global_transform.origin)
		if distance_to_player > 500:
		# asteroid too far away, lets kill so another can be spawned
			queue_free()
		
	rot_value.x += rot_x_speed * delta
	rot_value.y += rot_y_speed * delta
	rot_value.x = clamp(rot_value.x,0,360)
	rot_value.y = clamp(rot_value.y,0,360)
		
	$AsteroidBody.rotation = rot_value
		
	var _result = move_and_slide(-global_transform.basis.z * speed)

func resize(scale):
	set_scale(Vector3(scale, scale, scale))

func _on_Area_body_entered(body):
	if body != self:
		# allow Asteroid to live at least 2 seconds before worrying about collision
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
			
