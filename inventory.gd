extends Node2D

export var capacity = 1 # -1 = infinity
var items = []

func can_add_item():
	if capacity == -1:
		return true
	return items.size() < capacity

func is_empty():
	return items.empty()

# move item to another inventory
func move_item_to(id, inventory):
	var item = items[id]
	remove_child(item)
	inventory.add_item(item)
	items.erase(item)
	
# move item to ground
func drop_item(id=0):
	var item = items[id]
	remove_child(item)
	
	items.erase(item)
	
	
func add_item(item):
	items.append(item)
	var p = item.get_pos()
	p.y -= (items.size() + randi() % 5) - 30
	p.x += (randi() % 20) - 10
	item.set_pos(p)
	add_child(item)
	
