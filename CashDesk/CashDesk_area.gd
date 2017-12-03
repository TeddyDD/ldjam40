extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_CashDesk_area_area_enter( area ):
	if area.get_name() == "player_area":
		pass
