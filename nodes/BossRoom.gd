extends TileMap

const Fountain = preload("res://nodes/objects/Fountain.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	parent.get_node("Node2D/ColorRect").color = Color(0,0,0,0)
	
	var fountainleft = Fountain.instance()
	fountainleft.position = Vector2(224,576)
	fountainleft.get_node("AnimatedSprite").animation = "half"
	fountainleft.get_node("AnimatedSprite").frame = 1
	parent.add_child(fountainleft)
	
	var fountainmiddle = Fountain.instance()
	fountainmiddle.get_node("AnimatedSprite").animation = "default"
	fountainmiddle.get_node("AnimatedSprite").frame = 0
	fountainmiddle.position = Vector2(576,208)
	parent.add_child(fountainmiddle)
	
	var fountainright = Fountain.instance()
	fountainright.get_node("AnimatedSprite").animation = "half"
	fountainright.get_node("AnimatedSprite").frame = 0
	fountainright.position = Vector2(944, 576)
	parent.add_child(fountainright)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
