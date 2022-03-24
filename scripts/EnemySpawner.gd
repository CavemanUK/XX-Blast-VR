extends Spatial

func _ready():
	# set the spawn rate
	$Timer.wait_time = Globals.ENEMY_SPAWN_RATE

func spawn():
	# rejiggle the randomizer
	randomize()
	
	# generate a random speed for the unit
	var speed = rand_range(Globals.ENEMY_MIN_SPEED,Globals.ENEMY_MAX_SPEED)
	
	# generate a random origin for the unit so it spawns randomly around the origin point
	var pos_x = rand_range(Globals.ENEMY_MIN_X_ORIGIN,Globals.ENEMY_MAX_X_ORIGIN)
	var pos_y = rand_range(Globals.ENEMY_MIN_Y_ORIGIN,Globals.ENEMY_MAX_Y_ORIGIN)
	var pos_z = rand_range(Globals.ENEMY_MIN_Z_ORIGIN,Globals.ENEMY_MAX_Z_ORIGIN)
	
	# create a new unit instance
	var unit = Globals.Enemy.instance()
	
	# add to the main root (will be changing this to GameWorld)
	Globals.Main.add_child(unit)
	
	# set the speed
	unit.speed = speed
	
	# set the location
	unit.transform.origin = transform.origin + Vector3(pos_x, pos_y, pos_z)
	
	# connect to the unit
	unit.connect("enemy_unit_killed", self, "processUnitKilled")
	
func _on_Timer_timeout():
	# if theres a game in progress, spawn an enemy!
	if Globals.gameRunning:
		# find out how many enemies are in play currently
		var numEnemies = get_tree().get_nodes_in_group("Enemy").size()
		# if there are less than the maximum allowed, spawn a new one!
		if numEnemies < Globals.MAX_ENEMIES:
			spawn()

func processUnitKilled(unit):
	var explosion = Globals.EnemyExplosion.instance()
	Globals.Main.add_child(explosion)
	explosion.transform.origin = unit.transform.origin
	explosion.speed = unit.speed
	unit.queue_free()
