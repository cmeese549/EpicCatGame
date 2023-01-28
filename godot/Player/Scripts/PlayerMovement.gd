extends CharacterBody2D

@onready var camera = $Camera2D

var speed = 100

var max_cam_zoom = 3
var min_cam_zoom = 1.5
var cam_zoom_speed = 5

func _physics_process(delta):
	get_input()
	move_and_slide()

func _process(delta):
	do_camera_zoom(delta)


func get_input():
	var input_direction = Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	velocity = input_direction * speed
	
func do_camera_zoom(delta):
	if (Input.is_action_pressed("Zoom_Out") || Input.is_action_just_released("Zoom_Out")) && camera.zoom.x > min_cam_zoom:
		var adjusted_speed = cam_zoom_speed
		if Input.is_action_just_released("Zoom_Out"): adjusted_speed *= 2
		camera.zoom = Vector2(
			clamp(camera.zoom.x - adjusted_speed * delta, min_cam_zoom, max_cam_zoom),
			clamp(camera.zoom.y - adjusted_speed * delta, min_cam_zoom, max_cam_zoom))
	elif (Input.is_action_pressed("Zoom_In") || Input.is_action_just_released("Zoom_In")) && camera.zoom.x < max_cam_zoom:
		var adjusted_speed = cam_zoom_speed
		if Input.is_action_just_released("Zoom_In"): adjusted_speed *= 2
		camera.zoom = Vector2(
			clamp(camera.zoom.x + adjusted_speed * delta, min_cam_zoom, max_cam_zoom), 
			clamp(camera.zoom.y + adjusted_speed * delta, min_cam_zoom, max_cam_zoom))


