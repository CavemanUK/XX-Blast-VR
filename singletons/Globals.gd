extends Node

# Preload all the game assets

onready var AsteroidExplosion = preload("res://scenes/AsteroidExplosion.tscn")
onready var Asteroid = preload("res://scenes/Asteroid.tscn")

onready var Enemy = preload("res://scenes/Enemy.tscn")
onready var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")
onready var EnemyExplosion = preload("res://scenes/EnemyExplosion.tscn")

onready var PlayerBullet = preload("res://scenes/PlayerBullet.tscn")
onready var PlayerMissile = preload("res://scenes/PlayerMissile.tscn")
onready var PlayerMissileSmoke = preload("res://scenes/PlayerMissileSmoke.tscn")

onready var Player = $"/root/Main/GameWorld/Player"

# Used to keep track of if the game is actually running.  When false, enemies arent generated etc 

export var gameRunning = false

func lock_into_rotation(angle):
	var result = fmod(angle, 360)
	# check if negative number
	#if result < 0: result += 360
	return result

func rotate_by_degrees(vector,x,y,z):
	print("Old Vector: " + str(vector))
	var newVect = Vector3()
	
	var angle_x = vector.x + x
	var angle_y = vector.y + y
	var angle_z = vector.z + z
	
	angle_x = lock_into_rotation(angle_x)
	angle_y = lock_into_rotation(angle_y)
	angle_z = lock_into_rotation(angle_z)
	
	
	newVect = Vector3(angle_x, angle_y, angle_z)
	print("New Vector: " + str(newVect))
	return newVect
