extends Node

const MAX_BULLETS = 20

var EnemyBullets = {}

onready var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")
onready var main = get_tree().current_scene

func getNextBullet():
	for i in MAX_BULLETS:
		if EnemyBullets[i].active == false:
			return EnemyBullets[i]
	return false

func _ready():
	for i in MAX_BULLETS:
		EnemyBullets[i] = EnemyBullet.instance()
		initialiseBullet(EnemyBullets[i])

func initialiseBullet(bullet):
	main.add_child(bullet)
	bullet.transform.origin = Vector3(5000,5000,5000)
