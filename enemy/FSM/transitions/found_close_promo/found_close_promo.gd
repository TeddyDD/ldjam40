tool
extends "res://addons/net.kivano.fsm/content/FSMTransition.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
# All params are optional and will be used only if you decide to manually initialize FSM (fsm.init())
# or update manually (fsm.update(deltaTime))
#
# You can also use accomplish() method on this transition to mark it as accomplised until next related 
# state activation (you can use it from code, or connect some signals to accomplish() method)

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################

######################################
####### Getters
func getFSM(): return fsm; #access to owner FSM, defined in parent class
func getLogicRoot(): return logicRoot; #access to logic root of FSM (usually fsm.get_parent())

######################################
####### Implement those below ########
func transitionInit(inParam1=null, inParam2=null, inParam3=null, inParam4=null, inParam5=null): 
	#you can optionally implement this to initialize transition on it's creation time 
	pass

func prepare(inNewStateID): 
	#you can optionally implement this to reset transition when related state has been activated
	pass

func transitionCondition(inDeltaTime, inParam0=null, inParam1=null, inParam2=null, inParam3=null, inParam4=null): 
	var i = 0
	var tglst = getLogicRoot().taget_list
	if tglst != []:
		if tglst.size() > 1:
			for t in tglst:
				if t.is_in_group("item"):
					break
				if t.inventory.is_empty():
					i += 1
				else: break
#			# ignore player without items
#			if tglst[i].get_name() == "player":
#				if tglst[i].inventory.is_empty():
#					i += 1
#			# ignore empty trolley
#			if tglst[i].get_name() == "Trolley":
#				if tglst[i].inventory.is_empty():
#					i += 1
#			# ignore promotion when there is no items left
#			if tglst[i].is_in_group("spawner"):
#				if tglst[i].inventory.is_empty():
#					i += 1
#			if i >= tglst.size():
#				return false
		if getLogicRoot().taget_list[i] != null:
			getLogicRoot().target = getLogicRoot().taget_list[i]
			return true
	return false





