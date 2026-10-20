extends Node2D
#-------------------------------------------------------------------------------
@export var interactable: Interactable_Script
#-------------------------------------------------------------------------------
func _ready() -> void:
	interactable.interactable_by_action = func(): Interaction()
#-------------------------------------------------------------------------------
func Interaction():
	singleton.game_system.Dialogue_Enter_and_Open()
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue("* Una luz extraña en la esquina de la habitación.")
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue_Close_and_Exit()
#-------------------------------------------------------------------------------
