extends Node

var CacheSpawnVector = Vector3(0,-20,-100)

func _ready():
	
	var AsteroidExplosion = Globals.AsteroidExplosion.instance()
	AsteroidExplosion.transform.origin = CacheSpawnVector
	add_child(AsteroidExplosion)
	
	var Asteroid = Globals.Asteroid.instance()
	Asteroid.transform.origin = CacheSpawnVector
	add_child(Asteroid)
	
	var Enemy = Globals.Enemy.instance()
	Enemy.transform.origin = CacheSpawnVector
	add_child(Enemy)
	
	var EnemyBullet = Globals.EnemyBullet.instance()
	EnemyBullet.transform.origin = CacheSpawnVector
	add_child(EnemyBullet)
	
	var EnemyExplosion = Globals.EnemyExplosion.instance()
	EnemyExplosion.transform.origin = CacheSpawnVector
	add_child(EnemyExplosion)
	
	var PlayerBullet = Globals.PlayerBullet.instance()
	PlayerBullet.transform.origin = CacheSpawnVector
	add_child(PlayerBullet)
	
	var PlayerMissile = Globals.PlayerMissile.instance()
	PlayerMissile.transform.origin = CacheSpawnVector
	add_child(PlayerMissile)
	
	var PlayerMissileSmoke = Globals.PlayerMissileSmoke.instance()
	PlayerMissileSmoke.transform.origin = CacheSpawnVector
	add_child(PlayerMissileSmoke)
	
