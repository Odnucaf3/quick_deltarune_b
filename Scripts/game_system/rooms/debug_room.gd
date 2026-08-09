extends Room_Script
#-------------------------------------------------------------------------------
@export_category("Ally 0")
@export var ally_0: Interactable_Script
@export var ally_0_character: Character_Node
@export var ally_0_fighter_resouce: Fighter_Resource
@export var ally_0_fighter_prefab: PackedScene
#-------------------------------------------------------------------------------
@export_category("Ally 1")
@export var ally_1: Interactable_Script
@export var ally_1_character: Character_Node
@export var ally_1_fighter_resouce: Fighter_Resource
@export var ally_1_fighter_prefab: PackedScene
#-------------------------------------------------------------------------------
@export_category("Ally 2")
@export var ally_2: Interactable_Script
@export var ally_2_character: Character_Node
@export var ally_2_fighter_resouce: Fighter_Resource
@export var ally_2_fighter_prefab: PackedScene
#-------------------------------------------------------------------------------
@export_category("Ally 3")
@export var ally_3: Interactable_Script
@export var ally_3_character: Character_Node
@export var ally_3_fighter_resouce: Fighter_Resource
@export var ally_3_fighter_prefab: PackedScene
#-------------------------------------------------------------------------------
@export_category("NPC 3")
@export var npc_3: Interactable_Script
@export var npc_3_character: Character_Node
@export var npc_3_item_consumable_array: Array[Action_Serializable]
@export var npc_3_item_equip_array: Array[Equip_Serializable]
@export var npc_3_item_key_array: Array[Key_Serializable]
#-------------------------------------------------------------------------------
@export_category("Enemy 1")
@export var enemy_1: Interactable_Script
@export var enemy_1_fighter_array: Array[Fighter_Node]
#-------------------------------------------------------------------------------
@export_category("Enemy 2")
@export var enemy_2: Interactable_Script
@export var enemy_2_fighter_array: Array[Fighter_Node]
#-------------------------------------------------------------------------------
@export_category("Interactable")
@export var interactable: Interactable_Script
#-------------------------------------------------------------------------------
func Set_Room():
	Set_Ally(ally_0, ally_0_character, ally_0_fighter_resouce, ally_0_fighter_prefab)
	Set_Ally(ally_1, ally_1_character, ally_1_fighter_resouce, ally_1_fighter_prefab)
	Set_Ally(ally_2, ally_2_character, ally_2_fighter_resouce, ally_2_fighter_prefab)
	Set_Ally(ally_3, ally_3_character, ally_3_fighter_resouce, ally_3_fighter_prefab)
	#-------------------------------------------------------------------------------
	Set_Enemy(enemy_1, enemy_1_fighter_array)
	Set_Enemy(enemy_2, enemy_2_fighter_array)
	#-------------------------------------------------------------------------------
	npc_3.interactable_by_action = func(): NPC_3_Talk()
	interactable.interactable_by_action = func(): Interactable_Action()
	singleton.Play_BGM_Stage1()
#-------------------------------------------------------------------------------
func Set_Ally(_imteractable_script:Interactable_Script, _character_node:Character_Node, _fighter_resource:Fighter_Resource, _fighter_prefab:PackedScene):
	var _index: int = singleton.game_system.Get_Fighter_Node_Index(_fighter_resource)
	#-------------------------------------------------------------------------------
	if(_index < 0):
		_character_node.modulate.a = 1.0
	#-------------------------------------------------------------------------------
	else:
		_character_node.modulate.a = 105.0/255.0
	#-------------------------------------------------------------------------------
	_imteractable_script.interactable_by_action = func(): NPC_1_Talk(_imteractable_script, _character_node, _fighter_resource, _fighter_prefab)
