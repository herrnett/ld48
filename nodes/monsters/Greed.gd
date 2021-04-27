extends KinematicBody2D

const regular_speed = 30
var hp = 5
var invincible = false
var run_speed = 30
var velocity = Vector2.ZERO
var player = null
var playerinstance = null
var aggravated = false
var fighting = false

func _physics_process(delta):
	if is_instance_valid(player): 
		velocity = position.direction_to(player.position) * run_speed
		if velocity.x < 0: $AnimatedSprite.flip_h = false
		else: $AnimatedSprite.flip_h = true
	velocity = move_and_slide(velocity)
	check_collision()
	
	#check for themself, everything else in player
func check_collision():
	var slide_count = get_slide_count()
	if slide_count:
		for i in range(slide_count-1):
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if collider.is_in_group("monster"): hurt()

	
func hurt():
	if !invincible:
		if hp > 1:
			invincible = true
			#$Sprite.modulate.a = 0.5
			hp -= 1
			$Timer.start()
			yield($Timer, "timeout")
			invincible = false
			#$Sprite.modulate.a = 0.5
		else: 
			queue_free()
			

func touchedflame():
	run_speed = 0
	
func reset_speed():
	run_speed = regular_speed

func _on_DetectRadius_body_entered(body):
	if body.is_in_group("player"): playerinstance = body
	if player != null: 
		fighting = true
		player = body
		reset_speed()
	else:
		player = playerinstance if aggravated else body
		run_speed = 45 

func _on_DetectRadius_body_exited(body):
	fighting = false
	player = null
	reset_speed()

func _on_DetectRadius_area_entered(area):
	if !fighting and !aggravated and area.is_in_group("flames"):
		player = area

func _on_DetectRadius_area_exited(area):
	pass # Replace with function body.
	
func _on_HurtBox_area_entered(area):
	if area.is_in_group("water"): 
		area.destroy()
		aggravated = true
		player = playerinstance
		




