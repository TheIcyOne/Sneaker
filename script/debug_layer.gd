extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var a
var b

func _ready():
	set_process(true)
	pass

func _process(delta):
	update()

func draw_l(vec1, vec2):
	a = vec1
	b = vec2
	

func _draw():
	if a && b:
		draw_line(a, b, Color(255,255,255), 10)
		print("draw ", a, b)