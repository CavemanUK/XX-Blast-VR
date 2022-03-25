extends Spatial

func _ready():
	# loop through the 5 particle explosions
	for i in 5:
		# get a node
		var ex = get_node("CPUParticles"+str(i))
		# trigger the particle effect
		ex.emitting = true
		# check if game is playing.  If not, no sound
		if Globals.gameRunning == true:
			# play explosion sound
			ex.get_node("ExplosionSound").play()
		# pause for .2 seconds before triggering next explosion	
		yield(get_tree().create_timer(.2), "timeout")
	
	# loop complete, wait a few seconds, then destroy node
	yield(get_tree().create_timer(3), "timeout")
	queue_free()
