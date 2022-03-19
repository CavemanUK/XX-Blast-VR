extends KinematicBody

# define a random speed for each unit

var active = false
onready var heading = global_transform.basis.z 
onready var main = get_tree().current_scene
onready var player = $"../GameWorld/Player"

var rot_x_speed = 0
var rot_y_speed = 0
var speed = 0
var asteroid_scale = 0

var rot_value = Vector3()

func _physics_process(delta):
	if active:
		# find out distance between player and this asteroid
		if player:
			var distance_to_player = translation.distance_to(player.global_transform.origin)
			if distance_to_player > 500:
			# asteroid too far away, lets kill so another can be spawned
				deactivate()
		
		rot_value.x += rot_x_speed * delta
		rot_value.y += rot_y_speed * delta
		rot_value.x = clamp(rot_value.x,0,360)
		rot_value.y = clamp(rot_value.y,0,360)
		
		rotation = rot_value
		
		var _result = move_and_slide(heading * speed)


func deactivate():
	visible = false
	global_transform.origin = Vector3(5000,5000,5000)
	active = false
	remove_from_group("ACTIVE_ASTEROIDS")

func activate(spawnPoint):
	rot_x_speed = rand_range(.2,.5)
	rot_y_speed = rand_range(.2,.5)
	speed = rand_range(100,120)
	asteroid_scale = rand_range(0.01,0.4)
	transform.origin = spawnPoint
	set_scale(Vector3(asteroid_scale,asteroid_scale,asteroid_scale))
	active = true
	visible = true
	add_to_group("ACTIVE_ASTEROIDS")

func _on_Area_body_entered(body):
	if active:
		print(self.name + ": I got hit by " + body.name)
		if body.is_in_group("ACTIVE_ASTEROIDS"):
			deactivate()
