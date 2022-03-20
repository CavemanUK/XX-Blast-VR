extends Spatial

const MAX_ASTEROIDS = 40

func _on_Timer_timeout():
	var numAsteroids = get_tree().get_nodes_in_group("Asteroid").size()
	if numAsteroids < MAX_ASTEROIDS:
		var asteroid = Globals.Asteroid.instance()
		add_child(asteroid)
		asteroid.transform.origin =  transform.origin + Vector3(rand_range(-250,250),rand_range(-250,250),rand_range(-200,-100))
		#asteroid.look_at(Globals.Player.global_transform.origin, Vector3.UP)
		asteroid.connect("asteroid_dead", self, "processAsteroidDead")

func processAsteroidDead(asteroid):
	if asteroid.alive == true:
		asteroid.alive = false
	
		var asteroid_scale = asteroid.get_scale()
		var asteroid_spawnPoint = {}
		var asteroid_rotation = asteroid.rotation
	
		asteroid_spawnPoint[0] = asteroid.get_node("spawnPoint0").global_transform.origin
		asteroid_spawnPoint[1] = asteroid.get_node("spawnPoint1").global_transform.origin
	
		blowupAsteroid(asteroid)
		yield(get_tree().create_timer(0.1), "timeout")
		var new_scale = asteroid_scale.x / 2
	
		#if asteroids are really small, no point creating fragments
		#if new_scale < .02:
		#	return

		# generate new fragments half the size of the original asteroid
		for i in 2:
			var newasteroid = Globals.Asteroid.instance()
			add_child(newasteroid)
			newasteroid.resize(new_scale)
			newasteroid.global_transform.origin = asteroid_spawnPoint[i]
			newasteroid.rotation = asteroid_rotation
			#newasteroid.look_at(Globals.Player.global_transform.origin, Vector3.UP)
			newasteroid.connect("asteroid_dead", self, "processAsteroidDead")
		
			# send new asteroid off in slightly different direction
			if i == 0:
				newasteroid.rotation_degrees -= Vector3(rand_range(45,90),rand_range(45,90),rand_range(45,90))
			else:
				newasteroid.rotation_degrees += Vector3(rand_range(45,90),rand_range(45,90),rand_range(45,90))
		
func blowupAsteroid(asteroid):
	var explosion = Globals.AsteroidExplosion.instance()
	add_child(explosion)
	explosion.scale = asteroid.scale
	explosion.transform.origin = asteroid.transform.origin
	yield(get_tree().create_timer(0.1), "timeout")
	asteroid.queue_free()
	
