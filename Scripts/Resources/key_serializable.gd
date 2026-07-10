extends Resource
class_name Key_Serializable
#-------------------------------------------------------------------------------
@export var key_resource: Key_Resource
@export var stored: int = 1
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
