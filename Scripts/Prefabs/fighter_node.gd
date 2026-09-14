extends Node2D
class_name Fighter_Node
#-------------------------------------------------------------------------------
@export var character_resource: Character_Resource
var fighter_ui: Fighter_UI
@export var fighter_serializable: Fighter_Serializable
var fighter_serializable_in_battle: Fighter_Serializable
#-------------------------------------------------------------------------------
@export var animation_tree: AnimationTree
@export var pivot: Node2D
#-------------------------------------------------------------------------------
# This is used for skills to infor who are ally and who are enemies
var action_serializable: Action_Serializable
var user_party: Array[Fighter_Node]
var target: Fighter_Node
var opponent_party: Array[Fighter_Node]
#-------------------------------------------------------------------------------
var pop_up_array: Array[Pop_Up_Node]
#-------------------------------------------------------------------------------
var is_facing_left: bool = false
