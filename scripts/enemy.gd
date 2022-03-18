extends KinematicBody

# define a random speed for each unit
var speed = rand_range(15,30)

onready var main = get_tree().current_scene
onready var player = $"../Player"
var Bullet = preload("res://scenes/EnemyBullet.tscn")

func _ready():
	#set a random timer for the gun to fire
	$FiringTimer.wait_time = rand_range(1,5)

func _physics_process(_delta):
	move_and_slide(global_transform.basis.z * speed)
	if transform.origin.z > 200:
		queue_free()
		
func _spawn_bullet():
	var bullet = Bullet.instance()
	#bullet.look_at(player.global_transform.origin, global_transform.basis.y)
	
	main.add_child(bullet)
	bullet.global_transform.origin = $Gun.global_transform.origin
	
	# make sure bullet speed is always proportionate to enemy speed
	bullet.speed = speed + 30
	
func _on_FiringTimer_timeout():
	if transform.origin.z > -300 and transform.origin.z < 0:
		_spawn_bullet()
		# set a new random time for the next bullet
		$FiringTimer.wait_time = rand_range(1,5)
		$FiringTimer.start()
