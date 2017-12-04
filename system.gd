extends Node

onready var nav = get_node("/root/game/Navigation2D")
onready var tilemap = get_node("/root/game/Navigation2D/TileMap")
onready var tileset = get_node("/root/game/Navigation2D/TileMap").get_tileset()
onready var map_ysort = get_node("/root/game/YSort")
onready var trolley = get_node("/root/game/YSort/Trolley")
onready var player = get_node("/root/game/YSort/player")

var item_list = {
	"Item" : load("res://item_spawner/Item.tscn")
}

func reparent(from, to):
	var temp = from
	from.get_parent().remove_child(from)
	to.add_child(temp)

func slide_body(obj, mov, delta):
	if obj.is_colliding():
		var n = obj.get_collision_normal()
		mov = n.slide(mov * delta)
		obj.move(mov)
