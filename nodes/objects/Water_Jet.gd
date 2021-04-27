extends Area2D

#ACTUAL SPRAYING IN PLAYER.GD!

#var speed = 4
#var damp = Vector2(0.99999, 0.99999)
#var movement = Vector2()
#onready var mouse_pos = null

func _ready():
#	mouse_pos = get_local_mouse_position()
	#a little variation to make the jet look less static
	var speed = randf() + 0.7
	$AnimatedSprite.speed_scale = speed if speed < 1 else 1 
	$AnimatedSprite.play("default")
#
#func _physics_process(delta):
#	if damp > Vector2(0.01,0.01):
#		movement = movement.move_toward(mouse_pos, delta).normalized() * speed
#		position = position + (movement * damp)
#		damp = damp * damp

#gets called by fire
func destroy():
	queue_free()

func _on_Water_Jet_body_entered(body):
	if body.is_in_group("walls"):
		queue_free()

func _on_AnimatedSprite_animation_finished():
	$CollisionShape2D.disabled = true
	z_index -= 1
