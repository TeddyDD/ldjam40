extends "res://addons/net.kivano.fsm/content/FSMState.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################

var path = []
var current_point = 0
var taget_pos = Vector2()
var nav
var min_distance = 50
var speed = 200

##################################################################################
#########                       Getters and Setters                      #########
##################################################################################
#you will want to use those
func getFSM(): return fsm; #defined in parent class
func getLogicRoot(): return logicRoot; #defined in parent class 

##################################################################################
#########                 Implement those below ancestor                 #########
##################################################################################
#you can transmit parameters if fsm is initialized manually
func stateInit(inParam1=null,inParam2=null,inParam3=null,inParam4=null, inParam5=null): 
	pass

#when entering state, usually you will want to reset internal state here somehow
func enter(fromStateID=null, fromTransitionID=null, inArg0=null,inArg1=null, inArg2=null):
	taget_pos = getLogicRoot().target.get_global_pos()
	nav = get_node("/root/game/Navigation2D")
	path = Array(nav.get_simple_path(getLogicRoot().get_global_pos(),taget_pos, false))
#	path.invert()
	getLogicRoot().path = path
	for i in range(0, path.size()-1):
		path[i] += Vector2(32,32)
		

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	var mov = path[current_point] - getLogicRoot().get_global_pos()
	mov = mov.normalized() * speed
	getLogicRoot().move(mov * deltaTime)
	if getLogicRoot().is_colliding():
		var n = getLogicRoot().get_collision_normal()
		mov = n.slide(mov * deltaTime)
		getLogicRoot().move(mov)
	if getLogicRoot().get_global_pos().distance_to(path[current_point]) < min_distance:
		if path.size() > 1:
			path.pop_front()
	getLogicRoot().update()

#when exiting state
func exit(toState=null):
	pass

##################################################################################
#########                       Connected Signals                        #########
##################################################################################

##################################################################################
#########     Methods fired because of events (usually via Groups interface)  ####
##################################################################################

##################################################################################
#########                         Public Methods                         #########
##################################################################################

##################################################################################
#########                         Inner Methods                          #########
##################################################################################

##################################################################################
#########                         Inner Classes                          #########
##################################################################################
