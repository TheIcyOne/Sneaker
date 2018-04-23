extends RigidBody2D

export (int) var VEL_MIN
export (int) var VEL_MAX

export (int) var PATHLEN_MIN
export (int) var PATHLEN_MAX

export (int) var PATHVERT_MAX

export (int) var ALWAYS_DETECT_RANGE = 35
export (int) var WIDE_DETECT_RANGE = 75
export (int) var NORMAL_DETECT_RANGE = 100
export (int) var MAX_TRACES = 5

var speed
var space_state

var path_length
var path_vertices

var current_detection = 0

var last_vertex
var time_last = 0
var direction

func _ready():
	randomize()
	add_to_group("guards")
	add_to_group("game_listener")
	speed = rand_range(VEL_MIN, VEL_MAX)
	rotation = rand_range(0, TAU)
	
	path_vertices = (randi() % (PATHVERT_MAX - 3)) + 3
	path_length = (randi() % (PATHLEN_MAX - PATHLEN_MIN)) + PATHLEN_MIN
	
	var placed = false
	while placed == false:
		var x = rand_range(32,  get_viewport_rect().size.x - 32)
		var y = rand_range(32,  get_viewport_rect().size.y - 32)
		if ((x + y) > 250 && (x + y) < (get_viewport_rect().size.x + get_viewport_rect().size.y - 150)):
			position = Vector2(x, y)
			placed = true
			if randi()%2 == 0: direction = 1
			else: direction = -1

	
	current_detection = 0
	pass

func _physics_process(delta):
	var space_rid = get_world_2d().space
	if is_player_seen()  &&  current_detection == 3:#
		chase(delta)
	else:
		wander(delta)
	pass

func is_player_seen():
	var player = get_node("/root/main/player")
	var cut = (position - player.position)
	var dist = cut.abs().length()
	if current_detection !=3:
		if dist < ALWAYS_DETECT_RANGE:
			get_tree().call_group("guards", "become_alert")
			current_detection = 3
			return true
		
		if ((dist < WIDE_DETECT_RANGE) && (current_detection > 1)):
			current_detection += 1
			return true
		
	if (dist < NORMAL_DETECT_RANGE):
		if (current_detection == 3): 
			return true
		
		current_detection = min(2, current_detection + 1)
		return true
			
	return false


func become_alert():
	if current_detection <= 2 && is_player_seen():
		current_detection += 1
		pass
	if !is_player_seen():
		current_detection = min(current_detection, 1)

func wander(delta):
	if !last_vertex:
		last_vertex = position
	var motion = Vector2(0, 1).rotated(rotation) * speed * delta
	var result = get_world_2d().direct_space_state.intersect_ray(position, position + motion * 20, [self])
	if result:
		
		if result.collider.is_in_group("walls") ||  result.collider.is_in_group("stairs") :
			rotate((path_vertices - 2 ) * PI / path_vertices * direction)
			last_vertex = position
			time_last = 0
	position += motion
	time_last += delta
	if ((last_vertex - position).length() >= path_length) || time_last / speed >= path_length:
		rotate((path_vertices - 2 ) * PI / path_vertices * direction)
		last_vertex = position
		time_last = 0

func chase(delta):
	var cut = (get_node("/root/main/player").position - position).normalized() * speed * delta
	rotate(Vector2(0, 1).rotated(rotation).angle_to(cut))
	position += cut

func game_over():
	queue_free()