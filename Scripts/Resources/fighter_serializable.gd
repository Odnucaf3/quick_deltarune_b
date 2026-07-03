extends Resource
class_name Fighter_Serializable
#-------------------------------------------------------------------------------
@export var fighter_resource: Fighter_Resource
var hp: int
@export var level: int = 1
@export var experience: int = 0
#-------------------------------------------------------------------------------
@export var equip_serializable_array: Array[Equip_Serializable]
var skill_serializable_array: Array[Action_Serializable]
@export var status_serializable_array: Array[Status_Serializable]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
