extends KinematicBody

# default speed of the unit
var speed = 15

# get a variable reference to the root of the project

signal enemy_unit_killed

func _ready():
	# check if game is initialising, if so, don't bother continuing
	if Globals.gameStatus == Globals.GameInitialising:
		return
		
	# set a random timer for the gun to fire
	$FiringTimer.wait_time = rand_range(1,5)
	$FiringTimer.start()
	$AudioStreamPlayer3D.play()

func _physics_process(_delta):
	# check if game is initialising, if so, don't bother continuing
	if Globals.gameStatus == Globals.GameInitialising:
		return
		
	# move the unit
	var _result = move_and_slide(global_transform.basis.z * speed)
	# kill unit if its 200 behind centre of universe
	# change this in future to be distance from player
	if transform.origin.z > 200:
		queue_free()

func _spawn_bullet():
	# create a new bullet instance
	var bullet = Globals.EnemyBullet.instance()
	Globals.Main.add_child(bullet)
	bullet.global_transform.origin = $Gun.global_transform.origin
	bullet.look_at(Globals.player.global_transform.origin, Vector3.UP)
	
	# make sure bullet speed is always proportionate to enemy speed
	bullet.speed = speed + Globals.ENEMY_DEFAULT_BULLET_SPEED
	
func _on_FiringTimer_timeout():
	
	# check if game is initialising, if so, don't bother continuing
	if Globals.gameStatus == Globals.GameInitialising:
		return
		
	# check if player node exists.  don't fire if not there
	if not Globals.GameWorld.get_node_or_null("Player"):
		return	
	
		
	# check that enemy is within a decent range of player, but not too close.
	
	var distance_to_player = translation.distance_to(Globals.player.global_transform.origin)
	if distance_to_player > 90 and distance_to_player < 300:
		
		# check that enemy is in front of player and not flying away behind
		if transform.origin.z < 0:
			_spawn_bullet()
			# set a new random time for the next bullet
			$FiringTimer.wait_time = rand_range(1,5)
			$FiringTimer.start()

func _on_Area_body_entered(body):
	# check if game is initialising, if so, don't bother continuing
	if Globals.gameStatus == Globals.GameInitialising:
		return

	if body.is_in_group("PlayerBullet"):
		body.queue_free()
		# send signal enemy killed and reference self so they know who sent signal
		emit_signal("enemy_unit_killed", self)


