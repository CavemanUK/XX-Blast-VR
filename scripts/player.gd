extends KinematicBody


const MAXSPEED = 20
const ACCELERATION = 1
var inputVector = Vector3()
var velo = Vector3()

onready var guns = [$Gun0,$Gun1]
onready var main = get_tree().current_scene
onready var Bullet = preload("res://scenes/Bullet.tscn")

var controllerInput = Vector2()

func _ready():
	visible = true
	_fire_bullet()
	
func _physics_process(_delta):
	# Check if running in VR mode or Window and detect controls as appropriate
	if $"../FPController".inVR != true:
		if Input.is_action_just_released("ui_select"):
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
	
	move_and_slide(velo)

func _fire_bullet():
	for i in guns:
		var bullet = Bullet.instance()
		main.add_child(bullet)
		bullet.global_transform.origin = i.global_transform.origin


func _on_Area_body_entered(body):
	print_debug(body.name)
