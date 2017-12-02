extends Sprite

var weight = 10

var player = null

func _ready():
	set_process(true)

func _process(delta):
	if player != null:
		if Input.is_action_pressed("ui_accept") and player.item == null:
			assert(player)
			player.item = self
			get_tree().get_root().get_node("game").reparent(self, player)
			# fix that horrible hack
			set_pos(Vector2(-0.858559,-25.1127))

func throw(direction=null, force=null):
	pass

func _on_damage_area_area_enter( area ):
	if area.get_name() == "player_area":
		player = area.get_parent()
	## else janusz -> zadaj srogi damage

func _on_damage_area_area_exit( area ):
	if area.get_name() == "player_area":
		player = null
