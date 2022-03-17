extends ARVRController

signal activated
signal deactivated

var trigger_triggered := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_is_active():
		if !visible:
			visible = true
			print("Activated " + name)
			emit_signal("activated")
	elif visible:
		visible = false
		print("Deactivated " + name)
		emit_signal("deactivated")
	

func updateShipTitle(myString):
	#var textNode = $"../player/Spatial/Viewport/Label"
	#textNode.text = myString
	pass
	
func _input(event):
	var player = $"../player"
	var joystick_vector = Vector2(get_joystick_axis(0), get_joystick_axis(1))
	joystick_vector = joystick_vector.normalized().round()
	var trigger_throttle = get_joystick_axis(2)
	player.controllerInput = joystick_vector
	
	if trigger_throttle == 1:
		if trigger_triggered != true:
			trigger_triggered = true
			player._fire_bullet()
	
	if trigger_throttle < 1:
		if trigger_triggered == true:
			trigger_triggered = false
