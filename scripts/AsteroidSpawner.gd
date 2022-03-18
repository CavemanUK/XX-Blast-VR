extends Spatial

const MAX_ASTEROIDS = 20

onready var main = get_tree().current_scene

func _on_Timer_timeout():
	var numAsteroids = get_tree().get_nodes_in_group("ACTIVE_ASTEROIDS").size()
	if numAsteroids < MAX_ASTEROIDS:
		var asteroid = AsteroidPool.getNextAsteroidNode()
		if asteroid:
			var spawnPoint =  Vector3(rand_range(-250,250),rand_range(-250,250),rand_range(-200,-100))
			asteroid.activate(transform.origin + spawnPoint)
			# var spawnPoint =  
			
			
			
