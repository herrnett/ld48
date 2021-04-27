extends KinematicBody2D

const regular_speed = 50
var run_speed = 50
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
	velocity = move_and_slide(velocity)

func touchedflame():
	run_speed = 75
	
func reset_speed():
	run_speed = regular_speed

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"): 
		player = body
		reset_speed()

func _on_DetectRadius_body_exited(body):
	player = null
	reset_speed()

func _on_HurtBox_area_entered(area):
	if area.is_in_group("water"): 
		run_speed -= 1
		area.destroy()
