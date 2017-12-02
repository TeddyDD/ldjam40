extends Sprite

export var item_type = "Item"
export var item_ammount = 2
var player = null

func _ready():
	set_process(true)
	
func _process(delta):
	if player == null:
		return
	if not player.item and Input.is_action_pressed("ui_accept"):
		prints("spawning item")
		var n = load("res://item_spawner/%s.tscn" % item_type).instance()
		n.set_name("item")
		player.item = n
		player.add_child(n)

func _on_pick_area_area_enter( area ):
	if area.get_name() == "player_area":
		print("player enters pick area")
		player = area.get_parent()
		#co kurwa?


func _on_pick_area_area_exit( area ):
	if area.get_name() == "player_area":
		player = null