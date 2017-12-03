extends KinematicBody2D

var target = null # node
var taget_list = []

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

class Sorter:
	var my_pos = Vector2()
	func _init(pos):
		self.my_pos = pos
	func sort_by_distance(a,b):
		return a.get_pos().distance_squared_to(self.my_pos) < \
		b.get_pos().distance_squared_to(self.my_pos)
		