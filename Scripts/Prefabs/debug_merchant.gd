extends Node2D
#-------------------------------------------------------------------------------
@export var room_root: Room_Script
#-------------------------------------------------------------------------------
@export var interactable: Interactable_Script
@export var character_node: Character_Node
@export var item_consumable_array: Array[Action_Serializable]
@export var item_equip_array: Array[Equip_Serializable]
@export var item_key_array: Array[Key_Serializable]
#-------------------------------------------------------------------------------
func _ready() -> void:
	interactable.interactable_by_action = func(): Interaction()
#-------------------------------------------------------------------------------
func Interaction():
	var _player_1_character_resource: Character_Resource = singleton.game_system.ally_character_party[0].character_resource
	#-------------------------------------------------------------------------------
	singleton.game_system.Dialogue_Enter_and_Open()
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue_with_Face_with_Options(character_node.character_resource, "* Hola Che. Vamos a pelear!", ["Comprar", "Hablar", "Irse"])
	#-------------------------------------------------------------------------------
	var _blablabla: String = "Bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_blablabla += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla."
	#-------------------------------------------------------------------------------
	match(singleton.game_system.dialogue_option_index):
		0:
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* Quiero Comprar.")
			await singleton.game_system.Dialogue_with_Face(character_node.character_resource, "* Ok, te muestro lo que tengo.")
			singleton.game_system.Dialogue_Close()
			await singleton.game_system.Open_Market(interactable.name, item_consumable_array, item_equip_array, item_key_array)
			#-------------------------------------------------------------------------------
			singleton.game_system.Dialogue_Open()
			await singleton.game_system.Dialogue_with_Face(character_node.character_resource, "* Gracias, vuelva Pronto.")
		#-------------------------------------------------------------------------------
		1:
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* Si. "+_blablabla)
			await singleton.game_system.Dialogue_with_Face(character_node.character_resource, "* Ok, pero ya no tengo ganas, asique ya fué.")
		#-------------------------------------------------------------------------------
		2:
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* No. "+_blablabla)
			await singleton.game_system.Dialogue_with_Face(character_node.character_resource, "* No? Ok, para la próxima.")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue_Close_and_Exit()
#-------------------------------------------------------------------------------
