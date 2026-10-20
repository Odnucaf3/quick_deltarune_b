extends Node2D
#-------------------------------------------------------------------------------
@export var interactable: Interactable_Script
@export var fighter_array: Array[Fighter_Node]
#-------------------------------------------------------------------------------
func _ready() -> void:
	Set_Enemy(interactable, fighter_array)
#-------------------------------------------------------------------------------
func Set_Enemy(_imteractable_script:Interactable_Script, _array_fighter_array:Array[Fighter_Node]):
	singleton.game_system.Set_Party_Equip_at_the_Start(_array_fighter_array)
	_imteractable_script.interactable_by_action = func(): Interaction(_array_fighter_array)
#-------------------------------------------------------------------------------
func Interaction(_array_fighter_array:Array[Fighter_Node]):
	var _character_resource:Character_Resource = _array_fighter_array[0].character_resource
	var _player_1_character_resource: Character_Resource = singleton.game_system.ally_character_party[0].character_resource
	#-------------------------------------------------------------------------------
	singleton.game_system.Dialogue_Enter_and_Open()
	#-------------------------------------------------------------------------------
	await singleton.game_system.Dialogue_with_Face_with_Options(_character_resource, "* Hola Che. Vamos a pelear!", ["Pelear", "Irse"])
	#-------------------------------------------------------------------------------
	match(singleton.game_system.dialogue_option_index):
		0:
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* Quiero Pelear.")
			await singleton.game_system.Dialogue_with_Face(_character_resource, "* Ok, vamos a pelear.")
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_Close()
			await singleton.game_system.Enter_Battle(_array_fighter_array)
			await Loop_Battle(_array_fighter_array)
		#-------------------------------------------------------------------------------
		1:
			#-------------------------------------------------------------------------------
			await singleton.game_system.Dialogue_with_Face(_player_1_character_resource, "* No.")
			await singleton.game_system.Dialogue_with_Face(_character_resource, "* No? Ok, para la próxima.")
			await singleton.game_system.Dialogue_Close_and_Exit()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Loop_Battle(_array_fighter_array:Array[Fighter_Node]):
	var _spellcard: Callable = func(): singleton.game_system.SpellCard()
	await singleton.game_system.Do_Enemy_Actions(_spellcard, 15)
	#-------------------------------------------------------------------------------
	while(singleton.game_system.myBATTLE_STATE == Game_System.BATTLE_STATE.STILL_FIGHTING):
		await singleton.game_system.Do_Ally_Actions("* The Battle Continue. Turn "+str(singleton.game_system.turn_counter)+".")
		await singleton.game_system.Do_Enemy_Actions(_spellcard, 15)
	#-------------------------------------------------------------------------------
	await After_Battle(_array_fighter_array)
#-------------------------------------------------------------------------------
func After_Battle(_array_fighter_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	match(singleton.game_system.myBATTLE_STATE):
		Game_System.BATTLE_STATE.YOU_WIN:
			await singleton.game_system.You_Win_Fade_Out()
			await singleton.game_system.You_Win_Fade_In()
		#-------------------------------------------------------------------------------
		Game_System.BATTLE_STATE.YOU_LOSE:
			await singleton.game_system.You_Lose()
			#-------------------------------------------------------------------------------
			match(singleton.game_system.myLOSE_STATE):
				Game_System.LOSE_STATE.YOU_RETRY:
					await singleton.game_system.You_Retry(_array_fighter_array)
					await Loop_Battle(_array_fighter_array)
				#-------------------------------------------------------------------------------
				Game_System.LOSE_STATE.YOU_ESCAPE_TO_SAVEPOINT:
					await singleton.game_system.You_Escape_Fade_Out()
					await singleton.game_system.Move_Allies_and_Camera_to_Starting_Position()
					await singleton.game_system.You_Escape_Fade_In()
				#-------------------------------------------------------------------------------
				Game_System.LOSE_STATE.YOU_GIVE_UP:
					await singleton.game_system.You_Give_Up()
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Game_System.BATTLE_STATE.YOU_ESCAPE:
			await singleton.game_system.You_Escape_Fade_Out()
			await singleton.game_system.You_Escape_Fade_In()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
