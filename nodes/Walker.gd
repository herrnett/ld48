extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var rooms = []
var fountain = null

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders

func walk(steps):
	place_room(position)
	for step in steps:
		if steps_since_turn >= 6:
			change_direction()
		if step():
			step_history.append(position)
		else:
			change_direction()
	
#	sort and go from back to front erasing the currently checked i when its neighbor has the same value. 
	step_history.sort()
	for i in range(step_history.size(), 0, -1):
		if step_history[i-1] == step_history[i-2]:
			step_history.remove(i-1)
	return step_history

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func place_room(roomposition):
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner = (roomposition - size/2).ceil()
	
#	append the new room (therefore savin its full size, then checking if it can be drawn (thereby cutting down the size effectively) 
	rooms.append({position = roomposition, size = size})
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_first_room():
	# This one is weird. i issume it doesnt really work because it saves rooms in its pre-cutdown-state (see this.place_room)
	return rooms.back().size/4

func get_exit():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	var exit_position = end_room.position
	return exit_position

func get_fountain():
	# This has to be called after get_exit because otherwise the variable will be empty. 
	var randroom = randi() % 4 + 4
	return (rooms[randroom].position + Vector2(0.5, 0)) * 32 


