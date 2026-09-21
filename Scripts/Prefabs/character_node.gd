extends Node2D
class_name Character_Node
#-------------------------------------------------------------------------------
@export var character_resource: Character_Resource
@export var animation_tree: AnimationTree
@export var pivot: Node2D
#-------------------------------------------------------------------------------
const base_statemachine: StringName = "base_StateMachine"
const locomotion: StringName = base_statemachine+"/locomotion"
#-------------------------------------------------------------------------------
var input_anim_idle: Vector2
var input_anim_move: Vector2
#-------------------------------------------------------------------------------
