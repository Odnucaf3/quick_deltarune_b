extends Resource
class_name Status_Serializable
#-------------------------------------------------------------------------------
@export var status_resource:Status_Resource
var skill_serializable_array: Array[Action_Serializable]
@export var turns: int
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
