extends KinematicBody2D

onready var Water_Jet = preload("res://nodes/objects/Water_Jet.tscn")

var invincible = false
var moving = true

func _ready():
	$Camera2D/Health.text = "Health: " +  str(Globals.health)
	$Camera2D/Level.bbcode_text = "[right]Level: " +  str(Globals.level) + "[/right]"
	$Camera2D/Score.text = "Score: " +  str(Globals.score)
	$Camera2D/Time.text = "Time: " +  str(Globals.time)
	$Camera2D/Water.text = "Water: " +  str(floor(Globals.water/5)) + "%"

func _physics_process(delta):
	#level doesnt need to be updated constantly, so its not in here
	$Camera2D/Health.text = "Health: " +  str(Globals.health)
	if !Globals.bosskilled:
		Globals.time += delta
		$Camera2D/Time.text = "Time: " +  "%.1f" % (Globals.time)
	$Camera2D/Score.text = "Score: " +  str(Globals.score)
	if Globals.refilling:
		if Globals.water < 490: Globals.water += 300 * delta 
		else: Globals.water = 500
	$Camera2D/Water.text = "Water: " +  str(floor(Globals.water/5)) + "%"
	if moving:
		var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		if x_input < 0:
			$AnimatedSprite.animation = "default" 
			$AnimatedSprite.flip_h = false
		elif x_input > 0: 
			$AnimatedSprite.animation = "default" 
			$AnimatedSprite.flip_h = true
		elif y_input != 0:
			 $AnimatedSprite.animation = "default" 
		else: $AnimatedSprite.animation = "wait"
		if get_global_mouse_position().x < position.x: $AnimatedSprite.flip_h = false
		elif get_global_mouse_position().x > position.x: $AnimatedSprite.flip_h = true
		move_and_slide(Vector2(x_input, y_input)*150)
		check_collision()
		if Input.is_action_pressed("ui_mouse_left"):
			jet()
			

func check_collision():
	var slide_count = get_slide_count()
	if slide_count:
		var collision = get_slide_collision(slide_count-1)
		var collider = collision.collider
		if collider.is_in_group("monster"): hurt()

func jet():
	if Globals.water > 0:
		var jet_instance = Water_Jet.instance()
		jet_instance.rotation = get_rotation()
		jet_instance.position = get_global_position()
		get_parent().add_child(jet_instance)
		Globals.water -= 1
		$Tween.interpolate_property(jet_instance, "global_position", \
		  jet_instance.global_position, get_global_mouse_position(), \
		  0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

func touchedflame():
	hurt()

func hurt():
	if !invincible:
		if Globals.health > 1:
			invincible = true
			$Sprite.modulate.a = 0.5
			Globals.health -= 1
			$Timer.start()
			yield($Timer, "timeout")
			$Sprite.modulate.a = 1
			invincible = false
		else: 
			Globals.playerdeaths += 1
			Globals.justdied = true
			get_parent().reload_level(true)

func start_moving():
	moving = true

func stop_moving():
	moving = false
