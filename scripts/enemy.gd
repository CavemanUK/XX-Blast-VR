extends KinematicBody

# define a random speed for each unit
var speed = rand_range(15,30)
var active = false

onready var main = get_tree().current_scene
onready var player = $"../GameWorld/Player"

func _ready():
	#set a random timer for the gun to fire
	$FiringTimer.wait_time = rand_range(1,5)
	

func _physics_process(_delta):
	if active:
		var _result = move_and_slide(global_transform.basis.z * speed)
		if transform.origin.z > 200:
			deactivate()
		
func _spawn_bullet():
	if active:
		var bullet = EnemyLaserPool.getNextBullet()
		if bullet:
			bullet.activate()
			bullet.global_transform.origin = $Gun.global_transform.origin
			# make sure bullet speed is always proportionate to enemy speed
			bullet.speed = speed + 30
	
func _on_FiringTimer_timeout():
	if active:
		if transform.origin.z > -300 and transform.origin.z < 0:
			_spawn_bullet()
			# set a new random time for the next bullet
			$FiringTimer.wait_time = rand_range(1,5)
			$FiringTimer.start()

func deactivate():
	visible = false
	global_transform.origin = Vector3(5000,5000,5000)
	active = false
	$FiringTimer.stop()
	if self.is_in_group("ACTIVE_ENEMIES"):
		remove_from_group("ACTIVE_ENEMIES")
	$AudioStreamPlayer3D.stop()

func activate():
	active = true
	visible = true
	speed = rand_range(15,30)
	$FiringTimer.start()
	add_to_group("ACTIVE_ENEMIES")
	$AudioStreamPlayer3D.play()
	
