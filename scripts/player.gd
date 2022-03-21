extends KinematicBody

# set maximum move speed for ship
const MAXSPEED = 20

# set acceleration
const ACCELERATION = 1

# set default delay for firing Guns
const GUNS_DEFAULT_DELAY = 12

# set default delay for missile
const MISSILE_DEFAULT_DELAY = 50

# gunsFiringDelay to prevent gun firing too often
var gunsFiringDelay = GUNS_DEFAULT_DELAY

# same for missiles
var missileFiringDelay = MISSILE_DEFAULT_DELAY

# toggle to whether guns are auto firing.  primarily used to match with VR controller trigger.
var autofire = false

# velocity
var velo = Vector3()

# array of gun nodes on ship
onready var guns = [$Gun0,$Gun1]

# store the current scene node in a variable for reference
onready var main = get_tree().current_scene

# get the left hand controller node so we can communicate with it
onready var controllerNode = get_node("/root/Main/FPController/LeftHandController")

# store the initial position of the ship so we can reset when player dies
onready var resetPosition = transform

var controllerInput = Vector2()

# set up a signal for if the player is killed.
signal player_killed

func _ready():
	controllerNode.connect("controller_button_pressed", self, "fire_missile_at_nearest")

func _physics_process(_delta):
	if Globals.gameRunning:
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
		velo.x = move_toward(velo.x, inputVector.x * MAXSPEED, ACCELERATION)
		velo.y = move_toward(velo.y, inputVector.y * MAXSPEED, ACCELERATION)
	
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
				main.add_child(bullet)
				bullet.global_transform.origin = i.global_transform.origin
			
			# reset to delay for the default period
			gunsFiringDelay = GUNS_DEFAULT_DELAY

func _fire_missile(targetNode):
	# no point firing if the game isn't running or ship isn't in play
	if Globals.gameRunning and $Ship.visible:
		# check to see if we're allowed to fire yet
		if missileFiringDelay <= 0:
			# yes we can fire, add a missile to the missile spawn node
			var missile = Globals.PlayerMissile.instance()
			main.add_child(missile)
			# set the target to targetNode so the missile will attack that node
			missile.targetNode = targetNode
			missile.global_transform.origin = $MissileLauncher.global_transform.origin
			
			# reset the delay for the default period
			missileFiringDelay = MISSILE_DEFAULT_DELAY

func _fire_missile_at_nearest():
	
	# get an array of all current enemies in play by checking their group assignment
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	# set default nearest node as the actual spawner node.  This way if no enemy is found, we
	# have a default target.
	var nearestEnemyNode = $"../EnemySpawner"
	var nearestDistance = 10000
	
	# check if enemies were found
	if enemies:
		# iterate through all current enemies
		for enemy in enemies:
			# get the distance value between player and this enemy
			var distance_to_enemy = translation.distance_to(enemy.global_transform.origin)
			# if the distance is less than the current nearest enemy make this node the new nearest.
			if distance_to_enemy <= nearestDistance:
				nearestEnemyNode = enemy
				
	# fire a missile at whoever is now the nearest enemy, even if its the spawn node.
	_fire_missile(nearestEnemyNode)

func _on_CollisionArea_body_entered(body):
	# only check out collisions if game is running and ship is on screen
	if Globals.gameRunning and $Ship.visible:
		# any collision with anything inside the collision masks means the player would get killed
		# so we emit a signal for the main game loop to be aware and decide what to do next.
		emit_signal("player_killed")
		
		# call playerDeath function to handle the death animation etc
		playerDeath()

func playerDeath():
	
	# first part of death is to hide the ship mesh.  This is just the mesh and not the rest
	# of the player as we need to keep the rest visible to show the explosion.
	
	hideShip()
	
	# trigger the explosion particle animations one at a time with a 10ms delay to make the 
	# explosion look big and impressive.
	
	for i in 5:
		var explosion = get_node("Explosion/CPUParticles"+str(i))
		var explosionSound = get_node("Explosion/CPUParticles"+str(i)+"/ExplosionSound")
		explosion.emitting = true
		
		# play the explosion sound from the node.
		explosionSound.play()
		
		# wait 10ms before continuing the for loop
		yield(get_tree().create_timer(.1), "timeout")
	
func hideShip():
	# hide just the ship mesh
	$Ship.visible = false

func resetShip():
	# puts the players position and rotation back to default
	transform = resetPosition
	# make sure the ship mesh is visible
	$Ship.visible = true
	# make sure the rest of the player node is visible
	visible = true
