extends ARVRController

signal activated
signal deactivated

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

func rumblePulse(time = 1):
	rumble = .5
	yield(get_tree().create_timer(time), "timeout")
	rumble = 0
