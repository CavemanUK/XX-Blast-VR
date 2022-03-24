extends Node

var CacheSpawnVector = Vector3(0,-20,-100)

onready var main = get_tree().current_scene

func _ready():
	
	randomize()

	var AsteroidExplosion = Globals.AsteroidExplosion.instance()
	AsteroidExplosion.transform.origin = CacheSpawnVector
	main.add_child(AsteroidExplosion)
	AsteroidExplosion.queue_free()

	var Asteroid = Globals.Asteroid.instance()
	Asteroid.transform.origin = CacheSpawnVector
	main.add_child(Asteroid)
	Asteroid.queue_free()

	var Enemy = Globals.Enemy.instance()
	Enemy.transform.origin = CacheSpawnVector
	main.add_child(Enemy)
	Enemy.queue_free()

	var EnemyBullet = Globals.EnemyBullet.instance()
	EnemyBullet.transform.origin = CacheSpawnVector
	main.add_child(EnemyBullet)
	EnemyBullet.queue_free()

	var EnemyExplosion = Globals.EnemyExplosion.instance()
	EnemyExplosion.transform.origin = CacheSpawnVector
	main.add_child(EnemyExplosion)
	EnemyExplosion.queue_free()
#
	var PlayerBullet = Globals.PlayerBullet.instance()
	PlayerBullet.transform.origin = CacheSpawnVector
	main.add_child(PlayerBullet)
	#PlayerBullet.queue_free()
#
	var PlayerMissile = Globals.PlayerMissile.instance()
	PlayerMissile.transform.origin = CacheSpawnVector
	main.add_child(PlayerMissile)
	PlayerMissile.queue_free()

	var PlayerMissileSmoke = Globals.PlayerMissileSmoke.instance()
	PlayerMissileSmoke.transform.origin = CacheSpawnVector
	main.add_child(PlayerMissileSmoke)
	PlayerMissileSmoke.queue_free()
	
	var PlayerExplosion = Globals.PlayerExplosion.instance()
	PlayerExplosion.transform.origin = CacheSpawnVector
	main.add_child(PlayerExplosion)

	Globals.gameStatus = Globals.StartScreen
