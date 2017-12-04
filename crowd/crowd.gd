extends Sprite

export var state = 0
var a = 0
var b = 0
func set_state(i):
	if i == 0:
		get_node("crowd_a").hide()
		a = 0
	if i == 1:
		get_node("crowd_a").show()
		get_node("crowd_a/Crowd").set_monitorable(true)
		get_node("crowd_a/Crowd").set_enable_monitoring(true)
		b = 0
		a = 1
	if i == 2:
		b = 1
		a = 1
		set_process(false)
		get_node("Timer").stop()
	change()

func change():
	set_region_rect(Rect2(Vector2(a*64, 0), Vector2(64, 32)))
	get_node("crowd_a").set_region_rect(Rect2(Vector2(b*64, 0), Vector2(64, 32)))

func new_():
	
	var n = load("res://crowd/crowd.tscn").instance()
	var nn = get_parent().add_child(n)
	n.set_global_pos(get_global_pos()-Vector2(0, 64))

func _ready():
	
	get_node("Timer").start()
	set_state(state)

func _on_Timer_timeout():
	state += 1
	set_state(state)
	if state == 2:
		new_()

func _on_Area2D_area_enter( area ):
	pass # replace with function body
