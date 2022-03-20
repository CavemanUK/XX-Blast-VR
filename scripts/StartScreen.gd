extends Spatial

func _ready():
	$AudioStreamPlayer3D.play()

func Kill():
	queue_free()
