extends Node2D
#-------------------------------------------------------------------------------
@export var room_root: Room_Script
#-------------------------------------------------------------------------------
@export var interactable: Interactable_Script
@export var character_node: Character_Node
@export var fighter_resouce: Fighter_Resource
@export var fighter_prefab: PackedScene
#-------------------------------------------------------------------------------
func _ready() -> void:
	Set_NPC(interactable, character_node, fighter_resouce, fighter_prefab)
#-------------------------------------------------------------------------------
func Set_NPC(_interactable:Interactable_Script, _character_node:Character_Node, _fighter_resource:Fighter_Resource, _fighter_prefab:PackedScene):
	var _index: int = singleton.game_system.Get_Fighter_Node_Index(_fighter_resource)	#Si te da -1 significa que no está ese peleador en la matríz.
	#-------------------------------------------------------------------------------
	if(_index < 0):
		_character_node.modulate.a = 1.0
	#-------------------------------------------------------------------------------
	else:
		_character_node.modulate.a = 105.0/255.0
	#-------------------------------------------------------------------------------
	_interactable.interactable_by_action = func(): Interaction(_interactable, _character_node, _fighter_resource, _fighter_prefab)
#-------------------------------------------------------------------------------
func Interaction(_interactable:Interactable_Script, _character_node:Character_Node, _fighter_resource:Fighter_Resource, _fighter_prefab:PackedScene):
	singleton.game_system.Dialogue_Enter_and_Open()
	#-------------------------------------------------------------------------------
	var _player_1_character_resource: Character_Resource = singleton.game_system.ally_character_party[0].character_resource
	#-------------------------------------------------------------------------------
	var _index: int = singleton.game_system.Get_Fighter_Node_Index(_fighter_resource)
	#-------------------------------------------------------------------------------
	if(_index < 0):
		await singleton.game_system.Dialogue_with_Face_with_Options(_character_node.character_resource, "* Querés que te acompañe?", ["Si", "No"])
		#-------------------------------------------------------------------------------
		match(singleton.game_system.dialogue_option_index):
			0:
				await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* Ok, voy a ir con vos.")
				#-------------------------------------------------------------------------------
				var _fighter_ally_1: Fighter_Node = _fighter_prefab.instantiate() as Fighter_Node
				singleton.game_system.player_characterbody2d.add_child(_fighter_ally_1)
				singleton.game_system.ally_fighter_party.append(_fighter_ally_1)
				singleton.game_system.Set_Equip(_fighter_ally_1.fighter_serializable)
				_fighter_ally_1.hide()
				singleton.game_system.Set_Fighter_0()
				_character_node.modulate.a = 105.0/255.0
			#-------------------------------------------------------------------------------
			1:
				await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* Ok, voy a estar acá si me necesitas.")
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		await singleton.game_system.Dialogue_Close_and_Exit()
	#-------------------------------------------------------------------------------
	else:
		await singleton.game_system.Dialogue_with_Face_with_Options(_character_node.character_resource, "* Querés que me vaya del grupo?", ["Si", "No"])
		#-------------------------------------------------------------------------------
		match(singleton.game_system.dialogue_option_index):
			0:
				#-------------------------------------------------------------------------------
				if(singleton.game_system.ally_fighter_party.size() > 1):
					await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* Ok, voy a estar acá si me necesitas.")
					#-------------------------------------------------------------------------------
					singleton.game_system.ally_fighter_party[_index].queue_free()
					singleton.game_system.ally_fighter_party.remove_at(_index)
					singleton.game_system.Set_Fighter_0()
					_character_node.modulate.a = 1.0
				#-------------------------------------------------------------------------------
				else:
					await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* No podés tener cero aliados en tu equipo.")
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			1:
				await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* Ok, sigo con vos.")
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		await singleton.game_system.Dialogue_Close_and_Exit()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
