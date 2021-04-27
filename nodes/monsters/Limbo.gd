extends KinematicBody2D

const regular_speed = 10
var run_speed = 10
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if is_instance_valid(player):
		velocity = position.direction_to(player.position) * run_speed
		if velocity.x < 0: $AnimatedSprite.flip_h = false
		else: $AnimatedSprite.flip_h = true
	velocity = move_and_slide(velocity)

func touchedflame():
	pass
	
func reset_speed():
	run_speed = regular_speed
	$AnimatedSprite.animation = "default"

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"): 
		player = body
		reset_speed()

func _on_DetectRadius_body_exited(body):
	player = null
	reset_speed()

func _on_HurtBox_area_entered(area):
	if area.is_in_group("water"): 
		area.destroy()
		run_speed -= 1 if run_speed > 0 else 0
		$AnimatedSprite.animation = "wet"
