extends Node2D

export (PackedScene) var Guard
export (PackedScene) var Walls

var level

func ready(tier):
	level = tier
	randomize()
	for i in range(level):
		var guard = Guard.instance()
		add_child(guard)
		
	if level >= 2:
		scatter_walls(level * level * 2)
	pass
	

func scatter_walls(n):
	var width = OS.window_size.x
	var height = OS.window_size.y
	for i in range(n):
		var wall = Walls.instance()
		var x = rand_range(32,  width - 32)
		var y = rand_range(32,  height - 32)
		if ((x + y) > 250 && (x + y) < (width + height - 150)):
			wall.position = Vector2(x, y)
		add_child(wall)
