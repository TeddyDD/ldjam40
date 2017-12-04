extends Sprite

export var state = 0
var a = 0
var b = 0
func set_state(i):
	if i == 0:
		get_node("crowd_a").hide()
		a = 2
	if i == 1:
		get_node("crowd_a").show()
		b = 2
		a = 1
	if i == 2:
		get_node("crowd_a").show()
		b = 2
		a = 2
		set_process(false)
		get_node("Timer").stop()
	change()

func change():
	set_region_rect(Rect2(Vector2(a*64, 0), Vector2(64, 32)))
	get_node("crowd_a").set_region_rect(Rect2(Vector2(b*64, 0), Vector2(64, 32)))

func _ready():
	
	get_node("Timer").start()



func _on_Timer_timeout():
	state += 1
	set_state(state)