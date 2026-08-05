extends Node2D
class_name Fighter_Node
#-------------------------------------------------------------------------------
var fighter_ui: Fighter_UI
@export var fighter_serializable: Fighter_Serializable
var fighter_serializable_in_battle: Fighter_Serializable
@export var character_node: Character_Node
#-------------------------------------------------------------------------------
# This is used for skills to infor who are ally and who are enemies
var action_serializable: Action_Serializable
var user_party: Array[Fighter_Node]
var target: Fighter_Node
var target_party: Array[Fighter_Node]
#-------------------------------------------------------------------------------
var position_history: Array[Vector2]
#-------------------------------------------------------------------------------
