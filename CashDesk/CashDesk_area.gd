extends Area2D

var inventory

func _ready():
	
	inventory = get_node("inventory")


func _on_CashDesk_area_area_enter( area ):
	
	if area.get_name() == "player_area":
		pass
	if area.get_name() == "pushing_area":
		get_node("Timer").start()

func _check():
	if !system.trolley.inventory.is_empty():
		system.trolley.inventory.move_item_to(0, inventory)

func _on_Timer_timeout():
	
	_check()

func _on_CashDesk_area_area_exit( area ):
	if area.get_name() == "player_area":
		pass
	if area.get_name() == "pushing_area":
		get_node("Timer").stop()
