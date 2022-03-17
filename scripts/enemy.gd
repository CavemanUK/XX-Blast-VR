extends KinematicBody

var spd = rand_range(20,30)

onready var main = get_tree().current_scene
onready var player = $"../FPController/player"
var Bullet = preload("res://scenes/EnemyBullet.tscn")

func _physics_process(delta):
	move_and_collide(Vector3(0,0,spd * delta))
	if transform.origin.z > 200:
		queue_free()
		

func _spawn_bullet():
	var bullet = Bullet.instance()
	bullet.look_at(player.global_transform.origin, transform.basis.y)
	
	main.add_child(bullet)
	bullet.global_transform.origin = $Gun.global_transform.origin
	
func _on_FiringTimer_timeout():
	if transform.origin.z > -300 and transform.origin.z < 0:
		_spawn_bullet()
		pass
