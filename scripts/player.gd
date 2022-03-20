extends KinematicBody

const MAXSPEED = 20
const ACCELERATION = 1

var gunCooldown = 0

var inputVector = Vector3()
var velo = Vector3()

onready var guns = [$Gun0,$Gun1]
onready var main = get_tree().current_scene
onready var PlayerBullet = Globals.PlayerBullet

var controllerInput = Vector2()

func _ready():
	print("Player Ready")

func _physics_process(_delta):
	if Globals.gameRunning:
		# Check if running in VR mode or Window and detect controls as appropriate
		if $"../../FPController".inVR != true:
			if Input.is_action_pressed("ui_select"):
				_fire_bullet()
			inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			inputVector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
			inputVector = inputVector.normalized()
		else:
			inputVector = controllerInput
		
		velo.x = move_toward(velo.x, inputVector.x * MAXSPEED, ACCELERATION)
		velo.y = move_toward(velo.y, inputVector.y * MAXSPEED, ACCELERATION)
	
		rotation_degrees.z = velo.x * -.8
		rotation_degrees.x = velo.y / 2
		rotation_degrees.y = -velo.x / 2
	
		if velo.x == 0 and velo.y == 0:
			$AnimationPlayer.play("New Anim")
		else:
			$AnimationPlayer.stop()
		
		if gunCooldown >0:
			gunCooldown -= 1

		var _result = move_and_slide(velo)

func _fire_bullet():
	if Globals.gameRunning:
		if gunCooldown <= 0:
			for i in guns:
				var bullet = PlayerBullet.instance()
				main.add_child(bullet)
			
				bullet.global_transform.origin = i.global_transform.origin
			
			gunCooldown = 12
			
func reset():
	transform.origin = Vector3(7,1.5,9)
	visible = true

func _on_CollisionArea_body_entered(body):
	if Globals.gameRunning:
		print("Player Got Hit by "+body.name)
