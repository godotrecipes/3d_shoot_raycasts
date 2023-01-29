extends CharacterBody3D

var speed = 3.0
var life = 3

func _ready():
	rotate_y(randf_range(0, TAU))
	velocity = -transform.basis.z * speed
	
	
func _physics_process(delta):
	var c = move_and_collide(velocity * delta)
	if c:
		velocity = velocity.bounce(c.get_normal())
		look_at(position + velocity)

func hit():
	life -= 1
	if life <= 0:
		queue_free()
