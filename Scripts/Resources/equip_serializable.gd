extends Resource
class_name Equip_Serializable
#-------------------------------------------------------------------------------
@export var equip_resource: Equip_Resource
@export var stored: int = 1
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
