extends KinematicBody

# used so we can set the movement of the explosion to match the enemy
# later we might need to add a vector
var speed = 0
	
func _ready():
	# start the particle effect
	# its configured as a one-shot so will only show once
	$CPUParticles.emitting = true
	if Globals.gameRunning  == true:
		# play explosion sound
		$ExplosionSound.play()

func _process(_delta):
	# check to see if the effect has finised and if so, kill this node
	if $CPUParticles.emitting != true:
		queue_free()

