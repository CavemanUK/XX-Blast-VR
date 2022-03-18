extends Spatial

const MAX_ENEMIES = 10

onready var main = get_tree().current_scene

func spawn():
	var numEnemies = get_tree().get_nodes_in_group("ACTIVE_ENEMIES").size()
	if numEnemies < MAX_ENEMIES:
		var enemy = EnemyPool.getNextEnemyNode()
		if enemy:
			enemy.activate()
			enemy.transform.origin = transform.origin + Vector3(rand_range(-30,30),rand_range(-30,30),rand_range(-50,50))

func _on_Timer_timeout():
	if Globals.gameRunning:
		spawn()
