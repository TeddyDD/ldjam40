extends Node2D

func _ready():
	randomize()

func reparent(from, to):
	var temp = from
	from.get_parent().remove_child(from)
	to.add_child(temp)
	
	