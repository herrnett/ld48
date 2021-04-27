extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	match Globals.level:
		0: $Sprite/FloorName.bbcode_text="[center]Limbo[/center]"
		1: $Sprite/FloorName.bbcode_text="[center]Lust[/center]"
		2: $Sprite/FloorName.bbcode_text="[center]Gluttony[/center]"
		3: $Sprite/FloorName.bbcode_text="[center]Greed[/center]"
		4: $Sprite/FloorName.bbcode_text="[center]Wrath[/center]"
		5: $Sprite/FloorName.bbcode_text="[center]Heresy[/center]"
		6: $Sprite/FloorName.bbcode_text="[center]Violence[/center]"
		7: $Sprite/FloorName.bbcode_text="[center]Fraud[/center]"
		8: $Sprite/FloorName.bbcode_text="[center]Treachery[/center]"
		_: $Sprite/FloorName.bbcode_text="[center]WRONG FLOOR[/center]"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation = -get_parent().rotation
