extends KinematicBody

onready var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")

onready var GameWorld = $"/root/Main/GameWorld"

const TARGETTING_TIME = 180
const DEFAULT_BULLET_SPEED = 15

# default speed of the unit
var speed = 15

# flag to check if a missile is locked on
var targetted = false
var targettedTime = 0

signal enemy_unit_killed

func _ready():
	# check if game is initialising, if so, don't bother continuing
	if Globals.gameStatus == Globals.GameInitialising:
		return
		
	# set a random timer for the gun to fire
	$FiringTimer.wait_time = rand_range(1,5)
	$FiringTimer.start()
	$AudioStreamPlayer3D.play()

func _physics_process(_delta):
	# check if game is initialising, if so, don't bother continuing
	if not Globals.gameRunning:
		return
		
	# move the unit
	var _result = move_and_slide(global_transform.basis.z * speed)
	# kill unit if its 200 behind centre of universe
	# change this in future to be distance from player
	
	if global_transform.origin.z > 200:
		queue_free()
	
	# has enemy been flagged as targetted by a missile
	if targetted:
		targettedTime += 1
		# check if the targetting has gone beyong maximum targetting time
		if targettedTime > TARGETTING_TIME:
			# turn off the targetting flag
			targetted = false
			targettedTime = 0

func _spawn_bullet(player):
	# create a new bullet instance
	var bullet = EnemyBullet.instance()
	GameWorld.add_child(bullet)
	bullet.global_transform.origin = $Gun.global_transform.origin
	bullet.look_at(player.global_transform.origin, Vector3.UP)
	
	# make sure bullet speed is always proportionate to enemy speed
	bullet.speed = speed + DEFAULT_BULLET_SPEED
	
func _on_FiringTimer_timeout():
	
	# check if game is initialising, if so, don't bother continuing
	if not Globals.gameRunning:
		return
		
	var player = $"/root/Main/GameWorld/Player"
	if not player.is_inside_tree():
		return
		
	var distance_to_player = translation.distance_to(player.global_transform.origin)
	if distance_to_player > 90 and distance_to_player < 300:
		
		# check that enemy is in front of player and not flying away behind
		if transform.origin.z < -100:
			_spawn_bullet(player)

	# set a new random time for the next bullet
	$FiringTimer.wait_time = rand_range(1,5)
	$FiringTimer.start()

func _on_Area_body_entered(body):
	if body.is_in_group("PlayerBullet"):
		body.queue_free()
		# send signal enemy killed and reference self so they know who sent signal
		emit_signal("enemy_unit_killed", self)


