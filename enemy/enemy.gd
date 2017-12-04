extends KinematicBody2D

var target = null # node
var taget_list = []
var hit_by = null

var path = null
var close_to = null
var inventory

func _ready():
	inventory = get_node("inventory")
	set_process(true)
	
func _process(delta):
	get_node("debug").set_text(get_node("FSM2D").getStateID())

func _draw():
	if path != null:
		for p in path:
			draw_circle(p-get_pos(), 12, Color(1,0,1))

class Sorter:
	var my_pos = Vector2()
	func _init(pos):
		self.my_pos = pos
	func sort_by_distance(a,b):
		return a.get_pos().distance_squared_to(self.my_pos) < \
		b.get_pos().distance_squared_to(self.my_pos)
		

func _on_hit_area_area_enter( area ):
	if area.get_parent().is_in_group("spawner"):
		prints("NEAR SPAWNER")
		close_to = area.get_parent()
	if area.is_in_group("item"):
		if area.get_parent().flies == true:
			hit_by = area.get_parent()
		elif area.get_parent().is_active == true:
			close_to = area.get_parent()
	if area.get_name() == "Crowd":
		queue_free()