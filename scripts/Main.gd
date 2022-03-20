extends Spatial
	
func _ready():
	$Player.connect("player_killed", self, "handlePlayerDeath")

func _process(_delta):
	if Globals.gameRunning == false:
		if Input.is_action_just_released("ui_select"):
			startGame()

func startGame():
	$Player.resetShip()
	Globals.gameRunning = true
	$"../FPController/AudioStreamPlayer3D".play()
	$"../StartScreen".Kill()

func handlePlayerDeath():
	yield(get_tree().create_timer(5.0), "timeout")
	$Player.resetShip()
