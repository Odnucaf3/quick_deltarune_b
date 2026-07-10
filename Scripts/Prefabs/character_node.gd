extends Node2D
class_name Character_Node
#-------------------------------------------------------------------------------
@export var character_resource: Character_Resource
@export var animation_tree: AnimationTree
@export var pivot: Node2D
#-------------------------------------------------------------------------------
var is_Facing_Left: bool = false
var is_Moving: bool = false
