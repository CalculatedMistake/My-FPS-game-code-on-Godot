extends KinematicBody
#V Details of movement V
export var speed = 10
export var acceleration = 10
export var gravity = 0.98
export var powerofjump = 30
export var Sensitivity = 0.3
#V Cam Setup V
onready var head = $Head
onready var camera = $Head/Camera
#V CamVariables V
var velocity = Vector3()
var camera_x_rotation = 0
#V Movement V
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * Sensitivity))
		
		var x_delta = event.relative.y * Sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta
func _physics_process(delta):
	var headbasis = head.get_global_transform().basis
	#Walking
	var direction = Vector3()
	if Input.is_action_pressed("move_foward"): #<----When Pressing W
		direction -= headbasis.z
	elif Input.is_action_pressed("move_backward"):#<----When Pressing S
		direction += headbasis.z
	if Input.is_action_pressed("move_left"): #<----When Pressing A
		direction -= headbasis.x
	elif Input.is_action_pressed("move_right"):#<----When Pressing D
		direction += headbasis.x
	#Speed
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction*speed,acceleration*delta)
	velocity.y -= gravity
	
	
	if Input.is_action_pressed("move_jump") and is_on_floor(): #<----When Pressing Spacebar
			velocity.y += powerofjump
	
	velocity = move_and_slide(velocity,Vector3.UP)

