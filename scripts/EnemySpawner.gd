extends Spatial

onready var main = get_tree().current_scene
var Enemy = preload("res://scenes/enemy1.tscn")

func spawn():
	var enemy = Enemy.instance()
	main.add_child(enemy)
	
	enemy.transform.origin = transform.origin + Vector3(rand_range(-15,15),rand_range(-10,10),0)

func _on_Timer_timeout():
	spawn()

