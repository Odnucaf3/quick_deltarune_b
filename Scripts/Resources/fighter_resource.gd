extends Resource
class_name Fighter_Resource
enum FIGHTER_CLASS{EVERYONE, WARRIOR, MAGICIAN, PRIEST}
#-------------------------------------------------------------------------------
@export_category("Fighter Stats")
@export var myFIGHTER_CLASS: FIGHTER_CLASS = FIGHTER_CLASS.WARRIOR
#-------------------------------------------------------------------------------
@export_category("Base Stats")
@export var max_hp: int = 100
@export var physical_attack: int = 10
@export var physical_defense: int = 10
@export var magical_attack: int = 10
@export var magical_defense: int = 10
@export var luck: int = 10
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
@export var guard_effect: int = 50
@export var recovery_effect: int = 0
@export var pharmacology: int = 0
@export var tp_cost_rate: int = 0
@export var tp_charge_rate: int = 0
@export var tp_recovery: int = 0
@export var hp_recovery: int = 0
#-------------------------------------------------------------------------------
@export_category("Elemental Rates")
@export var normal: Vector4i = Vector4i(100, 100, 0, 0)
@export var water: Vector4i = Vector4i(100, 100, 0, 0)
@export var fire: Vector4i = Vector4i(100, 100, 0, 0)
@export var earth: Vector4i = Vector4i(100, 100, 0, 0)
@export var wind: Vector4i = Vector4i(100, 100, 0, 0)
@export var ice: Vector4i = Vector4i(100, 100, 0, 0)
@export var thunder: Vector4i = Vector4i(100, 100, 0, 0)
@export var light: Vector4i = Vector4i(100, 100, 0, 0)
@export var dark: Vector4i = Vector4i(100, 100, 0, 0)
#-------------------------------------------------------------------------------
@export_category("Equip Slots")
@export var equip_type_array: Array[Equip_Resource.EQUIP_TYPE] = [
	Equip_Resource.EQUIP_TYPE.WEAPON,
	Equip_Resource.EQUIP_TYPE.HEAD,
	Equip_Resource.EQUIP_TYPE.BODY,
	Equip_Resource.EQUIP_TYPE.RING,
	Equip_Resource.EQUIP_TYPE.RING,
	Equip_Resource.EQUIP_TYPE.RING,
	Equip_Resource.EQUIP_TYPE.RING
]
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
