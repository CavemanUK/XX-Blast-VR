extends Spatial

onready var AsteroidExplosion = preload("res://scenes/AsteroidExplosion.tscn")
onready var Asteroid = preload("res://scenes/Asteroid.tscn")

onready var GameWorld = $"/root/Main/GameWorld"

const ASTEROID_SPAWN_RATE = 5.00
const ASTEROID_MIN_X_ORIGIN = -150.00
const ASTEROID_MAX_X_ORIGIN = 150.00
const ASTEROID_MIN_Y_ORIGIN = -150.00
const ASTEROID_MAX_Y_ORIGIN = 150.00
const ASTEROID_MIN_Z_ORIGIN = -800.00
const ASTEROID_MAX_Z_ORIGIN = -350.00
const ASTEROID_MIN_SPEED = 10.00
const ASTEROID_MAX_SPEED = 50.00
const ASTEROID_MIN_SIZE = .2
const ASTEROID_MAX_SIZE = .5
const MAX_ASTEROIDS = 30

func _ready():
	# set the spawn rate timer
	$Timer.wait_time = ASTEROID_SPAWN_RATE

func _on_Timer_timeout():
	# check how many asteroids are in play already.
	var numAsteroids = get_tree().get_nodes_in_group("Asteroid").size()
	
	# if not maximum then lets spawn another!
	if numAsteroids < MAX_ASTEROIDS:
		spawn()
		
func spawn():
	# generate a random speed 
	var speed = rand_range(ASTEROID_MIN_SPEED,ASTEROID_MAX_SPEED)
	
	# generate a random origin for the unit so it spawns randomly around the origin point
	var pos_x = rand_range(ASTEROID_MIN_X_ORIGIN,ASTEROID_MAX_X_ORIGIN)
	var pos_y = rand_range(ASTEROID_MIN_Y_ORIGIN,ASTEROID_MAX_Y_ORIGIN)
	var pos_z = rand_range(ASTEROID_MIN_Z_ORIGIN,ASTEROID_MAX_Z_ORIGIN)
	
	# generate a random size
	var size = rand_range(ASTEROID_MIN_SIZE,ASTEROID_MAX_SIZE)
	
	# create a new instance
	var asteroid = Asteroid.instance()
	
	# add it to the game world
	GameWorld.add_child(asteroid)

	# place it in the correct position in the GameWorld
	asteroid.global_transform.origin =  global_transform.origin + Vector3(pos_x,pos_y,pos_z)
	
	# resize to the generated size
	asteroid.resize(size)
	
	# set its speed
	asteroid.speed = speed
	
	# connect a signal to handle when it dies
	asteroid.connect("asteroid_dead", self, "processDeadAsteroid")

func processDeadAsteroid(oldAsteroid):
	#
	# Function to see if the old asteroid needs splitting into fragments and handles destroying it
	#
	
	# prevent multiple calls to this function in relation to this asteroid while it's being destroyed.
	if oldAsteroid.alive == true:
		oldAsteroid.alive = false
	
		# get the size of the old asteroid and halve it for the fragments
		var newAsteroidScale = oldAsteroid.get_scale().x / 2
		var newAsteroidSpeed = oldAsteroid.speed
		var spawnPoint = {}
		var newAsteroidHeading = oldAsteroid.rotation
	
		# uses the spawnpoint nodes placed in the Asteroid scene (possibly not required)
		spawnPoint[0] = oldAsteroid.get_node("AsteroidBody/spawnPoint0").global_transform.origin
		spawnPoint[1] = oldAsteroid.get_node("AsteroidBody/spawnPoint1").global_transform.origin
	
		# call the function to kill the old asteroid node
		destroyAsteroid(oldAsteroid)

		# if asteroids are really small, no point creating fragments
		if newAsteroidScale < .02:
			return

		# generate 2 new fragments
		for i in 2:
			# create a new instance
			var newAsteroid = Asteroid.instance()
			
			# add into the world
			GameWorld.add_child(newAsteroid)
			
			# resize to the new size
			newAsteroid.resize(newAsteroidScale)
			
			# place new asteroid on one of the spawn points so new fragments don't hit each other
			newAsteroid.global_transform.origin = spawnPoint[i]
			
			# set asteroids speed to be slightly faster because of blast
			newAsteroid.speed = newAsteroidSpeed * 1.5
			
			# now we need to rotate the asteroids slightly so they head off in different directions
			
			# First, lets make smaller fragment point in same direction as parent did
			newAsteroid.rotation = newAsteroidHeading
			
			# now lets send new asteroid off in slightly different direction
			var rand_x = rand_range(0,360)
			var rand_y = rand_range(0,360)
			
			# determine which spawnpoint we are doing to rotate in the oposite direction
			if i == 0:
				newAsteroid.rotation_degrees += Vector3(rand_x,rand_y,0)
			else:
				newAsteroid.rotation_degrees += Vector3(-rand_x,-rand_y,0)
			
			# connect signals to the fragments
			newAsteroid.connect("asteroid_dead", self, "destroyAsteroid")
		
func destroyAsteroid(asteroid):
	# create an explosion instance
	var explosion = AsteroidExplosion.instance()
	# add to the GameWorld
	GameWorld.add_child(explosion)
	# move to the position of the asteroid
	explosion.transform.origin = asteroid.transform.origin
	# halve the scale because its too big otherwise
	explosion.scale = asteroid.scale / 2
	# kill the asteroid node	
	asteroid.queue_free()
