extends KinematicBody2D
var DROP_ITEM_SPEED = 3
var weight = 1
const WEIGHT_FACTOR = 2
var max_speed = 500
var acc = 500
var dcc = 0.08
var player_in_area = false
var player_is_connected = false
onready var player = system.player
var player_delta_pos
var space_just_pressed = false
var items = []
var velocity = Vector2()

var inventory

func _ready():
	inventory = get_node("inventory")
	set_process_input(true)
	set_process(true)

var old_space = false

func _process(delta):
	
	_input_space_key()
	if space_just_pressed and\
			player_in_area and\
			player.inventory.is_empty():
		if player_is_connected:
			remove_player_collision()
		else:
			add_player_collision()
		player_is_connected = !player_is_connected
	elif not player.inventory.is_empty()\
			and space_just_pressed\
			and player_in_area:
		if not inventory.is_full():
			player.inventory.items[0].deactivate()
			player.inventory.move_item_to(0,inventory)
		weight += inventory.items.back().weight
		inventory.items.back().deactivate()
	var mov = Vector2()
	player_delta_pos = player.get_pos() - get_pos()
	if player_is_connected:
		var input_ = false
		if Input.is_action_pressed("ui_up"):
			velocity.y -= acc * delta
			input_ = true
		if Input.is_action_pressed("ui_down"):
			velocity.y += acc * delta
			input_ = true
		if Input.is_action_pressed("ui_left"):
			velocity.x -= acc * delta
			input_ = true
		if Input.is_action_pressed("ui_right"):
			velocity.x += acc * delta
			input_ = true
		if !input_:
			if velocity.length() < 50:
				velocity = Vector2()
			if velocity.length() - dcc >= 10:
				velocity -= velocity * dcc/8
	else:
		if velocity.length() < 50:
			velocity = Vector2()
		if velocity.length() - dcc >= 10:
			velocity -= velocity * dcc/8
	if velocity.length() - weight/WEIGHT_FACTOR > 0:
		velocity = velocity.clamped(velocity.length() - weight/WEIGHT_FACTOR)
	if player_is_connected:
		if velocity.length() >= max_speed:
			velocity.clamped(max_speed)
		
	var motion_left = move(velocity * delta)
	if is_colliding():
		var n = get_collision_normal()
		velocity = n.slide(mov * delta)
		mov = n.slide(mov * delta)
		var coll = get_collider()
		if coll:
			if coll extends TileMap:
				var c_pos = get_collision_pos()
#				var c_mov = move(mov)
				var c_mov = motion_left
				revert_motion()
#				move(-get_travel())
				var pos__ = Vector2(round((c_pos+c_mov).x/64),
						round((c_pos+c_mov).y/64))
				var fix = Vector2()
				if motion_left.x < 0:
					fix += Vector2(-1, 0)
				if motion_left.y < 0:
					fix += Vector2(0, -1)
				var id_of_tile = coll.get_cellv(pos__ + fix)
				var name_of_tile = coll.get_tileset().tile_get_name(id_of_tile)
				if name_of_tile in ["wall", "shelf"]:
					if motion_left.length() > DROP_ITEM_SPEED and not inventory.is_empty():
						drop_item(motion_left)
		move(mov)
	if player_is_connected:
		player.set_pos(player_delta_pos + get_pos())
	old_space = space_key
func _on_pushing_area_area_enter( area ):
	if area.get_name() == "player_area":
		player_in_area = true
		set_process(true)

func drop_item(motion_left):
	prints("DROOOP")
	if not inventory.is_empty():
		var i = randi() % inventory.items.size()
		var item = inventory.items[i]
		item.activate()
		inventory.drop_item(i)
		item.throw(motion_left)
#	if get_child_count() > 0:
#		var i = randi()%items.size()
#		var n = get_node("bucket").get_child(i)
#		var old_p = n.get_global_pos()
#		system.reparent(n, get_node("/root/game/YSort"))
#		n.set_global_pos(old_p)
#		n.throw(motion_left*5)
#		items.remove(i)
#		
		
		
func _on_pushing_area_area_exit( area ):
	if area.get_name() == "player_area":
		player_in_area = false

func add_player_collision():
	
	add_collision_exception_with(player)
	var shape = player.get_node("CollisionShape2D")
	var c = get_shape_count()
	add_shape(shape.get_shape(), Matrix32(0, player.get_pos()-get_pos()))

func remove_player_collision():
	
	remove_collision_exception_with(player)
	remove_shape(get_shape_count()-1)
var space_key = false
var prev = false
func _input_space_key():
	space_just_pressed = false
	if space_key==false and old_space==true:
		space_just_pressed = true

func _input(event):

	if event.type == InputEvent.KEY:
		if event.is_action("ui_accept"):
			if event.is_pressed():
				space_key = true
			else:
				space_key = false