extends Spatial

func _process(_delta):
	if Globals.gameRunning == false:
		if Input.is_action_just_released("ui_select"):
			startGame()

func startGame():
	
	if not Globals.gameRunning:
		spawnPlayer()
		Globals.gameRunning = true
		$"../FPController/AudioStreamPlayer3D".play()
		$"../StartScreen".Kill()

func handlePlayerDeath(dyingPlayer):
	# instance a player explosion sequence
	var explosion = Globals.PlayerExplosion.instance()
	
	# add the explosion instance to the game scene
	Globals.GameWorld.add_child(explosion)
	
	# set the location to the last location of the player
	explosion.global_transform.origin = dyingPlayer.global_transform.origin
	
	# destroy the old dying player node
	dyingPlayer.queue_free()
	
	# wait 5 seconds
	yield(get_tree().create_timer(5.0), "timeout")
	
	# spawn a new player
	spawnPlayer()

func spawnPlayer():
	Globals.player = Globals.Player.instance()
	Globals.GameWorld.add_child(Globals.player)
	Globals.player.connect("player_killed", self, "handlePlayerDeath")
