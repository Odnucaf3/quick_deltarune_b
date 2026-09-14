extends Resource
class_name Action_Resource
#-------------------------------------------------------------------------------
enum ATRIBUTE{NONE, PHYSICAL, MAGICAL}
enum ELEMENT{NONE, NORMAL, WATER, FIRE, EARTH, WIND, ICE, THUNDER, LIGHT, DARK}
enum EFFECT{NONE, DAMAGE, HEAL, DRAIN}
enum TARGET{ENEMY_1, ENEMY_RANDOM, ENEMY_ALL, ALLY_1, ALLY_RANDOM, ALLY_ALL, USER, ALLY_DOWN_1, ALLY_DOWN_ALL}
#-------------------------------------------------------------------------------
@export_category("Action Animations")
@export var animation_prefab: PackedScene
@export var animation_timer_1: float = 0.7
@export var animation_timer_2: float = 0
#-------------------------------------------------------------------------------
@export_category("Action Stats")
@export var icon: Texture2D
@export var max_hold: int
var max_stored: int = 99
@export_range(0, 100) var tp_cost: int
@export var max_cooldown: int
@export var price: int
#-------------------------------------------------------------------------------
@export_category("Action Effect")
@export var speed: int = 0
@export var presition: int = 100
@export var affinity: int = 100
@export var value: int
@export var myEFFECT: EFFECT
@export var myATRIBUTE: ATRIBUTE
@export var myELEMENT: ELEMENT
@export var can_critic: bool = false
#-------------------------------------------------------------------------------
@export_category("Action Target")
@export var myTARGET: TARGET
@export_range(1, 4) var repeat: int = 1
#-------------------------------------------------------------------------------
@export_category("Status Effect Rate")
@export var add_status_dictionary: Dictionary[StringName, int]
@export var remove_status_dictionary: Dictionary[StringName, int]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
