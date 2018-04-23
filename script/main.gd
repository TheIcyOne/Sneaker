extends Node

export (PackedScene) var Stage
var stage

var score = 0
var level = 0
var time = 1.0
var scored = false

var over = false

func _ready():
	add_to_group("main")
	add_to_group("game_listener")
	get_node("HUD/game_start").show()
	get_node("HUD/button_start").connect("pressed", self, "game_start")
	
	over = true
	pass

func next_stage():
	if stage:
		stage.queue_free()
	
	over = false
	
	add_score(level * 1000)
	print("Score from level.")
	
	level+=1
	get_node("HUD").set_stage(level)
	stage = Stage.instance()
	stage.ready(level)
	add_child(stage)
	
	$player.start($player/pos.position)
	


func _process(delta):
	time= time + delta
	if (convert(floor(time), TYPE_INT) % 10 == 0):
		if (scored == false):
			add_score(level * level * 100)
			print("Score from survival")
			scored = true
	else:
		scored = false
	
	pass

func add_score(add):
	if over: return
	score = score + add
	get_node("HUD").set_score(str(score))
	

func game_over():
	
	get_node("game_over_sound").play(0)
	get_node("loop").stop()
	over = true
	get_node("HUD/game_over").show()
	get_node("HUD/game_over/score_indicator").text = str(score)
	get_node("HUD/game_over/score_indicator").show()
	get_node("HUD/button_start").show()

func game_start():
	score = 0
	level = 0
	get_node("HUD/game_over").hide()
	get_node("HUD/button_start").hide()
	get_node("HUD/game_over/score_indicator").hide()
	get_node("HUD/game_start").hide()
	get_node("HUD").set_score(str(score))
	over = false
	next_stage()
	get_node("loop").play(0)
	get_node("game_over_sound").stop()

func _on_loop_finished():
	get_node("loop").play(0)
