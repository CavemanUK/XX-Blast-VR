extends Spatial

const MAX_ASTEROIDS = 20

onready var main = get_tree().current_scene

func _on_Timer_timeout():
	var numAsteroids = get_tree().get_nodes_in_group("Asteroid").size()
	if numAsteroids < MAX_ASTEROIDS:
		var asteroid = Globals.Asteroid.instance()
		main.add_child(asteroid)
		asteroid.transform.origin =  transform.origin + Vector3(rand_range(-250,250),rand_range(-250,250),rand_range(-200,-100))
		asteroid.connect("asteroid_hit", self, "processAsteroidHit")

func processAsteroidHit(asteroid):
	
	var asteroid_scale = asteroid.get_scale()
	var asteroid_heading = asteroid.heading
	var asteroid_spawnPoint = {}
	
	asteroid_spawnPoint[0] = asteroid.get_node("spawnPoint0")
	asteroid_spawnPoint[1] = asteroid.get_node("spawnPoint1")
	
	blowupAsteroid(asteroid)
	var new_scale = asteroid_scale.x / 2
	
	# if asteroids are really small, no point creating fragments
	print("new scale "+str(new_scale))
	if new_scale < .05:
		return

	# generate new fragments half the size of the original asteroid
	for i in 1:
		var newasteroid = Globals.Asteroid.instance()
		main.add_child(newasteroid)
		newasteroid.resize(new_scale)
		newasteroid.transform.origin = asteroid_spawnPoint[i].global_transform.origin
		newasteroid.heading = asteroid_heading
		newasteroid.connect("asteroid_hit", self, "processAsteroidHit")
		
		# change heading to be random for now.  I need to figure out how to make them
		# go 45 degrees each way of current heading.
		var x = rand_range(0,.15)
		var y = rand_range(0,.15)
		var z = rand_range(0,.15)
		if i == 0:
			newasteroid.heading = Vector3(x,y,z) 
		else:
			newasteroid.heading = Vector3(-x,-y,-z)

func blowupAsteroid(asteroid):
	var explosion = Globals.EnemyExplosion.instance()
	main.add_child(explosion)
	explosion.transform.origin = asteroid.transform.origin
	asteroid.queue_free()
	
