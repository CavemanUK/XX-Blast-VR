extends Node

const MAX_ASTEROIDS = 30

var asteroids = {}

onready var Asteroid = preload("res://scenes/Asteroid.tscn")
onready var main = get_tree().current_scene

func _ready():
	for i in MAX_ASTEROIDS:
		asteroids[i] = Asteroid.instance()
		main.add_child(asteroids[i])
		asteroids[i].transform.origin = Vector3(5000,5000,5000)
			
func getNextAsteroidNode():
	for i in MAX_ASTEROIDS:
		if asteroids[i].active == false:
			return asteroids[i]
	return false