#-------------------------------------------------------------------------------
func NPC_1_Talk(_imteractable_script:Interactable_Script, _character_node:Character_Node, _fighter_resource:Fighter_Resource, _fighter_prefab:PackedScene):
	#-------------------------------------------------------------------------------
	singleton.game_system.Disable_Pause_Input()
	singleton.game_system.Stop_Moving()
	singleton.game_system.Dialogue_Open()
	#-------------------------------------------------------------------------------
	var _player_1_character_resource: Character_Resource = singleton.game_system.ally_party[0].character_node.character_resource
	#-------------------------------------------------------------------------------
	var _index: int = singleton.game_system.Get_Fighter_Node_Index(_fighter_resource)
	#-------------------------------------------------------------------------------
	if(_index < 0):
		await singleton.game_system.Dialogue_with_Face_0(_character_node.character_resource, "* Querés que te acompañe?")
		singleton.game_system.Open_Dialogue_Options(["Si", "No"])
		await singleton.game_system.next_signal
		#-------------------------------------------------------------------------------
		match(singleton.game_system.dialogue_option_index):
			0:
				singleton.game_system.Close_Dialogue_Options()
				await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* Ok, voy a ir con vos.")
				var _fighter_ally_1: Fighter_Node = _fighter_prefab.instantiate() as Fighter_Node
				singleton.game_system.player_characterbody2d.add_child(_fighter_ally_1)
				singleton.game_system.ally_party.append(_fighter_ally_1)
				singleton.game_system.Set_Fighter_0()
				_character_node.modulate.a = 105.0/255.0
			#-------------------------------------------------------------------------------
			1:
				singleton.game_system.Close_Dialogue_Options()
				await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* Ok, voy a estar acá si me necesitas.")
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		await singleton.game_system.Dialogue_Close()
		singleton.game_system.Enable_Pause_Input()
	#-------------------------------------------------------------------------------
	else:
		await singleton.game_system.Dialogue_with_Face_0(_character_node.character_resource, "* Querés que me vaya del grupo?")
		singleton.game_system.Open_Dialogue_Options(["Si", "No"])
		await singleton.game_system.next_signal
		#-------------------------------------------------------------------------------
		match(singleton.game_system.dialogue_option_index):
			0:
				#-------------------------------------------------------------------------------
				if(singleton.game_system.ally_party.size() > 1):
					singleton.game_system.Close_Dialogue_Options()
					await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* Ok, voy a estar acá si me necesitas.")
					singleton.game_system.ally_party[_index].queue_free()
					singleton.game_system.ally_party.remove_at(_index)
					singleton.game_system.Set_Fighter_0()
					_character_node.modulate.a = 1.0
				#-------------------------------------------------------------------------------
				else:
					singleton.game_system.Close_Dialogue_Options()
					await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* No podés tener cero aliados en tu equipo.")
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			1:
				singleton.game_system.Close_Dialogue_Options()
				await singleton.game_system.Dialogue_with_Face(_character_node.character_resource, "* Ok, sigo con vos.")
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		await singleton.game_system.Dialogue_Close()
		singleton.game_system.Enable_Pause_Input()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func NPC_3_Talk():
	#-------------------------------------------------------------------------------
	var _player_1_character_resource: Character_Resource = singleton.game_system.ally_party[0].character_node.character_resource
	singleton.game_system.Disable_Pause_Input()
	singleton.game_system.Stop_Moving()
	singleton.game_system.Dialogue_Open()
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue_with_Face_0(npc_3_character.character_resource, "* Hola Che. Vamos a pelear!")
	singleton.game_system.Open_Dialogue_Options(["Comprar", "Hablar", "Irse"])
	await singleton.game_system.next_signal
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
			singleton.game_system.Close_Dialogue_Options()
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* Quiero Comprar.")
			await singleton.game_system.Dialogue_with_Face(npc_3_character.character_resource, "* Ok, te muestro lo que tengo.")
			singleton.game_system.Dialogue_Close_0()
			await singleton.game_system.Open_Market(npc_3.name, npc_3_item_consumable_array, npc_3_item_equip_array, npc_3_item_key_array)
			#-------------------------------------------------------------------------------
			singleton.game_system.Dialogue_Open()
			await singleton.game_system.Dialogue_with_Face(npc_3_character.character_resource, "* Gracias, vuelva Pronto.")
		#-------------------------------------------------------------------------------
		1:
			singleton.game_system.Close_Dialogue_Options()
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* Si. "+_blablabla)
			await singleton.game_system.Dialogue_with_Face(npc_3_character.character_resource, "* Ok, pero ya no tengo ganas, asique ya fué.")
		#-------------------------------------------------------------------------------
		2:
			singleton.game_system.Close_Dialogue_Options()
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* No. "+_blablabla)
			await singleton.game_system.Dialogue_with_Face(npc_3_character.character_resource, "* No? Ok, para la próxima.")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue_Close()
	singleton.game_system.Enable_Pause_Input()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Enemy(_imteractable_script:Interactable_Script, _fighter_array: Array[Fighter_Node]):
	_imteractable_script.interactable_by_action = func(): NPC_4_Talk(_fighter_array)
