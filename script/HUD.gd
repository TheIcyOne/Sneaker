extends CanvasLayer


func _ready():
	get_node("game_over").hide()
	pass

func set_score(val):
	$score.text = str(val)

func set_stage(val):
	$level.text = "Level: " + str(val)
