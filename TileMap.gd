extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func drop_from_shelf(v, dir):
	set_cellv(v, 3)
	var drop_tile_v = dir.normalized().snapped(Vector2(1, 1))
	if get_cellv(v+drop_tile_v) == 0:
		set_cellv(v+drop_tile_v, 4)
