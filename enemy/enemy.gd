extends KinematicBody2D

var target = null # node
var taget_list = []
var hit_by = null

var path = null
var close_to = null
var inventory
var state_time = 0
enum STATE {IDLE, FOLLOWING_TARGET, ON_GROUND, RUN_AWAY, ATTACK}
var state = STATE.IDLE

func _ready():
	inventory = get_node("inventory")
	set_process(true)
	change_state_to(STATE.IDLE)

func _process(delta):
	get_node("debug").set_text(str(state))
	process_state(state, delta)

func _draw():
	if path != null:
		for p in path:
			draw_circle(p-get_pos(), 12, Color(1,0,1))

class Sorter:
	var my_pos = Vector2()
	func _init(pos):
		self.my_pos = pos
	func sort_by_distance(a,b):
		return a.get_global_pos().distance_squared_to(self.my_pos) < \
		b.get_global_pos().distance_squared_to(self.my_pos)
		

func _on_hit_area_area_enter( area ):
	if area.get_parent().is_in_group("spawner"):
		prints("NEAR SPAWNER")
		close_to = area.get_parent()
	if area.is_in_group("item"):
		if area.get_parent().flies == true:
			hit_by = area.get_parent()
		elif area.get_parent().is_active == true:
			close_to = area.get_parent()
	if area.get_name() == "Crowd":
		queue_free()

func enter_state(i):
	state_time = 0
	if has_method("enter_state"+str(i)):
		call("enter_state"+str(i))
func exit_state(i):
	if has_method("exit_state"+str(i)):
		call("exit_state"+str(i))
func process_state(i, delta):
	state_time += delta
	print("process_state"+str(i))
	if has_method("process_state"+str(i)):
		call("process_state"+str(i), delta)
func change_state_to(i):
	exit_state(state)
	enter_state(i)
	state = i

func enter_state0(): # IDLE
	var t = get_tree().get_nodes_in_group("target")
	var s = Sorter.new(get_global_pos())
	t.sort_custom(s, "sort_by_distance")
	taget_list = t
func process_state0(d):
	if cond_fund_close_target():
		change_state_to(STATE.FOLLOWING_TARGET)
	if cond_is_hit():
		change_state_to(STATE.ON_GROUND)

var FOLLOWING_TARGET_path = []
var FOLLOWING_TARGET_current_point = 0
var FOLLOWING_TARGET_taget_pos = Vector2()
var FOLLOWING_TARGET_nav
var FOLLOWING_TARGET_min_distance = 50
var FOLLOWING_TARGET_speed = 200

func enter_state1(): # FOLLOWING_TARGET
	print("TARGET KURWA: ", target.get_name())
	FOLLOWING_TARGET_taget_pos = target.get_global_pos()
	FOLLOWING_TARGET_path = Array(system.nav.get_simple_path(get_global_pos(),FOLLOWING_TARGET_taget_pos, false))
#	path.invert()
	path = FOLLOWING_TARGET_path
	for i in range(0, FOLLOWING_TARGET_path.size()):
		FOLLOWING_TARGET_path[i] += Vector2(32,32)
func process_state1(d):
	print("PROCESUJEMY TARGET KURWA: ", target.get_name())
	var mov = FOLLOWING_TARGET_path[FOLLOWING_TARGET_current_point] - get_global_pos()
	var old = get_global_pos()
	move_to(FOLLOWING_TARGET_path[0])
	var new = get_global_pos()
	revert_motion()
	mov = (new - old).normalized() * FOLLOWING_TARGET_speed
	print ("TRUE MOV GHERAR, ", mov)
#	mov = mov.normalized() * FOLLOWING_TARGET_speed
	move(mov * d)
	if is_colliding():
		var n = get_collision_normal()
		mov = n.slide(mov * d)
		move(mov*d)
	if get_global_pos().distance_to(FOLLOWING_TARGET_path[FOLLOWING_TARGET_current_point]) < FOLLOWING_TARGET_min_distance:
		if FOLLOWING_TARGET_path.size() > 1:
			FOLLOWING_TARGET_path.pop_front()
	update()
	
	if cond_is_hit():
		change_state_to(STATE.ON_GROUND)
	if cond_3s_passed():
		change_state_to(STATE.FOLLOWING_TARGET)
#	if close_to:
	print(target)
	print(target)
	print(target)
	print(target)
	print(target)
	print(target)
	print("CLOSE ", close_to)
	if target != null and target.is_in_group("exit"):
		return
	if close_to != null and cond_fund_close_target()\
			and cond_no_have_item():
		print("changed again")
		change_state_to(STATE.ATTACK)

func enter_state4(): # ATTACK
	if close_to.is_in_group("item"):
		inventory.pick_up(close_to)
	elif close_to.is_in_group("spawner"):
		if not close_to.inventory.is_empty():
			close_to.inventory.move_item_to(0, inventory)
	target = get_tree().get_nodes_in_group("exit")[0]
	change_state_to(STATE.FOLLOWING_TARGET)
func process_state4(d):
	target = get_tree().get_nodes_in_group("exit")[0]
	change_state_to(STATE.FOLLOWING_TARGET)
func cond_fund_close_target():
	var i = 0
	var tglst = taget_list
	if tglst != []:
		if tglst.size() > 1:
			for t in tglst:
				if t.is_in_group("item"):
					break
				if t.inventory.is_empty():
					i += 1
				else: break
		if taget_list[i] != null:
			target = taget_list[i]
			return true
	return false

func cond_is_hit():
	if hit_by != null:
		prints("hit")
		return true
	return false;

func cond_3s_passed():
	if state_time > 3:
		return true
	return false

func cond_close_to_target():
	if close_to != null:
		return true
	return false

func cond_have_item():
	return not inventory.is_empty()

func cond_no_have_item():
	return inventory.is_empty()
