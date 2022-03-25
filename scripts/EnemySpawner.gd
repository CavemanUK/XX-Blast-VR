extends Spatial

#const MAX_ENEMIES = 30
#timerout should be 2


const MAX_ENEMIES = 200



onready var main = get_tree().current_scene
onready var Enemy = Globals.Enemy

func spawn():
	var numEnemies = get_tree().get_nodes_in_group("Enemy").size()
	if numEnemies < MAX_ENEMIES:
		var enemy = Enemy.instance()
		main.add_child(enemy)
		enemy.transform.origin = transform.origin + Vector3(rand_range(-50,50),rand_range(-50,50),rand_range(-50,50))

			
func _on_Timer_timeout():
	if Globals.gameRunning:
		spawn()
