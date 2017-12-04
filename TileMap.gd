extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var cash_desc = preload("res://CashDesk/CashDesk_area.tscn")
func _ready():
	var r = get_used_rect()
	for c in get_used_cells():
		var i = get_cellv(c)
		if i == 5:
			var cd = cash_desc.instance()
			add_child(cd)
			cd.set_pos(Vector2(c.x-1, c.y)*Vector2(64, 64))

func drop_from_shelf(v, dir):
	set_cellv(v, 3)
	var drop_tile_v = dir.normalized().snapped(Vector2(1, 1))
	if get_cellv(v+drop_tile_v) == 0:
		set_cellv(v+drop_tile_v, 4)
		var c = system.item_list["Item"].instance()
		add_child(c)
		c.set_global_pos((v+drop_tile_v)*Vector2(64, 64))
		c.throw(-dir)
