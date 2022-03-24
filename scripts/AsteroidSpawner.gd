extends Spatial

const MAX_ASTEROIDS = Globals.MAX_ASTEROIDS

func _ready():
	# set the spawn rate
	$Timer.wait_time = Globals.ASTEROID_SPAWN_RATE

func _on_Timer_timeout():
	# don't spawn asteroids while game is initialising
	if Globals.gameStatus == Globals.GameInitialising:
		return
		
	var numAsteroids = get_tree().get_nodes_in_group("Asteroid").size()
	if numAsteroids < MAX_ASTEROIDS:
		spawn()
		
func spawn():
	# rejiggle the randomizer
	
	# generate a random speed for the unit
	var speed = rand_range(Globals.ASTEROID_MIN_SPEED,Globals.ASTEROID_MAX_SPEED)
	
	# generate a random origin for the unit so it spawns randomly around the origin point
	var pos_x = rand_range(Globals.ASTEROID_MIN_X_ORIGIN,Globals.ASTEROID_MAX_X_ORIGIN)
	var pos_y = rand_range(Globals.ASTEROID_MIN_Y_ORIGIN,Globals.ASTEROID_MAX_Y_ORIGIN)
	var pos_z = rand_range(Globals.ASTEROID_MIN_Z_ORIGIN,Globals.ASTEROID_MAX_Z_ORIGIN)
	
	var size = rand_range(Globals.ASTEROID_MIN_SIZE,Globals.ASTEROID_MIN_SIZE)
	
	var asteroid = Globals.Asteroid.instance()
	Globals.Main.add_child(asteroid)

	asteroid.global_transform.origin =  global_transform.origin + Vector3(pos_x,pos_y,pos_z)
	asteroid.resize(size)
	asteroid.speed = speed
	
	asteroid.connect("asteroid_dead", self, "processAsteroidDead")

	

func processAsteroidDead(asteroid):
	if asteroid.alive == true:
		asteroid.alive = false
	
		var asteroid_scale = asteroid.get_scale()
		var asteroid_speed = asteroid.speed
		var asteroid_spawnPoint = {}
		var asteroid_rotation = asteroid.rotation
	
		asteroid_spawnPoint[0] = asteroid.get_node("AsteroidBody/spawnPoint0").global_transform.origin
		asteroid_spawnPoint[1] = asteroid.get_node("AsteroidBody/spawnPoint1").global_transform.origin
	
		explodeAsteroid(asteroid)
		yield(get_tree().create_timer(0.1), "timeout")
		var new_scale = asteroid_scale.x / 2
	
		# if asteroids are really small, no point creating fragments
		if new_scale < .02:
			return

		# generate new fragments half the size of the original asteroid
		for i in 2:
			var newasteroid = Globals.Asteroid.instance()
			Globals.Main.add_child(newasteroid)
			
			newasteroid.resize(new_scale)
			
			# place new asteroid on one of the spawn points so new fragments don't hit each other
			newasteroid.global_transform.origin = asteroid_spawnPoint[i]
			
			# make smaller fragment point in same direction as starting point
			newasteroid.rotation = asteroid_rotation
			
			# set asteroids speed to be slightly faster because of blast
			newasteroid.speed = asteroid_speed + 10 
			newasteroid.connect("asteroid_dead", self, "processAsteroidDead")
		
			# now lets send new asteroid off in slightly different direction
			var rand_x = rand_range(45,90)
			var rand_y = rand_range(45,90)
			if i == 0:
				newasteroid.rotation_degrees += Vector3(rand_x,rand_y,0)
			else:
				newasteroid.rotation_degrees += Vector3(-rand_x,-rand_y,0)
				
			
		
func explodeAsteroid(asteroid):
	var explosion = Globals.AsteroidExplosion.instance()
	explosion.transform.origin = asteroid.transform.origin
	explosion.scale = asteroid.scale / 2
	Globals.Main.add_child(explosion)
	
	yield(get_tree().create_timer(0.1), "timeout")
	asteroid.queue_free()
