extends KinematicBody

# define a random speed for each unit
var speed = rand_range(15,30)

onready var main = get_tree().current_scene
onready var player = $"../GameWorld/Player"


func _ready():
	#set a random timer for the gun to fire
	$FiringTimer.wait_time = rand_range(1,5)
	$FiringTimer.start()
	$AudioStreamPlayer3D.play()
		
func _physics_process(_delta):
	var _result = move_and_slide(global_transform.basis.z * speed)
	if transform.origin.z > 200:
		queue_free()
		
func _spawn_bullet():
	var bullet = Globals.EnemyBullet.instance()
	main.add_child(bullet)
	bullet.global_transform.origin = $Gun.global_transform.origin
	bullet.look_at(player.global_transform.origin, Vector3.UP)
	# make sure bullet speed is always proportionate to enemy speed
	bullet.speed = speed + 4
	
func _on_FiringTimer_timeout():
	if transform.origin.z > -300 and transform.origin.z < 0:
		_spawn_bullet()
		# set a new random time for the next bullet
		$FiringTimer.wait_time = rand_range(1,5)
		$FiringTimer.start()

func _on_Area_body_entered(body):
	if body.is_in_group("PlayerBullet"):
		die()

func die():
	var explosion = Globals.EnemyExplosion.instance()
	main.add_child(explosion)
	explosion.transform.origin = transform.origin
	queue_free()
