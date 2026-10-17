extends Resource
class_name Equip_Slot_Serializable
#-------------------------------------------------------------------------------
@export var equip_resource: Equip_Resource
var myEQUIPTYPE: Equip_Resource.EQUIP_TYPE
#-------------------------------------------------------------------------------
var skill_serializable_array: Array[Action_Serializable]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
