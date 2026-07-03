extends Resource
class_name Action_Serializable
#-------------------------------------------------------------------------------
@export var action_resource: Action_Resource
@export var cooldown: int
@export var hold: int
@export var stored: int
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
