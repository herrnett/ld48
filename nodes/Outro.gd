extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	$RichTextLabel.bbcode_text = str("Time:  " +  "%.1fs" % (Globals.time), \
	"\nScore: ", Globals.score, "\nDeaths:", Globals.playerdeaths)

func _input(event):
	if !Globals.denyinput:
		if (event is InputEventKey) or (event is InputEventMouseButton):
			Scenechanger.change_scene("res://nodes/Title.tscn", true)


func _on_Timer_timeout():
	Globals.denyinput = false
	$RichTextLabel.bbcode_text = str("Time:  " +  "%.1fs" % (Globals.time), \
	"\nScore: ", Globals.score, "\nDeaths:", Globals.playerdeaths,
	"\n\n\n\n\n\nPress any key: Go to Title")
