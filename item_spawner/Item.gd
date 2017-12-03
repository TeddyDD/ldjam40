extends Sprite

var weight = 10

var player = null
var vel = Vector2()
func _ready():
	set_process(true)
var force_ = 0
var flies = false

func _process(delta):
	if player != null:
		if Input.is_action_pressed("ui_accept") and player.item == null:
			assert(player)
			player.item = self
			get_tree().get_root().get_node("game").reparent(self, player)
			# fix that horrible hack
			set_pos(Vector2(-0.858559,-25.1127))
	if flies:
		var nt_pos = ((get_pos() + vel * delta).snapped(Vector2(64, 64))/Vector2(64, 64))
		var next_tile_id = get_node("/root/game/TileMap").get_cellv(nt_pos)
		print(next_tile_id)
		if not ( next_tile_id in [1, 2] ):
			set_pos(get_pos() + vel * delta)# +Vector2(0, 32)
		else:
			vel = Vector2()
#			set_pos((get_pos() + vel * delta).snapped(Vector2(64, 64))/Vector2(64, 64))
			flies = false
func throw(direction, force=null):
	var pos = get_global_pos()
	flies = true
	get_tree().get_root().get_node("game").reparent(self, get_node("/root/game"))
	set_global_pos(pos)
	var force_ = 1000
	if force:
		force_ = force
	vel = direction.normalized() * force_

func _on_damage_area_area_enter( area ):
	if area.get_name() == "player_area":
		if area extends PhysicsBody:
			get_node("damage_area1").add_collision_exception_with(area)
		player = area.get_parent()
	## else janusz -> zadaj srogi damage

func _on_damage_area_area_exit( area ):
	if area.get_name() == "player_area":
		player = null
		if area extends PhysicsBody:
			get_node("damage_area1").remove_collision_exception_with(area)
