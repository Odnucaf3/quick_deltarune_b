extends Sprite2D
class_name Hitbox_Node
#-------------------------------------------------------------------------------
@export var grazebox: Sprite2D
var grazebox_radius: float = 12
var hitbox_radius: float = 4
var can_be_hit: bool = true
@export var animation_tree: AnimationTree
#-------------------------------------------------------------------------------
#func _draw() -> void:
#	draw_circle(Vector2.ZERO, hitbox_radius/global_scale.x, Color.RED, false)
#	draw_circle(Vector2.ZERO, grazebox_radius/global_scale.x, Color.GREEN, false)
#-------------------------------------------------------------------------------
