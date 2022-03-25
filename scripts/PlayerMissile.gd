extends KinematicBody

var smokeCoolDown = 0

var speed = 60

enum {released, launched}

onready var Smoke = preload("res://scenes/PlayerMissileSmoke.tscn")

onready var missileState = released

# default target is the enemy spawner itself
onready var targetNode = $"/root/Main/GameWorld/EnemySpawner"
onready var GameWorld = $"/root/Main/GameWorld"


# generate smoke from the exhaust of the missile for the life of it
func _process(_delta):
	if str(targetNode) != "[Deleted Object]":
		look_at(targetNode.global_transform.origin, Vector3.UP)
	
	smokeCoolDown += 1
	if smokeCoolDown > 5:
		spawnSmoke()
		smokeCoolDown = 0
	
func spawnSmoke():
	if missileState == launched:
		var smoke = Smoke.instance()
		GameWorld.add_child(smoke)
		smoke.global_transform.origin = $Exhaust.global_transform.origin
		
func _physics_process(_delta):
	if missileState == launched:
		var _result = move_and_slide(-global_transform.basis.z * speed)
	else:
		var _result = move_and_slide(-global_transform.basis.y * 24
		)

# kill the missile after a certain amount of seconds
func _on_LifeTimer_timeout():
	queue_free()

func _on_ReleaseTimer_timeout():
	missileState = launched
