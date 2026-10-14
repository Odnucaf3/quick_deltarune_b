extends Resource
class_name Action_Resource
#-------------------------------------------------------------------------------
enum ACTION_TYPE{NORMAL, CUSTOM}
enum ATRIBUTE{NONE, PHYSICAL, MAGICAL}
enum ANIMATION_BEFORE_ACTION{NONE, CHARGE, CAST, GUARD}
enum ANIMATION_DURING_ACTION{NONE, WEAPON, CAST}
enum ACTION_ANIMATION_TYPE{ON_TARGET, ON_PARTY, ON_CENTER}
enum ELEMENT{NONE, NORMAL, WATER, FIRE, EARTH, WIND, ICE, THUNDER, LIGHT, DARK}
enum EFFECT{NONE, DAMAGE, HEAL, DRAIN}
enum VALUE_TYPE{POINTS, PERCENTAGE}
enum TARGET{ENEMY_1, ENEMY_RANDOM, ENEMY_ALL, ALLY_1, ALLY_RANDOM, ALLY_ALL, USER, ALLY_DOWN_1, ALLY_DOWN_ALL}
#-------------------------------------------------------------------------------
@export var icon: Texture2D
#-------------------------------------------------------------------------------
@export_category("Action Animations")
@export var myACTION_TYPE: ACTION_TYPE
@export var animation_prefab: PackedScene
@export var myACTION_ANIMATION_TYPE: ACTION_ANIMATION_TYPE
@export var myANIMATION_BEFORE_ACTION: ANIMATION_BEFORE_ACTION
@export var myANIMATION_DURING_ACTION: ANIMATION_DURING_ACTION
@export var animation_timer_1: float = 0.7
@export var animation_timer_2: float = 0
#-------------------------------------------------------------------------------
@export_category("Action Variables")
@export var max_hold: int
var max_stored: int = 99
@export_range(0, 100) var tp_cost: int
@export var max_cooldown: int
@export var price: int
#-------------------------------------------------------------------------------
@export_category("Action Stats")
@export var speed: int = 0
@export var can_critic: bool = false
#-------------------------------------------------------------------------------
@export_category("Action Properties")
@export var value: int
@export var myVALUE_TYPE: VALUE_TYPE = VALUE_TYPE.POINTS
@export var myEFFECT: EFFECT
#-------------------------------------------------------------------------------
@export_category("Action Atribute")
@export var myATRIBUTE: ATRIBUTE
@export var presition: int = 100
#-------------------------------------------------------------------------------
@export_category("Action Element")
@export var myELEMENT: ELEMENT
@export var affinity: int = 100
#-------------------------------------------------------------------------------
@export_category("Action Target")
@export var myTARGET: TARGET
@export_range(1, 4) var repeat: int = 1
#-------------------------------------------------------------------------------
@export_category("Status Effect Rate")
@export var must_have_status_to_use_action: bool = false
@export var remove_status_dictionary: Dictionary[StringName, int]
@export var add_status_dictionary: Dictionary[StringName, int]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
