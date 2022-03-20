extends KinematicBody

signal asteroid_hit

# define a random speed for each unit

onready var heading = global_transform.basis.z 
onready var main = get_tree().current_scene
onready var player = $"../GameWorld/Player"

var rot_x_speed 	= rand_range(.2,.5)
var rot_y_speed 	= rand_range(.2,.5)
var speed 			= rand_range(100,120)
var asteroid_scale 	= rand_range(0.01,0.4)

var health = asteroid_scale * 30

func _ready():
	resize(asteroid_scale)
	print("Health:" + str(health))
	
var rot_value = Vector3()

func _physics_process(delta):
	if player:
		var distance_to_player = translation.distance_to(player.global_transform.origin)
		if distance_to_player > 500:
		# asteroid too far away, lets kill so another can be spawned
			queue_free()
		
	rot_value.x += rot_x_speed * delta
	rot_value.y += rot_y_speed * delta
	rot_value.x = clamp(rot_value.x,0,360)
	rot_value.y = clamp(rot_value.y,0,360)
		
	rotation = rot_value
		
	var _result = move_and_slide(heading * speed)

func resize(scale):
	set_scale(Vector3(scale, scale, scale))

func _on_Area_body_entered(body):
	if body != self:
		print("got hit")
		if body.is_in_group("PlayerBullet"):
			# Kill the bullet
			body.queue_free()
			
			if health > 1:
				# flash to show hit
				var oldMaterial = $mesh.get_surface_material(0)
				var newMaterial = SpatialMaterial.new()
				
				newMaterial.albedo_color = Color( 0.98, 0.0, 0.0, 1 )
				
				$mesh.set_surface_material(0,newMaterial)
				$mesh.set_surface_material(0,oldMaterial)
				
				# take away some health
				health -= 1
				return
				
			emit_signal("asteroid_hit", self)

# This function will check the size of the asteroid and decide whether its 
# been destroyed or split in two
