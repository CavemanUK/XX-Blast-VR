extends Spatial

func _ready():
	$CPUParticles.emitting = true

func _process(_delta):
	if $CPUParticles.emitting != true:
		queue_free()
