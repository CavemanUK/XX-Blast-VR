extends KinematicBody

# gunsFiringDelay to prevent gun firing too often
var gunsFiringDelay = Globals.PLAYER_GUNS_DEFAULT_DELAY

# same for missiles
var missileFiringDelay = Globals.MISSILE_DEFAULT_DELAY

# toggle to whether guns are auto firing.  primarily used to match with VR controller trigger.
var autofire = false

# velocity
var velo = Vector3()

# array of gun nodes on ship
onready var guns = [$Gun0,$Gun1]

# get the left hand controller node so we can communicate with it
onready var controllerNode = get_node_or_null("/root/Main/FPController/LeftHandController")

# store the initial position of the ship so we can reset when player dies
onready var resetPosition = transform

onready var alive = false

var controllerInput = Vector2()

# set up a signal for if the player is killed.
signal player_killed

func _physics_process(_delta):
	if Globals.gameRunning and $Ship.visible:
		# inputVector is amount joystick has been moved to determine direction
		var inputVector = Vector3()
		
		if $"../../FPController".inVR:
			# if FPController exists we are in VR and will use controllers for input
			inputVector = controllerInput
		else:
			# not in VR mode so we will use simple keys.
			
			if Input.is_action_pressed("ui_select"):
				_fire_guns()
			if Input.is_action_pressed("game_missile"):
				_fire_missile_at_nearest()
				
			inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			inputVector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
			inputVector = inputVector.normalized()
		
		# calculate velocity based on input, max speed and acceleration
		velo.x = move_toward(velo.x, inputVector.x * Globals.PLAYER_MAXSPEED, Globals.PLAYER_ACCELERATION)
		velo.y = move_toward(velo.y, inputVector.y * Globals.PLAYER_MAXSPEED, Globals.PLAYER_ACCELERATION)
	
		# rotate the ship to bank when moving
		rotation_degrees.z = velo.x * -.8
		rotation_degrees.x = velo.y / 2
		rotation_degrees.y = -velo.x / 2
	
		if velo.x == 0 and velo.y == 0:
			# no movement currently so will play the Idling animation of player.
			$AnimationPlayer.play("Idle")
		else:
			# player has velocity so won't animate
			$AnimationPlayer.stop()
		
		if gunsFiringDelay >0:
			gunsFiringDelay -= 1
		
		if missileFiringDelay >0:
			missileFiringDelay -= 1

		# after all the processing, we can now move the player to new position
		var _result = move_and_slide(velo)
		
		transform.origin.x = clamp(transform.origin.x, Globals.PLAYER_MIN_X, Globals.PLAYER_MAX_X)
		transform.origin.y = clamp(transform.origin.y, Globals.PLAYER_MIN_Y, Globals.PLAYER_MAX_Y)
		
		# if we find that autofire is one, fire the guns.
		if autofire:
			_fire_guns()

func _fire_guns():
	# no point firing if the game isn't running or ship isn't in play
	if Globals.gameRunning and $Ship.visible:
		# check to see if we're allowed to fire yet
		if gunsFiringDelay <= 0:
			# cycle through the gun spawn points and add a bullet to each node
			for i in guns:
				var bullet = Globals.PlayerBullet.instance()
				Globals.Main.add_child(bullet)
				bullet.global_transform.origin = i.global_transform.origin
				bullet.rotation = Globals.player.rotation
				
			# reset to delay for the default period
			gunsFiringDelay = Globals.PLAYER_GUNS_DEFAULT_DELAY

func _fire_missile(targetNode):
	# no point firing if the game isn't running or ship isn't in play
	if Globals.gameRunning and $Ship.visible:
		# check to see if we're allowed to fire yet
		if missileFiringDelay <= 0:
			# yes we can fire, add a missile to the missile spawn node
			var missile = Globals.PlayerMissile.instance()
			Globals.Main.add_child(missile)
			# set the target to targetNode so the missile will attack that node
			if targetNode:
				missile.targetNode = targetNode
			missile.global_transform.origin = $MissileLauncher.global_transform.origin
			
			
			# reset the delay for the default period
			missileFiringDelay = Globals.MISSILE_DEFAULT_DELAY

func _fire_missile_at_nearest():
	# get an array of all current enemies in play by checking their group assignment
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	# set default nearest node as the actual spawner node.  This way if no enemy is found, we
	# have a default target.
	var nearestEnemyNode = null
	var nearestDistance = 10000
	
	# check if enemies were found
	if enemies:
		# iterate through all current enemies
		for enemy in enemies:
			# get the distance value between player and this enemy
			var distance_to_enemy = global_transform.origin.distance_to(enemy.global_transform.origin)

			# if the distance is less than the current nearest enemy make this node the new nearest.
			if distance_to_enemy <= nearestDistance:
				
				nearestEnemyNode = enemy
				
	# fire a missile at whoever is now the nearest enemy, even if its the spawn node.
	_fire_missile(nearestEnemyNode)

func _on_CollisionArea_body_entered(body):
	emit_signal("player_killed", self)

	# destroy whatever collided with player
	body.queue_free()
