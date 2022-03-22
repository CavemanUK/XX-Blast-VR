extends KinematicBody

var smokeCoolDown = 0

var speed = 60

enum {released, launched}

onready var missileState = released

onready var targetNode = $"/root/Main/GameWorld/EnemySpawner"
onready var main = get_tree().current_scene



# generate smoke from the exhaust of the missile for the life of it
func _process(_delta):
	if targetNode:
		look_at(targetNode.global_transform.origin, Vector3.UP)
	
	smokeCoolDown += 1
	if smokeCoolDown > 5:
		spawnSmoke()
		smokeCoolDown = 0
	
func spawnSmoke():
	if missileState == launched:
		var smoke = Globals.PlayerMissileSmoke.instance()
		main.add_child(smoke)
		
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

func _on_Area_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Asteroid"):
		queue_free()


func _on_ReleaseTimer_timeout():
	missileState = launched
