extends Node

# Preload all the game assets

onready var EnemyExplosion = preload("res://scenes/ExplosionParticles.tscn")
onready var PlayerBullet = preload("res://scenes/PlayerBullet.tscn")
onready var Asteroid = preload("res://scenes/Asteroid.tscn")
onready var Enemy = preload("res://scenes/Enemy.tscn")
onready var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")

# Used to keep track of if the game is actually running.  When false, enemies arent generated etc 

export var gameRunning = false
