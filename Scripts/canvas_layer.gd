extends CanvasLayer
class_name Main_CanvasLayer
#-------------------------------------------------------------------------------
@export var game_scene: Game_System
var nothing_cancel: Callable = func():pass
#-------------------------------------------------------------------------------
func _process(_delta: float) -> void:
	game_scene.Debug_Information()
	#-------------------------------------------------------------------------------
	game_scene.Set_SlowMotion()
	game_scene.Set_DebugInfo()
#-------------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	#-------------------------------------------------------------------------------
	if(Input.is_action_just_pressed("Input_Pause")):
		nothing_cancel.call()
		return
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
