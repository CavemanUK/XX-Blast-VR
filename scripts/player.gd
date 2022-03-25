extends KinematicBody

# const
const MAXSPEED = 20
const ACCELERATION = 1
const GUNS_DEFAULT_DELAY = 12
const MISSILE_DEFAULT_DELAY = 50
const MIN_X = -150
const MAX_X = 150
const MIN_Y = -150
const MAX_Y = 150

# onready preload
onready var PlayerBullet = preload("res://scenes/PlayerBullet.tscn")
onready var PlayerMissile = preload("res://scenes/PlayerMissile.tscn")

# onready nodes
onready var GameWorld = $"/root/Main/GameWorld"

# onready var
onready var gunsFiringDelay = GUNS_DEFAULT_DELAY
onready var missileFiringDelay = MISSILE_DEFAULT_DELAY
onready var guns = [$Gun0,$Gun1]
onready var resetPosition = transform

var alive = true
var missileTriggered = false
var autofire = false
var velocity = Vector3()

# signals
signal player_killed

func _physics_process(_delta):
	if Globals.gameRunning and alive:
		# inputVector is amount joystick has been moved to determine direction
		var inputVector = Vector3()
		
		if $"/root/Main/FPController".inVR:
			# if FPController exists we are in VR and will use controllers for input
			var leftController = $"/root/Main/FPController/LeftHandController"
			var rightController = $"/root/Main/FPController/RightHandController"
			
			var leftJoystickVector = Vector2(leftController.get_joystick_axis(0), leftController.get_joystick_axis(1))
			var triggerValue = leftController.get_joystick_axis(2)
			
			
			inputVector = leftJoystickVector.normalized().round()
			
			if triggerValue >=1:
				autofire = true
			else:
				autofire = false

			if rightController.is_button_pressed(1):
				if not missileTriggered:
					_fire_missile_at_nearest()
				missileTriggered = true
			else:
				missileTriggered = false
				

		else:
			
			# not in VR mode so we will use simple keys.
			
			if Input.is_action_pressed("player_fire"):
				_fire_guns()
			if Input.is_action_pressed("player_missile"):
				_fire_missile_at_nearest()
				
			inputVector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
			inputVector.y = Input.get_action_strength("player_up") - Input.get_action_strength("player_down")
			inputVector = inputVector.normalized()
		
		# calculate velocity based on input, max speed and acceleration
		velocity.x = move_toward(velocity.x, inputVector.x * MAXSPEED, ACCELERATION)
		velocity.y = move_toward(velocity.y, inputVector.y * MAXSPEED, ACCELERATION)
	
		# rotate the ship to bank when moving
		rotation_degrees.z = velocity.x * -.8
		rotation_degrees.x = velocity.y / 2
		rotation_degrees.y = -velocity.x / 2
	
		if velocity.x == 0 and velocity.y == 0:
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
		var _result = move_and_slide(velocity)
		
		transform.origin.x = clamp(transform.origin.x, MIN_X, MAX_X)
		transform.origin.y = clamp(transform.origin.y, MIN_Y, MAX_Y)
		
		# if we find that autofire is one, fire the guns.
		if autofire:
			_fire_guns()

func _fire_guns():
	# no point firing if the game isn't running or ship isn't in play
	if Globals.gameRunning and alive:
		# check to see if we're allowed to fire yet
		if gunsFiringDelay <= 0:
			# cycle through the gun spawn points and add a bullet to each node
			for i in guns:
				var bullet = PlayerBullet.instance()
				GameWorld.add_child(bullet)
				bullet.global_transform.origin = i.global_transform.origin
				bullet.rotation = rotation
				
			# reset to delay for the default period
			gunsFiringDelay = GUNS_DEFAULT_DELAY

func _fire_missile(targetNode):
	# no point firing if the game isn't running or ship isn't in play
	if Globals.gameRunning and alive:
		# check to see if we're allowed to fire yet
		if missileFiringDelay <= 0:
			# yes we can fire, add a missile to the missile spawn node
			var missile = PlayerMissile.instance()
			GameWorld.add_child(missile)
			# set the target to targetNode so the missile will attack that node
			if targetNode:
				missile.targetNode = targetNode
			missile.global_transform.origin = $MissileLauncher.global_transform.origin
			
			# reset the delay for the default period
			missileFiringDelay = MISSILE_DEFAULT_DELAY

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
			var distance_to_enemy = self.global_transform.origin.distance_to(enemy.global_transform.origin)

			# if the distance is less than the current nearest enemy make this node the new nearest.
			if distance_to_enemy < nearestDistance:
				# make sure enemy is over 50 units away and is in front of us
				if distance_to_enemy > 100 and enemy.global_transform.origin.x < -100:
					if enemy.targetted == false:
						nearestEnemyNode = enemy
						nearestDistance = distance_to_enemy
					
	# fire a missile at whoever is now the nearest enemy, even if its the spawn node.
	if nearestEnemyNode != null:
		nearestEnemyNode.targetted = true
	
	_fire_missile(nearestEnemyNode)

func _on_CollisionArea_body_entered(body):
	emit_signal("player_killed", self)
	alive = false
	# destroy whatever collided with player
	body.queue_free()
