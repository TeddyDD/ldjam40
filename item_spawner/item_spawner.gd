extends Sprite

export var item_type = "Item"
export var item_ammount = 2

onready var player = system.player
var _is_there_a_player = false
const PLAYER_AREA_NAME = "player_area"
var inventory

func _ready():
	inventory = get_node("inventory")
	inventory.capacity = item_ammount
	while not inventory.is_full():
		inventory.add_item(load("res://item_spawner/%s.tscn" % item_type).instance())
	set_process(true)
	
func _process(delta):
	if player == null:
		return
	if _is_there_a_player and\
			not player.item and\
			Input.is_action_pressed("ui_accept"):
		var n = load("res://item_spawner/%s.tscn" % item_type).instance()
		n.set_name("item")
		player.item = n
		player.add_child(n)
		if not inventory.is_empty():
			inventory.move_item_to(0, player.get_node("inventory"))
		
		

func _on_pick_area_area_enter( area ):
	
	if area.get_name() == PLAYER_AREA_NAME:
		_is_there_a_player = true

func _on_pick_area_area_exit( area ):
	
	if area.get_name() == PLAYER_AREA_NAME:
		_is_there_a_player = false
