extends Spatial

# const

# onready preload
onready var Player = preload("res://scenes/Player.tscn")
onready var PlayerExplosion = preload("res://scenes/PlayerExplosion.tscn")
# onready var
onready var GameWorld = $"/root/Main/GameWorld"


func _ready():
	Debug._print("Game initialised", self)
	pass
	
func _process(_delta):
	if Globals.gameRunning == false:
		if Input.is_action_just_released("ui_select"):
			startGame()

func _input(event):
	
	# all this to check if the game is running and if not, check if we should start one!
	
	if not Globals.gameRunning:
		var fpcontroller = $"/root/Main/FPController"
		if fpcontroller.inVR:
			var leftcontroller = $"/root/Main/FPController/LeftHandController"
			var trigger_throttle = leftcontroller.get_joystick_axis(2)
			if trigger_throttle >= 1:
				$"/root/Main/GameWorld".startGame()
		else:
			if event.is_action_pressed("ui_accept"):
				$"/root/Main/GameWorld".startGame()
				
func startGame():
	#Debug._print("New Game Started")
	if not Globals.gameRunning:
		Globals.gameRunning = true
		spawnPlayer()
		
		$"../FPController/AudioStreamPlayer3D".play()
		$"../StartScreen".Kill()

func handlePlayerDeath(dyingPlayer):
	# instance a player explosion sequence
	var explosion = PlayerExplosion.instance()
	
	# add the explosion instance to the game scene
	GameWorld.add_child(explosion)
	
	# set the location to the last location of the player
	explosion.global_transform.origin = dyingPlayer.global_transform.origin
	
	# destroy the old dying player node
	dyingPlayer.queue_free()
	
	# wait 5 seconds
	yield(get_tree().create_timer(5.0), "timeout")
	
	# spawn a new player
	spawnPlayer()

func spawnPlayer():
	var player = Player.instance()
	GameWorld.add_child(player)
	player.connect("player_killed", self, "handlePlayerDeath")
