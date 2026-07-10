extends Resource
class_name Equip_Serializable
#-------------------------------------------------------------------------------
@export var equip_resource: Equip_Resource
@export var myEQUIP_TYPE: Equip_Resource.EQUIP_TYPE
@export var stored: int = 1
#-------------------------------------------------------------------------------
var skill_serializable_array: Array[Action_Serializable]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
