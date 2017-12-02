extends KinematicBody2D

var weight = 1
var max_speed = 500
var acc = 200
var speed = 500
var player_in_area = false
var player_is_connected = false
onready var player = get_parent().get_node("player")
var pl_pos

func _ready():
	set_process_input(true)
	set_process(true)
var old_space = false
var space_changed = false
func _process(delta):
	var space_just_pressed = false
	if space_key==false and old_space==true:
		space_just_pressed = true
	if space_just_pressed and player_in_area:
		if player_is_connected:
			remove_collision_exception_with(player)
			remove_player_collision()
		else:
			add_collision_exception_with(player)
			add_player_collision()
		player_is_connected = !player_is_connected
	
	if player_is_connected:
		pl_pos = player.get_pos() - get_pos()
		var mov = Vector2()
		if Input.is_action_pressed("ui_up"):
			mov.y -= speed
		if Input.is_action_pressed("ui_down"):
			mov.y += speed
		if Input.is_action_pressed("ui_left"):
			mov.x -= speed
		if Input.is_action_pressed("ui_right"):
			mov.x += speed
			
		move(mov * delta)
		if is_colliding():
			var n = get_collision_normal()
			mov = n.slide(mov * delta)
			move(mov)
		player.set_pos(pl_pos + get_pos())
	old_space = space_key
func _on_pushing_area_area_enter( area ):
	if area.get_name() == "player_area":
		player_in_area = true
		set_process(true)

func _on_pushing_area_area_exit( area ):
	if area.get_name() == "player_area":
		player_in_area = false

func add_player_collision():
	
	var shape = player.get_node("CollisionShape2D")
	var c = get_shape_count()
	add_shape(shape.get_shape(), Matrix32(0, player.get_pos()-get_pos()))

func remove_player_collision():
	
	remove_shape(get_shape_count()-1)
var space_key = false
var prev = false
func _input(event):
#	print("gsfddsa")
	if event.type == InputEvent.KEY:
		if event.is_action("ui_accept"):
#			var cur = event.is_pressed()
#			prints("%s - %s - %s" % [prev, space_key, cur])
#			if prev==true and cur==false:
#				space_key = true
#				if space_key == true:
#					assert(cur == false)
#			else:
#				space_key = false
#			if space_key == true:
#				assert(cur == false)
#			prev = cur
			if event.is_pressed():
				space_key = true
			else:
				space_key = false