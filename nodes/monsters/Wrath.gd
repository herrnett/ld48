extends KinematicBody2D

const regular_speed = 25
const max_speed = 80
var run_speed = 20
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if run_speed < max_speed: run_speed += 8*delta
	if is_instance_valid(player):
		velocity = position.direction_to(player.position) * run_speed
		if velocity.x < 0: $AnimatedSprite.flip_h = false
		else: $AnimatedSprite.flip_h = true
	velocity = move_and_slide(velocity)

func touchedflame():
	pass
	
func reset_speed():
	run_speed = regular_speed

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"): 
		player = body
		reset_speed()

func _on_DetectRadius_body_exited(body):
	pass

func _on_HurtBox_area_entered(area):
	if area.is_in_group("water"): 
		area.destroy()
		run_speed -= 1 if run_speed > 0 else 0
