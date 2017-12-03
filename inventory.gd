extends Node2D

export var capacity = 1 # -1 = infinity
var items = []

func is_full():
	if capacity == -1:
		return false
	return items.size() >= capacity

func is_empty():
	return items.empty()

# move item to another inventory
func move_item_to(id, inventory):
	prints("moving from %s to %s" % [self, inventory])
	var item = items[id]
	remove_child(item)
	inventory.add_item(item)
	items.erase(item)
	
# move item to ground
func drop_item(id=0):
	var item = items[id]
	var pos = item.get_global_pos() - item.get_pos()
	system.reparent(item, system.map_ysort)
	item.set_global_pos(pos)
	items.erase(item)
	
func pick_up(item):
	system.reparent(item, self)
	item.set_pos(Vector2())
	set_rand_pos(item)
	items.append(item)
	
func add_item(item):
	items.append(item)
	set_rand_pos(item)
	add_child(item)
	
func set_rand_pos(item):
	var p = item.get_pos()
	p.y -= (items.size() + randi() % 5)
	p.x += (randi() % 20) - 10
	item.set_pos(p)
