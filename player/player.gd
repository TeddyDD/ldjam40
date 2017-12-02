extends KinematicBody2D

const speed = 250
var mov = Vector2()
onready var trolley = get_parent().get_node("Trolley")
var item = false

func _ready():
	set_process(true)
	
func _process(delta):
	
	if trolley.player_is_connected:
		add_collision_exception_with(trolley)
		return
	else:
		remove_collision_exception_with(trolley)
	mov = Vector2()
	if Input.is_action_pressed("ui_up"):
		mov.y -= speed
	if Input.is_action_pressed("ui_down"):
		mov.y += speed
	if Input.is_action_pressed("ui_left"):
		mov.x -= speed
	if Input.is_action_pressed("ui_right"):
		mov.x += speed
	if Input.is_action_pressed("throw") and item != null:
		var p = item.get_global_pos()
		remove_child(item)
		get_parent().add_child(item)
		item.set_global_pos(p)
		item.throw()
		item = null
	
	move(mov * delta)
	if is_colliding():
		var n = get_collision_normal()
		mov = n.slide(mov * delta)
		move(mov)
