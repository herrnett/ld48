extends Node

var level = 1
var score = 0
var time = 0
var water = 500
var refilling = false
var health = 5
var playerdeaths = 0
var justdied = false
var bosskilled = false
var denyinput = false

#save/load last created room in case of death
var mapdata
func save_room(map, firstroom, exit, fires, fountain):
	mapdata = [map, firstroom, exit, fires, fountain]

func load_room():
	return mapdata

func kill(monster):
	monster.queue_free()

func reset():
	level = 1
	score = 0
	time = 0	
	water = 500
	refilling = false
	health = 5
	playerdeaths = 0
	justdied = false
	bosskilled = false
	denyinput = false
