extends Area2D

const Fireball = preload("res://nodes/objects/Fireball.tscn")
const Flame = preload("res://nodes/objects/Flame.tscn")

const Limbo = preload("res://nodes/monsters/Limbo.tscn")
const Lust = preload("res://nodes/monsters/Lust.tscn")
const Gluttony = preload("res://nodes/monsters/Gluttony.tscn")
const Greed = preload("res://nodes/monsters/Greed.tscn")
const Wrath = preload("res://nodes/monsters/Wrath.tscn")
#Flamewall: 1, 2    :	pentagram: inner pentagon, outer circle, both clockwise, starting at 6
#			3, 4    :	pillar circle: clockwise, starting at 6
#			5, 6, 7 :	fountain circle close to satan: left to right, clockwise 
#			8, 9, 10:	fountain circle close to wall: left to right, clockwise
const Flamewall =  [[544,624], [528,544], [576,512], [624,544], [608,624], 
					[576,720], [432,624], [496,448], [656,448], [720,624],
					
					[544,800], [432,768], [384,720], [352,608], [352,544], [384,432],  [432,384], [544,352],
					[608,352], [720,384], [768,432], [800,544], [800, 608], [768,720], [720,768], [608,800], 
					
					[248,646], [263,626], [273,596], [273,556], [263,526], [248,506],
					[506,248], [526,263], [556,273], [596,273], [626,263], [646,248],
					[904,506], [889,526], [879,556], [879,596], [889,626], [904,646],
					
					[223,631], [238,606], [248,576], [238,546], [223,521],
					[521,223], [546,238], [576,248], [606,238],[631,223],
					[929,521], [914,546], [904,576], [914,606], [929,631]]
const spreadflamesat = [1000, 750, 500, 250]
const extinguishflamesat = [800, 550, 300]
const spawnmonstersat = [950, 850, 750, 650, 550, 450, 350, 250, 150]
const monsterlist = [Limbo, Lust, Gluttony, Greed, Wrath]
#near fountains lower pillar rows plus two behind boss
const monsterpositions = [[273,596], [556,273], [879,556], [580, 416], [576, 416]]
#positions identical with inner pentagon
#const monsterpositions = [[544,624], [528,544], [576,512], [624,544], [608,624]]

var flames = []
var monsters = []
var hp = 1000
#Flamewall: 1st, 2nd: left fountain: inner, outer row
#			3rd, 4th: middle fountain: inner, outer row
#			5th, 6th: right fountain: inner, outer row
#			7th, 8th: pentagram: outer circle, inner pentagon
#			9th,10th: pillar circle
#const Flamewall = [[248,576], [238,546], [238,606], [223,521], [223,631],
#					[273,556], [273,596], [263,526], [263,626], [248,506], [248,646], 
#					[576,248], [546,238], [606,238], [521,223], [631,223],
#					[556,273], [596,273], [526,263], [626,263], [506,248], [646,248],
#					[904,576], [914,546], [914,606], [929,521], [929,631],
#					[879,556], [879,596], [889,526], [889,626], [904,506], [904,646],
#					[576,720], [432,624], [720,624], [496,448], [656,448],
#					[544,624], [608,624], [528,544], [624,544], [576,512],
#					[544,800], [608,800], [432,768], [720,768], [384,720], [768,720], [352,608], [800, 608],
#					[352,544], [800,544], [384,432], [768,432], [432,384], [720,384], [544,352], [608,352]]



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for element in spreadflamesat:
		if element - 10 < hp and hp < element + 10: 
			spread_flames()
			spreadflamesat.pop_front()
			
	for element in extinguishflamesat:
		if element - 10 < hp and hp < element + 10: 
			extinguish_flames() 
			extinguishflamesat.pop_front()
	
	for element in spawnmonstersat:
		if element - 10 < hp and hp < element + 10: 
			spawn_monsters()
			spawnmonstersat.pop_front()
	
	if hp < 1 and !Globals.bosskilled:
		extinguish_flames()
		for monster in monsters:
			if is_instance_valid(monster): Globals.kill(monster)
		Globals.bosskilled = true
		Globals.denyinput = true
		Scenechanger.change_scene("res://nodes/Outro.tscn", true)

#func fireball():
#	var fireball_instance = Fireball.instance()
#	fireball_instance.position = self.global_position
#	get_parent().add_child(fireball_instance)

func spawn_monsters():
	hp -= 25
	var newmonster
	for i in range(5):
		var index = (randi() % monsterlist.size())
		newmonster = monsterlist[index]
		var monster_instance = newmonster.instance()
		monster_instance.position = Vector2(monsterpositions[i][0], monsterpositions[i][1])
		get_node("/root/World/").add_child(monster_instance)
	monsters = get_tree().get_nodes_in_group("monster")

func extinguish_flames():
	hp -= 25
	if flames != []:
		for flame in flames:
			if is_instance_valid(flame):
				$ExtinguishTween.interpolate_property(flame, "scale", \
				flame.scale, Vector2(0,0), \
				0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
				$ExtinguishTween.start()
		flames = []

func spread_flames():
	hp -= 25
	for flamepos in Flamewall:
			var flame = Flame.instance()
			flame.position = self.global_position
			get_parent().add_child(flame)
			$Tween.interpolate_property(flame, "position", \
			flame.global_position, Vector2(flamepos[0], flamepos[1]), \
			0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
			$Timer.start()
			yield($Timer, "timeout")
	flames = get_tree().get_nodes_in_group("flames")

func _on_Satan_area_entered(area):
	if area.is_in_group("water"):
		area.destroy()
		hp -= 0.5

func _on_ExtinguishTween_tween_completed(object, key):
	if is_instance_valid(object): object.queue_free()


func _on_Tween_tween_completed(object, key):
	if is_instance_valid(object): object.z_index -= 1
