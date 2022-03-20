extends Spatial
	
func _process(_delta):
	if Globals.gameRunning == false:
		if Input.is_action_just_released("ui_select"):
			startGame()

func startGame():
	$Player.reset()
	Globals.gameRunning = true
	$AudioStreamPlayer3D.play()
	$"../StartScreen".Kill()
