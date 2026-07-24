extends Resource
class_name Status_Resource
#-------------------------------------------------------------------------------
@export_category("Status Stats")
@export var icon: Texture2D
@export var is_infinite: bool = false
@export var max_turns: int = 1
#-------------------------------------------------------------------------------
@export_category("Base Stats")
@export var max_hp: int = 0
@export var physical_attack: int = 0
@export var physical_defense: int = 0
@export var magical_attack: int = 0
@export var magical_defense: int = 0
@export var luck: int = 0
#-------------------------------------------------------------------------------
@export_category("Extra Stats")
@export var physical_presition_rate: int = 0
@export var physical_evasion_rate: int = 0
@export var magical_presition_rate: int = 0
@export var magical_evasion_rate: int = 0
@export var critical_presition_rate: int = 0
@export var critical_evasion_rate: int = 0
#-------------------------------------------------------------------------------
@export_category("Special Stats")
@export var target_rate: int = 0
@export var guard_effect: int = 0
@export var recovery_effect: int = 0
@export var pharmacology: int = 0
@export var tp_cost_rate: int = 0
@export var tp_charge_rate: int = 0
@export var tp_recovery: int = 0
@export var hp_recovery: int = 0
#-------------------------------------------------------------------------------
@export_category("Elemental Rates")
@export var normal: Vector4i = Vector4i(0, 0, 0, 0)
@export var water: Vector4i = Vector4i(0, 0, 0, 0)
@export var fire: Vector4i = Vector4i(0, 0, 0, 0)
@export var earth: Vector4i = Vector4i(0, 0, 0, 0)
@export var wind: Vector4i = Vector4i(0, 0, 0, 0)
@export var ice: Vector4i = Vector4i(0, 0, 0, 0)
@export var thunder: Vector4i = Vector4i(0, 0, 0, 0)
@export var light: Vector4i = Vector4i(0, 0, 0, 0)
@export var dark: Vector4i = Vector4i(0, 0, 0, 0)
#-------------------------------------------------------------------------------
@export_category("Status Effect Resistances")
@export var status_resistance_dictionary: Dictionary[StringName, int]
#-------------------------------------------------------------------------------
@export_category("Skills")
@export var skill_resource_array: Array[Action_Resource]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
