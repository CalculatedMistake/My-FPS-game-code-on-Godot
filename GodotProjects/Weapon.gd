extends Node
class_name Weapon
#variables
export var firerate = 0.01
export var clipsize = 10
export var reloadtime = 1
onready var raycast = get_node("Player/Head/Camera/Ray")
var current_ammo = clipsize
var canfire = true
var reloading = false

#Function to fire
func _process(_delta):
	print(raycast)
	if Input.is_action_just_pressed("fire") and canfire:
		#fire
		if current_ammo > 0 and not reloading:
			print("Fired the weapon")
			current_ammo -= 1
			check_collision()
			canfire = false
			yield(get_tree().create_timer(firerate),"timeout")
			canfire = true
		elif not reloading:
			print("Reloading")
			reloading = true
			yield(get_tree().create_timer(reloadtime),"timeout")
			current_ammo = clipsize
			reloading = false
			print("Reloaded")

#Function to check if the bullet hit a hostile
func check_collision():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Enemies"):
				collider.queue_free()
				print("Killed"+ collider.name)
