extends Node2D

const Exit = preload("res://nodes/objects/Stairs.tscn")
const Flame = preload("res://nodes/objects/Flame.tscn")
const Fountain = preload("res://nodes/objects/Fountain.tscn")
const Player = preload("res://nodes/Player.tscn")
const BossRoom = preload("res://nodes/BossRoom.tscn")

const Limbo = preload("res://nodes/monsters/Limbo.tscn")
const Lust = preload("res://nodes/monsters/Lust.tscn")
const Gluttony = preload("res://nodes/monsters/Gluttony.tscn")
const Greed = preload("res://nodes/monsters/Greed.tscn")
const Wrath = preload("res://nodes/monsters/Wrath.tscn")

var borders = Rect2(5, 5, 24, 15)
var map = []
var firstroom = []
var exit = []
var fountain = []
var events = []
var eventpercent = 0
var monstertype


onready var tileMap = $TileMap

func _ready():
	randomize()
	match Globals.level:
		1: 		eventpercent = 15
		2,3:	eventpercent = 20
		4,5: 	eventpercent = 25
		6:		eventpercent = 30
		7:		eventpercent = 35
		8:		eventpercent = 40
		9:		eventpercent = 0
		_:		eventpercent = 5	
		
	match Globals.level:
		1:	monstertype = Limbo
		2:	monstertype = Lust
		3:	monstertype = Gluttony
		4:	monstertype = Greed
		5:	monstertype = Wrath
		_:	monstertype = [Limbo, Lust, Gluttony, Greed, Wrath]
	generate_level(Globals.justdied)

func generate_level(justdied):
	if Globals.level != 9:
		if !justdied:
			var walker = Walker.new(Vector2(19, 11), borders)
			map = walker.walk(randi() % 400 + 100)
			firstroom = walker.get_first_room()
			exit = walker.get_exit()
			fountain = walker.get_fountain()
			for location in map:
				tileMap.set_cellv(location, -1)
				if randi() % 100 + 1 < eventpercent:
					events.append(location)
			walker.queue_free()
			Globals.save_room(map, firstroom, exit, events, fountain)
		else: 
			var mapdata = Globals.load_room()
			map 		= mapdata[0]
			firstroom 	= mapdata[1]
			exit 		= mapdata[2]
			events 		= mapdata[3]
			fountain 	= mapdata[4]
			for location in map: tileMap.set_cellv(location, -1)
			Globals.health = 5
			Globals.water = 500
			Globals.justdied = false
		populate()
		tileMap.update_bitmask_region(borders.position, borders.end)
	else:
		if justdied:
			Globals.health = 5
			Globals.water = 500
			Globals.justdied = false
		remove_child($TileMap)
		var bossroom = BossRoom.instance()
		add_child(bossroom)	
		var roomplayer = Player.instance()
		add_child(roomplayer)
		roomplayer.position = Vector2(592, 880)
		$Player/Camera2D/AnimationPlayer.play("fromfloor")
		yield($Player/Camera2D/AnimationPlayer, "animation_finished")
		$Player.start_moving()
		

#	Stupid code to find lone wall pieces. Made redundant by autotiling.
#	var walls = tileMap.get_used_cells()
#	walls.sort()
#	for wall in walls:
#		if !walls.has(Vector2(wall.x-1, wall.y)) \
#		and !walls.has(Vector2(wall.x+1, wall.y)) \
#		and !walls.has(Vector2(wall.x, wall.y-1)) \
#		and !walls.has(Vector2(wall.x, wall.y+1)):
#			tileMap.set_cellv(wall, 1)

func populate():
	var roomplayer = Player.instance()
	add_child(roomplayer)
	roomplayer.position = (map.front() + firstroom) * 32
	
	var roomexit = Exit.instance()
	add_child(roomexit)
	roomexit.position = exit
	
	var roomfountain = Fountain.instance()
	add_child(roomfountain)
	if fountain != null: roomfountain.position = fountain
	else: roomfountain.position = roomplayer.position + Vector2(32,0)
	
	for event in events:
		#20 percent chance of an event becoming a monster
		if randi() % 100 + 1 <= 20:
			spawn_monster(event, roomplayer, roomfountain)
		else:
			var flame = Flame.instance()
			flame.position = (event * 32 + Vector2(randi() % 16 - 8, randi() % 16 - 8))
			if flame.position.distance_to(roomplayer.position) > 75 \
			and flame.position.distance_to(roomexit.position) > 50 \
			and flame.position.distance_to(roomfountain.position) > 50:
				add_child(flame)
	
	$Player/Camera2D/AnimationPlayer.play("fromfloor")
	yield($Player/Camera2D/AnimationPlayer, "animation_finished")
	$Player.start_moving()
	
#	Trying to get exits away from walls way too inefficiently.
#	var randx = randi() % 3 + 1
#	var randy = randi() % 3 + 1
#	if walls.has(Vector2(exit.position.x - randx, exit.position.y + randy)):
#		if walls.has(Vector2(exit.position.x - randx, exit.position.y - randy)):
#			if walls.has(Vector2(exit.position.x + randx, exit.position.y - randy)):
#				if walls.has(Vector2(exit.position.x + randx, exit.position.y + randy)):
#					exit.position = exit.position*32
#				else: exit.position = Vector2(exit.position.x + randx, exit.position.y + randy)*32
#			else: exit.position = Vector2(exit.position.x + randx, exit.position.y - randy)*32
#		else: exit.position = Vector2(exit.position.x - randx, exit.position.y - randy)*32
#	else: exit.position = Vector2(exit.position.x - randx, exit.position.y + randy)*32

	roomexit.position = roomexit.position*32
	roomexit.connect("leaving_level", self, "reload_level")

func spawn_monster(event, roomplayer, roomfountain):
	var newmonster
	if typeof(monstertype) != 17:
		var index = (randi() % monstertype.size())
		newmonster = monstertype[index]
	else: newmonster = monstertype
	var monster = newmonster.instance()
	monster.position = (event * 32 + Vector2(randi() % 16 - 8, randi() % 16 - 8))
	if monster.position.distance_to(roomplayer.position) > 75 and monster.position.distance_to(roomfountain.position) > 50:
		add_child(monster)

func reload_level(death = false):
	$Player.stop_moving()
	if !death:
		$Player/Camera2D/AnimationPlayer.play("tofloor") 
		yield($Player/Camera2D/AnimationPlayer, "animation_finished")
		Globals.level += 1
		$Player/Camera2D/AnimationPlayer.play("showstage")
		yield($Player/Camera2D/AnimationPlayer, "animation_finished")
	else: 
		$Player/Camera2D/AnimationPlayer.play_backwards("fromfloor")
		yield($Player/Camera2D/AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
