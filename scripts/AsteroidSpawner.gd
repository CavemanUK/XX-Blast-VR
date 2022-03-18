extends Spatial

const MAX_ASTEROIDS = 20

onready var main = get_tree().current_scene

func _on_Timer_timeout():
	var numAsteroids = get_tree().get_nodes_in_group("Asteroid").size()
	print("Asteroids:"+str(numAsteroids))
	if numAsteroids < MAX_ASTEROIDS:
		var asteroid = Preloads.Asteroid.instance()
		main.add_child(asteroid)
		asteroid.transform.origin = transform.origin + Vector3(rand_range(-100,60),rand_range(-100,60),rand_range(-300,50))
