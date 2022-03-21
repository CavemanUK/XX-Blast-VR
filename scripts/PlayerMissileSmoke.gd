extends Spatial

# particle is a one-shot then this node is killed

func _ready():
	$CPUParticles.one_shot = true

func _process(_delta):
	if $CPUParticles.emitting == false:
		queue_free()
