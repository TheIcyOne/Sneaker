extends KinematicBody2D

export (int) var SPD #Movespeed of the player
var screen_size
var running = false

var over = true

func _ready():
	over = true
	add_to_group("player")
	add_to_group("game_listener")
	screen_size = get_viewport_rect().size
	pass

func _process(delta):
	if over: return
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPD
	
#	position += velocity * delta
#	position.x = clamp(position.x, 0, screen_size.x)
#	position.y = clamp(position.y, 0, screen_size.y)
	var p = move_and_collide(velocity * delta)
	if p:
		if (p.collider.is_in_group("stairs")):
			get_tree().call_group("main", "next_stage")
		elif (p.collider.is_in_group("guards")):
			get_tree().call_group("game_listener", "game_over") 
	
	if velocity.x == 0:
		$sprite.animation = "motion"
		if velocity.y > 0:
			$sprite.rotation = PI
		elif velocity.y == 0:
			$sprite.animation = "still"
		else:
			$sprite.rotation = 0
	elif velocity.x > 0:
		$sprite.animation = "motion"
		if velocity.y > 0:
			$sprite.rotation = 3 * PI / 4
		if velocity.y == 0:
			$sprite.rotation = PI/2
		if velocity.y < 0:
			$sprite.rotation = PI / 4
	else:
		$sprite.animation = "motion"
		if velocity.y > 0:
			$sprite.rotation = PI / 4
		if velocity.y == 0:
			$sprite.rotation = PI/2
		if velocity.y < 0:
			$sprite.rotation = 3 * PI / 4
		$sprite.rotate(PI)
	
	pass

func start(pos):
	global_position = pos
	over = false

func game_over():
	over = true