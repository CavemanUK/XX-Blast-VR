extends Spatial

# Global Variables

export var MAX_ENEMIES = 50
export var ENEMY_MIN_SPEED = 15.00
export var ENEMY_MAX_SPEED = 30.00
export var ENEMY_DEFAULT_BULLET_SPEED = 4
export var ENEMY_DEFAULT_BULLET_DISTANCE = 300
export var ENEMY_SPAWN_RATE = 0.50
export var ENEMY_MIN_X_ORIGIN = -50.00
export var ENEMY_MAX_X_ORIGIN = 50.00
export var ENEMY_MIN_Y_ORIGIN = -50.00
export var ENEMY_MAX_Y_ORIGIN = 50.00
export var ENEMY_MIN_Z_ORIGIN = -200.00
export var ENEMY_MAX_Z_ORIGIN = -50.00

export var ASTEROID_SPAWN_RATE = 1.00
export var ASTEROID_MIN_X_ORIGIN = -100.00
export var ASTEROID_MAX_X_ORIGIN = 100.00
export var ASTEROID_MIN_Y_ORIGIN = -100.00
export var ASTEROID_MAX_Y_ORIGIN = 100.00
export var ASTEROID_MIN_Z_ORIGIN = -500.00
export var ASTEROID_MAX_Z_ORIGIN = -50.00
export var ASTEROID_MIN_SPEED = 10.00
export var ASTEROID_MAX_SPEED = 90.00
export var ASTEROID_MIN_SIZE = .50
export var ASTEROID_MAX_SIZE = 10.00
export var MAX_ASTEROIDS = 200

export var PLAYER_MIN_X = -150
export var PLAYER_MAX_X = 150
export var PLAYER_MIN_Y = -150
export var PLAYER_MAX_Y = 150
export var PLAYER_MAXSPEED = 20
export var PLAYER_ACCELERATION = 1
export var PLAYER_GUNS_DEFAULT_DELAY = 12
export var MISSILE_DEFAULT_DELAY = 50

# Preload all the game assets

onready var AsteroidExplosion = preload("res://scenes/AsteroidExplosion.tscn")
onready var Asteroid = preload("res://scenes/Asteroid.tscn")

onready var Enemy = preload("res://scenes/Enemy.tscn")
onready var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")
onready var EnemyExplosion = preload("res://scenes/EnemyExplosion.tscn")

onready var Player = preload("res://scenes/Player.tscn")
onready var PlayerBullet = preload("res://scenes/PlayerBullet.tscn")
onready var PlayerMissile = preload("res://scenes/PlayerMissile.tscn")
onready var PlayerMissileSmoke = preload("res://scenes/PlayerMissileSmoke.tscn")
onready var PlayerExplosion= preload("res://scenes/PlayerExplosion.tscn")

# used to hand specific instance of player
onready var player = null

onready var Main = get_tree().current_scene
onready var GameWorld = get_tree().current_scene.get_node("GameWorld")

enum {GameInitialising, StartScreen, GamePlaying}

# Used to keep track of if the game is actually running.  When false, enemies arent generated etc 
export var gameStatus = GameInitialising
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
