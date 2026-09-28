extends Resource
class_name Fighter_Serializable
#-------------------------------------------------------------------------------
@export var fighter_resource: Fighter_Resource
var hp: int
@export var level: int = 1
@export var experience: int = 0
#-------------------------------------------------------------------------------
@export var equip_weapon: Equip_Resource
@export var equip_shield: Equip_Resource
@export var equip_head: Equip_Resource
@export var equip_body: Equip_Resource
@export var equip_arms: Equip_Resource
@export var equip_legs: Equip_Resource
@export var equip_ring_1: Equip_Resource
@export var equip_ring_2: Equip_Resource
@export var equip_ring_3: Equip_Resource
@export var equip_ring_4: Equip_Resource
var equip_serializable_array: Array[Equip_Serializable]
#-------------------------------------------------------------------------------
var skill_serializable_array: Array[Action_Serializable]
#-------------------------------------------------------------------------------
@export var status_serializable_array: Array[Status_Serializable]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = true
#-------------------------------------------------------------------------------
