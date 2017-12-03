extends KinematicBody2D

var weight = 1
const WEIGHT_FACTOR = 2
var max_speed = 500
var acc = 500
var dcc = 0.08
var speed = 0
var player_in_area = false
var player_is_connected = false
onready var player = get_parent().get_node("player")
var pl_pos
var space_just_pressed = false
var items = []
var velocity = Vector2()

func _ready():
	set_process_input(true)
	set_process(true)
var old_space = false
var space_changed = false

func _process(delta):
	space_just_pressed = false
	if space_key==false and old_space==true:
		space_just_pressed = true
	if space_just_pressed and player_in_area and not player.item:
		if player_is_connected:
			remove_collision_exception_with(player)
			remove_player_collision()
		else:
			add_collision_exception_with(player)
			add_player_collision()
		player_is_connected = !player_is_connected
	elif player.item != null and space_just_pressed and player_in_area:
		items.append(player.item)
		player.item = null
		var i = player.get_node("item")
		player.remove_child(i)
		var p = i.get_pos()
		p.y -= (items.size() + randi() % 5) - 30
		p.x += (randi() % 20) - 10
		i.set_pos(p)
		get_node("bucket").add_child(i)
		weight += i.weight
	
	var mov = Vector2()
	pl_pos = player.get_pos() - get_pos()
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
		
	move(velocity * delta)
	if is_colliding():
		var n = get_collision_normal()
#			velocity = velocity.normalized() * -0.5 * velocity
		velocity = n.slide(mov * delta)
		mov = n.slide(mov * delta)
		move(mov)
	if player_is_connected:
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
			if event.is_pressed():
				space_key = true
			else:
				space_key = false