extends CharacterBody3D

var sparks = preload("res://sparks.tscn")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 5
var mouse_sensitivity = 0.002


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("shoot"):
		shoot()
		
func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	if movement_dir.length() != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed

func shoot():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create($Camera3D.global_position,
			$Camera3D.global_position + -$Camera3D.global_transform.basis.z * 100)
	var collision = space.intersect_ray(query)
	if collision:
		$CanvasLayer/Label.text = collision.collider.name
		var s = sparks.instantiate()
		get_tree().current_scene.add_child(s)
		s.position = collision.position
		s.emitting = true
		s.direction = collision.normal
		if collision.collider.has_method("hit"):
			collision.collider.hit()
	else:
		$CanvasLayer/Label.text = ""
