extends Resource
class_name Action_Resource
#-------------------------------------------------------------------------------
enum ATRIBUTE{PHYSICAL, MAGICAL}
enum ELEMENT{NORMAL, WATER, FIRE, EARTH, WIND, ICE, THUNDER, LIGHT, DARK}
enum EFFECT{DAMAGE, HEAL}
enum TARGET{ENEMY_1, ENEMY_RANDOM, ENEMY_ALL, ALLY_1, ALLY_RANDOM, ALLY_ALL, USER, ALLY_DOWN_1, ALLY_DOWN_ALL}
#-------------------------------------------------------------------------------
@export_category("Action Stats")
@export var max_hold: int
var max_stored: int = 99
@export_range(0, 100) var tp_cost: int
@export var max_cooldown: int
@export var price: int
#-------------------------------------------------------------------------------
@export_category("Action Effect")
@export var speed: int = 0
@export var presition: int = 100
@export var value: int
@export var myEFFECT: EFFECT
@export var myATRIBUTE: ATRIBUTE
@export var myELEMENT: ELEMENT
#-------------------------------------------------------------------------------
@export_category("Action Target")
@export var myTARGET: TARGET
@export_range(1, 4) var repeat: int = 1
#-------------------------------------------------------------------------------
@export_category("Status Effect Rate")
@export var status_dictionary: Dictionary[StringName, int]
#-------------------------------------------------------------------------------
func _init():
	resource_local_to_scene = false
#-------------------------------------------------------------------------------
