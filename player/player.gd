extends KinematicBody2D

const speed = 250
var mov = Vector2()
onready var trolley = system.trolley
var item = null
var inventory
onready var anim = get_node("AnimationPlayer")
var prev_anim = "idle"



func _ready():
	anim.play("idle")
	inventory = get_node("inventory")
	set_process(true)
	
func _process(delta):
	var new_anim = prev_anim
	if mov == Vector2():
		new_anim = "idle"
	elif abs(mov.x) > abs(mov.y):
		if mov.x < 0:
			new_anim = "right"
		else: new_anim = "left"
	else:
		if mov.y > 0:
			new_anim = "down"
		else: new_anim = "up"
	if new_anim != prev_anim:
		anim.play(new_anim)
	prev_anim = new_anim
	
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
	if Input.is_action_pressed("throw") and not inventory.is_empty():
#		var p = item.get_global_pos()
#		remove_child(item)
#		get_parent().add_child(item)
#		item.set_global_pos(p)
		var i = inventory.items.front()
		i.activate()
		inventory.drop_item(0)
		i.throw(mov)
#		item.throw(mov)
#		item = null

	
	
	move(mov * delta)
	system.slide_body(self, mov, delta)
