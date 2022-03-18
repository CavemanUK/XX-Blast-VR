extends Node

const MAX_ENEMIES = 10

var enemies = {}

onready var Enemy = preload("res://scenes/Enemy.tscn")
onready var main = get_tree().current_scene

func _ready():
	for i in MAX_ENEMIES:
		enemies[i] = Enemy.instance()
		main.add_child(enemies[i])
		enemies[i].transform.origin = Vector3(5000,5000,5000)
			
func getNextEnemyNode():
	for i in MAX_ENEMIES:
		if enemies[i].active == false:
			return enemies[i]
	return false
