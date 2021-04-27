extends KinematicBody2D

const regular_speed = 25
var run_speed = 25
var velocity = Vector2.ZERO
var player = null
var idletarget = null
var wet = false

func _physics_process(delta):
	if !wet:
		velocity = Vector2.ZERO
		if is_instance_valid(player):
			if position.distance_to(player.position) < 40 and player.is_in_group("player"): run_speed = 0 #ANIMATION HIER
			else:
				reset_speed() 
				velocity = position.direction_to(player.position) * run_speed
			if velocity.x < 0: 
				$AnimatedSprite.flip_h = false
				$AnimatedSprite2.flip_h = true
			else: 
				$AnimatedSprite.flip_h = true
				$AnimatedSprite2.flip_h = false
		velocity = move_and_slide(velocity)

func touchedflame():
	run_speed = 20
	$AnimationPlayer.play("heart")
	
func reset_speed():
	run_speed = regular_speed

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"): player = body
	reset_speed()

func _on_DetectRadius_body_exited(body):
	if idletarget != null: 
		player = idletarget
		reset_speed()
	else: run_speed = 0

func _on_HurtBox_area_entered(area):
	if area.is_in_group("water"): 
		area.destroy()
		run_speed = 0 
		$AnimationPlayer.play("heart")
		wet = true
		$Timer.start()
		yield($Timer, "timeout")
		wet = false

func _on_DetectRadius_area_entered(area):
	if !area.is_in_group("water"):
		if idletarget == null and area.is_in_group("flames"): idletarget = area
		elif is_instance_valid(idletarget):
			if position.distance_to(area.position) < position.distance_to(idletarget.position): 
				idletarget = area