#-------------------------------------------------------------------------------
func NPC_4_Talk(_fighter_array: Array[Fighter_Node]):
	var _character_resource:Character_Resource = _fighter_array[0].character_node.character_resource
	#-------------------------------------------------------------------------------
	var _player_1_character_resource: Character_Resource = singleton.game_system.ally_party[0].character_node.character_resource
	singleton.game_system.Disable_Pause_Input()
	singleton.game_system.Stop_Moving()
	singleton.game_system.Dialogue_Open()
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue_with_Face_0(_character_resource, "* Hola Che. Vamos a pelear!")
	singleton.game_system.Open_Dialogue_Options(["Pelear", "Irse"])
	await singleton.game_system.next_signal
	#-------------------------------------------------------------------------------
	match(singleton.game_system.dialogue_option_index):
		0:
			singleton.game_system.Close_Dialogue_Options()
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* Quiero Pelear.")
			await singleton.game_system.Dialogue_with_Face(_character_resource, "* Ok, vamos a pelear.")
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_Close()
			singleton.game_system.Dialogue_0("* The Battle Began!")
			await Enter_Battle(_fighter_array)
		#-------------------------------------------------------------------------------
		1:
			singleton.game_system.Close_Dialogue_Options()
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* No.")
			await singleton.game_system.Dialogue_with_Face(_character_resource, "* No? Ok, para la próxima.")
			await singleton.game_system.Dialogue_Close()
			singleton.game_system.Enable_Pause_Input()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Interactable_Action():
	#-------------------------------------------------------------------------------
	singleton.game_system.Disable_Pause_Input()
	singleton.game_system.Stop_Moving()
	singleton.game_system.Dialogue_Open()
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue("* Una luz extraña en la esquina de la habitación.")
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue_Close()
	singleton.game_system.Enable_Pause_Input()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Enter_Battle(_array_enemy_party:Array[Fighter_Node]):
	await singleton.game_system.Enter_Battle(_array_enemy_party)
	#singleton.game_system.myBATTLE_STATE = Game_System.BATTLE_STATE.YOU_LOSE
	await Loop_Battle(_array_enemy_party)
#-------------------------------------------------------------------------------
func Loop_Battle(_array_enemy_party:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	while(singleton.game_system.myBATTLE_STATE == Game_System.BATTLE_STATE.STILL_FIGHTING):
		await singleton.game_system.Re_Open_Battle_Menu()
		await singleton.game_system.Do_Ally_Actions()
		await singleton.game_system.Do_Enemy_Actions()
	#-------------------------------------------------------------------------------
	await After_Battle(_array_enemy_party)
#-------------------------------------------------------------------------------
func After_Battle(_array_enemy_party:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	match(singleton.game_system.myBATTLE_STATE):
		Game_System.BATTLE_STATE.YOU_WIN:
			await singleton.game_system.You_Win()
			await singleton.game_system.Dialogue_Close()
			singleton.game_system.Enable_Pause_Input()
		#-------------------------------------------------------------------------------
		Game_System.BATTLE_STATE.YOU_LOSE:
			await singleton.game_system.You_Lose()
			#-------------------------------------------------------------------------------
			match(singleton.game_system.myLOSE_STATE):
				Game_System.LOSE_STATE.YOU_RETRY:
					await You_Retry(_array_enemy_party)
					await singleton.game_system.Dialogue_Close()
				#-------------------------------------------------------------------------------
				Game_System.LOSE_STATE.YOU_ESCAPE_TO_SAVEPOINT:
					await You_Escape_to_SavePoint(_array_enemy_party)
					await singleton.game_system.Dialogue_Close()
					singleton.game_system.Enable_Pause_Input()
				#-------------------------------------------------------------------------------
				Game_System.LOSE_STATE.YOU_GIVE_UP:
					await You_Give_Up()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Game_System.BATTLE_STATE.YOU_ESCAPE:
			await singleton.game_system.Escape_Effect()
			Hide_Other_Fighters(_array_enemy_party)
			await singleton.game_system.You_Escape()
			await singleton.game_system.Dialogue_Close()
			singleton.game_system.Enable_Pause_Input()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func You_Retry(_array_enemy_party:Array[Fighter_Node]):
	singleton.game_system.lose_menu.hide()
	singleton.Common_Submited()
	await singleton.game_system.You_Retry()
	#singleton.game_system.myBATTLE_STATE = Game_System.BATTLE_STATE.YOU_LOSE
	await Loop_Battle(_array_enemy_party)
#-------------------------------------------------------------------------------
func You_Escape_to_SavePoint(_array_enemy_party:Array[Fighter_Node]):
	singleton.game_system.next_signal.emit()
	singleton.game_system.lose_menu.hide()
	singleton.Common_Submited()
	await singleton.game_system.Escape_Effect()
	Hide_Other_Fighters(_array_enemy_party)
	await singleton.game_system.You_Escape_to_SavePoint()
#-------------------------------------------------------------------------------
func You_Give_Up():
	singleton.game_system.You_Give_Up()
#-------------------------------------------------------------------------------
func Hide_Other_Fighters(_array_enemy_party:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	for _i in range(1, _array_enemy_party.size()):
		_array_enemy_party[_i].hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
