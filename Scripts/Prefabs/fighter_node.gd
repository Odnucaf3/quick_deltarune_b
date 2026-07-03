extends Node2D
class_name Fighter_Node
#-------------------------------------------------------------------------------
@export var fighter_serializable: Fighter_Serializable
@export var fighter_button: Fighter_Button
#-------------------------------------------------------------------------------
@export var animation_tree: AnimationTree
@export var pivot: Node2D
#-------------------------------------------------------------------------------
var is_Facing_Left: bool = false
var is_Moving: bool = false
