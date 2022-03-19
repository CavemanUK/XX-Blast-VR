extends Node

const MAX_BULLETS = 30

var PlayerBullets = {}

onready var PlayerBullet = preload("res://scenes/PlayerBullet.tscn")
onready var main = get_tree().current_scene

func _ready():
	for i in MAX_BULLETS:
		PlayerBullets[i] = PlayerBullet.instance()
		initialiseBullet(PlayerBullets[i])

func getNextBullet():
	for i in MAX_BULLETS:
		if PlayerBullets[i].active == false:
			return PlayerBullets[i]
	return false

func initialiseBullet(bullet):
	main.add_child(bullet)
	bullet.transform.origin = Vector3(5000,5000,5000)
