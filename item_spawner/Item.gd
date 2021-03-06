extends Sprite

var weight = 1

var vel = Vector2()
var dcc = 25
var force_ = 0
var flies = false

var is_active = false
var player_is_close = false

func _ready():
	set_fixed_process(true)
	dcc *= weight
	deactivate()


func _fixed_process(delta):
	get_node("debug").set_text("flies: %s, acti: %s" % [flies, is_active])
	if player_is_close and is_active:
		if not system.player.inventory.is_full()\
				and Input.is_action_pressed("ui_accept"):
			deactivate()
			system.player.inventory.pick_up(self)
#	if player != null:
#		if Input.is_action_pressed("ui_accept") and player.item == null:
#			assert(player)
#			player.item = self
#			system.reparent(self, player)
			# fix that horrible hack
#			set_pos(Vector2(-0.858559,-25.1127))
	if flies:
		var nt_pos = ((get_pos() + vel * delta).snapped(Vector2(64, 64))/Vector2(64, 64))
		var next_tile_id = get_node("/root/game/Navigation2D/TileMap").get_cellv(nt_pos)
#		if not ( next_tile_id in [1, 2] ):
		if !get_node("KinematicBody2D").test_move(vel * delta):
			#if set_pos(get_pos() + vel * delta)
			set_pos(get_pos() + vel * delta)# +Vector2(0, 32)
		else:
			var d_ = get_node("KinematicBody2D").move(vel * delta)
			get_node("KinematicBody2D").revert_motion()
			set_pos(get_pos()+vel.normalized()*d_*delta)
			vel = Vector2()
#			set_pos((get_pos() + vel * delta).snapped(Vector2(64, 64))/Vector2(64, 64))
			end_throw()
		if vel.length() - dcc > 10:
			vel = vel.clamped(vel.length() - dcc)
		else:
			vel = Vector2()
			end_throw()

func activate():
	is_active = true
	print("act")
	get_node("KinematicBody2D").remove_collision_exception_with(system.trolley)
	system.trolley.remove_collision_exception_with(get_node("KinematicBody2D"))
	get_node("KinematicBody2D").add_collision_exception_with(system.player)
	system.player.add_collision_exception_with(get_node("KinematicBody2D"))

func deactivate():
	is_active = false
	print("deact")
	get_node("KinematicBody2D").add_collision_exception_with(system.trolley)
	system.trolley.add_collision_exception_with(get_node("KinematicBody2D"))
	#get_node("KinematicBody2D").remove_collision_exception_with(system.player)
	#system.player.remove_collision_exception_with(get_node("KinematicBody2D"))

func throw(direction, force=null):
	activate()
	add_to_group("target", true)
#	var pos = get_global_pos()
	flies = true
#	system.reparent(self, get_node("/root/game/YSort"))
#	set_global_pos(pos)
	var force_ = 1000
	if force:
		force_ = force
	vel = direction.normalized() * force_
	
func end_throw():
	flies = false

func _on_damage_area_area_enter( area ):
	if area.get_name() == "player_area":
		player_is_close = true
	## else janusz -> zadaj srogi damage

func _on_damage_area_area_exit( area ):
	if area.get_name() == "player_area":
		player_is_close = false
