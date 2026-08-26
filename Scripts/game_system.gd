extends Node
class_name Game_System
#-------------------------------------------------------------------------------
enum GAME_STATE{IN_WORLD, IN_MENU, IN_BATTLE}
enum BATTLE_STATE{STILL_FIGHTING, YOU_WIN, YOU_LOSE, YOU_ESCAPE}
enum LOSE_STATE{YOU_RETRY, YOU_ESCAPE_TO_SAVEPOINT, YOU_GIVE_UP}
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
var key_dictionary: Dictionary[String, int]
#-------------------------------------------------------------------------------
@export var background_canvas_layer: CanvasLayer
@export var main_canvas_layer: Main_CanvasLayer
@export var world_2d: Node2D
#-------------------------------------------------------------------------------
@export var timer_root: Control
@export var timer_label: Label
var tp: int = 100
var timer_value: int
var max_timer_value: int
var timer_tween: Tween
#-------------------------------------------------------------------------------
@export var battle_box: Control
var battle_box_limit_up: float
var battle_box_limit_down: float
var battle_box_limit_left: float
var battle_box_limit_right: float
@export var hitbox_root: Control
@export var battle_ui: Control
@export var black_screen_override: Panel
#-------------------------------------------------------------------------------
@export_category("Prefabs & Resources")
@export var attack_resource: Action_Resource
@export var guard_resource: Action_Resource
@export var death_status_resource: Status_Resource
@export var fighter_button_prefab: PackedScene
@export var fighter_ally_ui_prefab: PackedScene
@export var fighter_enemy_ui_prefab: PackedScene
@export var ally_pop_up_prefab: PackedScene
@export var enemy_pop_up_prefab: PackedScene
#-------------------------------------------------------------------------------
@export_category("Inventory")
@export var item_consumable_inventory: Array[Action_Serializable]
var item_consumable_inventory_in_battle: Array[Action_Serializable]
@export var item_equip_inventory: Array[Equip_Serializable]
var item_equip_inventory_in_battle: Array[Equip_Serializable]
@export var item_key_inventory: Array[Key_Serializable]
var item_key_inventory_in_battle: Array[Key_Serializable]
@export var money_inventory: Key_Serializable
var money_inventory_in_battle: Key_Serializable
#-------------------------------------------------------------------------------
var myGAME_STATE: GAME_STATE = GAME_STATE.IN_WORLD
var myBATTLE_STATE: BATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
var myLOSE_STATE: LOSE_STATE = LOSE_STATE.YOU_RETRY
#-------------------------------------------------------------------------------
@export_category("Player")
@export var ally_party: Array[Fighter_Node]
var ally_button_array: Array[Fighter_Button]
var current_fighter_turn: int = 0
@export var lock_on: Control
@export var enemy_party: Array[Fighter_Node]
@export var player_characterbody2d: CharacterBody2D
var player_starting_position: Vector2
@export var player_interactable_by_action_area2d: Area2D
@export var player_interactable_by_action_collider: CollisionShape2D
var isSlowMotion: bool = false
var deltaTimeScale: float = 1.0
var input_dir: Vector2
var input_dir_normal: Vector2
var dead_zone: float = 0.001
const state_machine_layer_1: String = "base"
#-------------------------------------------------------------------------------
const damage_scaling: float = 100
const armor_scaling: float = 100
#-------------------------------------------------------------------------------
@export_category("Camera")
@export var camera: Camera2D
var camera_offset_y: float = 28
@export var current_room: Room_Script
#-------------------------------------------------------------------------------
var width: float = ProjectSettings.get_setting("display/window/size/viewport_width")
var height: float = ProjectSettings.get_setting("display/window/size/viewport_height")
var camera_size: Vector2
var camera_center: Vector2
var viewport_size: Vector2
var viewport_center: Vector2
#-------------------------------------------------------------------------------
@export_category("TP Bar")
@export var tp_bar: Control
@export var tp_bar_slider: ProgressBar
@export var tp_bar_name: Label
@export var tp_bar_value: Label
@export var tp_bar_max_value: Label
#-------------------------------------------------------------------------------
@export_category("Battle Menu")
@export var battle_background_root: Control
@export var battle_background_dark_panel: Panel
@export var battle_menu: Control
@export var battle_menu_button_skill: Button
@export var battle_menu_button_item: Button
@export var battle_menu_button_status: Button
@export var battle_menu_button_statistics: Button
#-------------------------------------------------------------------------------
@export_category("Escape Menu")
@export var escape_menu: Control
@export var escape_menu_yes_button: Button
@export var escape_menu_no_button: Button
#-------------------------------------------------------------------------------
@export_category("Win Menu")
@export var win_menu: Control
#-------------------------------------------------------------------------------
@export_category("Lose Menu")
@export var lose_menu: Control
@export var lose_menu_retry_button: Button
@export var lose_menu_go_to_savepoint_button: Button
@export var lose_menu_give_up_button: Button
#-------------------------------------------------------------------------------
@export_category("Go to Title Menu")
@export var go_to_title_menu: Control
@export var go_to_title_menu_button_yes: Button
@export var go_to_title_menu_button_no: Button
#-------------------------------------------------------------------------------
@export_category("Pause Menu")
@export var pause_menu: Control
#-------------------------------------------------------------------------------
@export var pause_menu_panel: Control
@export var pause_menu_button_title: Label
@export var pause_menu_button_skill: Button
@export var pause_menu_button_item: Button
@export var pause_menu_button_equip: Button
@export var pause_menu_button_statistics: Button
@export var pause_menu_button_status: Button
@export var pause_menu_button_options: Button
@export var pause_menu_button_quit: Button
@export var pause_menu_money_label: Label
@export var pause_menu_button_mouse_blocker: Control
#-------------------------------------------------------------------------------
@export_category("Pause Menu Fighter")
@export var pause_menu_fighter_button_title: Label
@export var pause_menu_fighter_button_content: VBoxContainer
@export var pause_menu_fighter_button_mouse_blocker: Control
#-------------------------------------------------------------------------------
@export_category("Skill Menu")
@export var skill_menu: Control
#-------------------------------------------------------------------------------
@export var skill_menu_button_0: Button
@export var skill_menu_button_title: Label
var skill_menu_button_array: Array[Button]
@export var skill_menu_button_content: VBoxContainer
#-------------------------------------------------------------------------------
@export var skill_menu_information_root: ScrollContainer
@export var skill_menu_information_title: Label
@export var skill_menu_information_content: VBoxContainer
#-------------------------------------------------------------------------------
@export var skill_menu_information_name: Label
@export var skill_menu_information_icon: TextureRect
@export var skill_menu_information_hold_title: Label
@export var skill_menu_information_hold_value: Label
@export var skill_menu_information_tp_cost_title: Label
@export var skill_menu_information_tp_cost_value: Label
@export var skill_menu_information_cooldown_title: Label
@export var skill_menu_information_cooldown_value: Label
@export var skill_menu_information_speed_title: Label
@export var skill_menu_information_speed_value: Label
@export var skill_menu_information_presition_title: Label
@export var skill_menu_information_presition_value: Label
@export var skill_menu_information_action_title: Label
@export var skill_menu_information_action_value: Label
@export var skill_menu_information_target_title: Label
@export var skill_menu_information_target_value: Label
@export var skill_menu_information_status_title: Label
@export var skill_menu_information_status_name: Label
@export var skill_menu_information_status_value: Label
@export var skill_menu_information_description_title: Label
@export var skill_menu_information_description_value: Label
#-------------------------------------------------------------------------------
@export_category("Item Menu")
@export var item_menu: Control
#-------------------------------------------------------------------------------
@export var item_manu_information_title: Label
#-------------------------------------------------------------------------------
@export var item_menu_all_button_0: Button
@export var item_menu_consumable_button_0: Button
@export var item_menu_equip_button_0: Button
@export var item_menu_key_button_0: Button
#-------------------------------------------------------------------------------
@export_category("Item Menu All")
@export var item_menu_all_button_root: Control
@export var item_menu_all_button_title: Label
@export var item_menu_all_button_content: VBoxContainer
var item_menu_all_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export_category("Item Menu Consumable")
@export var item_menu_consumable_button_root: Control
@export var item_menu_consumable_button_title: Label
@export var item_menu_consumable_button_content: VBoxContainer
var item_menu_consumable_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export var item_menu_consumable_information_root: ScrollContainer
@export var item_menu_consumable_information_content: VBoxContainer
#-------------------------------------------------------------------------------
@export var item_menu_consumable_information_name: Label
@export var item_menu_consumable_information_icon: TextureRect
@export var item_menu_consumable_information_hold_title: Label
@export var item_menu_consumable_information_hold_value: Label
@export var item_menu_consumable_information_stored_title: Label
@export var item_menu_consumable_information_stored_value: Label
@export var item_menu_consumable_information_tp_cost_title: Label
@export var item_menu_consumable_information_tp_cost_value: Label
@export var item_menu_consumable_information_cooldown_title: Label
@export var item_menu_consumable_information_cooldown_value: Label
@export var item_menu_consumable_information_speed_title: Label
@export var item_menu_consumable_information_speed_value: Label
@export var item_menu_consumable_information_presition_title: Label
@export var item_menu_consumable_information_presition_value: Label
@export var item_menu_consumable_information_action_title: Label
@export var item_menu_consumable_information_action_value: Label
@export var item_menu_consumable_information_target_title: Label
@export var item_menu_consumable_information_target_value: Label
@export var item_menu_consumable_information_status_title: Label
@export var item_menu_consumable_information_status_name: Label
@export var item_menu_consumable_information_status_value: Label
@export var item_menu_consumable_information_description_title: Label
@export var item_menu_consumable_information_description_value: Label
#-------------------------------------------------------------------------------
@export_category("Item Menu Equip")
@export var item_menu_equip_button_root: Control
@export var item_menu_equip_button_title: Label
@export var item_menu_equip_button_content: VBoxContainer
var item_menu_equip_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export var item_menu_equip_information_root: ScrollContainer
@export var item_menu_equip_information_content: VBoxContainer
#-------------------------------------------------------------------------------
@export var item_menu_equip_information_name: Label
@export var item_menu_equip_information_icon: TextureRect
@export var item_menu_equip_information_stored_title: Label
@export var item_menu_equip_information_stored_value: Label
@export var item_menu_equip_information_level_title: Label
@export var item_menu_equip_information_level_value: Label
@export var item_menu_equip_information_type_title: Label
@export var item_menu_equip_information_type_value: Label
@export var item_menu_equip_information_class_title: Label
@export var item_menu_equip_information_class_value: Label
@export var item_menu_equip_information_statistics_title: Label
@export var item_menu_equip_information_statistics_name: Label
@export var item_menu_equip_information_statistics_value: Label
@export var item_menu_equip_information_description_title: Label
@export var item_menu_equip_information_description_value: Label
#-------------------------------------------------------------------------------
@export_category("Item Menu Key")
@export var item_menu_key_button_root: Control
@export var item_menu_key_button_title: Label
@export var item_menu_key_button_content: VBoxContainer
var item_menu_key_button_array: Array[Button]
#-------------------------------------------------------------------------------
@export var item_menu_key_information_root: ScrollContainer
@export var item_menu_key_information_content: VBoxContainer
#-------------------------------------------------------------------------------
@export var item_menu_key_information_name: Label
@export var item_menu_key_information_icon: TextureRect
@export var item_menu_key_information_stored_title: Label
@export var item_menu_key_information_stored_value: Label
@export var item_menu_key_information_description_title: Label
@export var item_menu_key_information_description_value: Label
#-------------------------------------------------------------------------------
@export_category("Equip Menu")
@export var equip_menu: Control
#-------------------------------------------------------------------------------
@export var equip_menu_button_0: Button
@export var equip_menu_button_title: Label
var equip_menu_button_array: Array[Button]
@export var equip_menu_button_content: VBoxContainer
@export var equip_menu_button_type: Label
#-------------------------------------------------------------------------------
@export var equip_menu_information_root: ScrollContainer
@export var equip_menu_information_title: Label
@export var equip_menu_information_content: VBoxContainer
#-------------------------------------------------------------------------------
@export var equip_menu_information_name: Label
@export var equip_menu_information_icon: TextureRect
@export var equip_menu_information_stored_title: Label
@export var equip_menu_information_stored_value: Label
@export var equip_menu_information_level_title: Label
@export var equip_menu_information_level_value: Label
@export var equip_menu_information_type_title: Label
@export var equip_menu_information_type_value: Label
@export var equip_menu_information_class_type: Label
@export var equip_menu_information_class_value: Label
@export var equip_menu_information_statistics_title: Label
@export var equip_menu_information_statistics_name: Label
@export var equip_menu_information_statistics_value: Label
@export var equip_menu_information_description_title: Label
@export var equip_menu_information_description_value: Label
#-------------------------------------------------------------------------------
@export_category("Statistics Menu")
@export var statistics_menu: Control
@export var statistics_menu_button_0: Button
@export var statistics_menu_information_root: ScrollContainer
#-------------------------------------------------------------------------------
@export var statistics_menu_information_fighter_face: TextureRect
@export var statistics_menu_information_fighter_name: Label
@export var statistics_menu_information_fighter_title: Label
@export var statistics_menu_information_fighter_hp_value: Label
@export var statistics_menu_information_fighter_hp_slider: ProgressBar
@export var statistics_menu_information_level_title: Label
@export var statistics_menu_information_level_value: Label
#-------------------------------------------------------------------------------
@export var statistics_menu_information_base_stats_title: Label
@export var statistics_menu_information_base_stats_name: Label
@export var statistics_menu_information_base_stats_value: Label
#-------------------------------------------------------------------------------
@export var statistics_menu_information_extra_stats_title: Label
@export var statistics_menu_information_extra_stats_name: Label
@export var statistics_menu_information_extra_stats_value: Label
#-------------------------------------------------------------------------------
@export var statistics_menu_information_special_stats_title: Label
@export var statistics_menu_information_special_stats_name: Label
@export var statistics_menu_information_special_stats_value: Label
#-------------------------------------------------------------------------------
@export var statistics_menu_information_equip_title: Label
@export var statistics_menu_information_equip_type: Label
@export var statistics_menu_information_equip_value: Label
#-------------------------------------------------------------------------------
@export var statistics_menu_information_skill_title: Label
@export var statistics_menu_information_skill_name: Label
#-------------------------------------------------------------------------------
@export var statistics_menu_information_status_title: Label
@export var statistics_menu_information_status_name: Label
@export var statistics_menu_information_status_value: Label
#-------------------------------------------------------------------------------
@export var statistics_menu_information_elemental_title: Label
@export var statistics_menu_information_elemental_type_title: Label
@export var statistics_menu_information_elemental_type_name: Label
@export var statistics_menu_information_elemental_power_title: Label
@export var statistics_menu_information_elemental_power_value: Label
@export var statistics_menu_information_elemental_absorb_title: Label
@export var statistics_menu_information_elemental_absorb_value: Label
@export var statistics_menu_information_elemental_affinity_title: Label
@export var statistics_menu_information_elemental_affinity_value: Label
@export var statistics_menu_information_elemental_repulsion_title: Label
@export var statistics_menu_information_elemental_repulsion_value: Label
#-------------------------------------------------------------------------------
@export var statistics_menu_information_description_title: Label
@export var statistics_menu_information_description_value: Label
#-------------------------------------------------------------------------------
@export_category("Status Effect Menu")
@export var status_menu: Control
#-------------------------------------------------------------------------------
@export var status_menu_button_0: Button
@export var status_menu_button_title: Label
var status_menu_button_array: Array[Button]
@export var status_menu_button_content: VBoxContainer
#-------------------------------------------------------------------------------
@export var status_menu_information_title: Label
@export var status_menu_information_root: ScrollContainer
#-------------------------------------------------------------------------------
@export var status_menu_information_name: Label
@export var status_menu_information_icon: TextureRect
@export var status_menu_information_turns_title: Label
@export var status_menu_information_turns_value: Label
@export var status_menu_information_statistics_title: Label
@export var status_menu_information_statistics_name: Label
@export var status_menu_information_statistics_value: Label
@export var status_menu_information_description_title: Label
@export var status_menu_information_description_value: Label
#-------------------------------------------------------------------------------
@export_category("Dialogue Menu")
@export var dialogue_menu: Control
@export var dialogue_menu_face: TextureRect
@export var dialogue_menu_name: RichTextLabel
@export var dialogue_menu_value: RichTextLabel
@export var dialogue_menu_button_content: VBoxContainer
@export var dialogue_menu_audio: AudioStreamPlayer
var dialogue_menu_button_array: Array[Button]
var dialogue_option_index: int
var dialogue_index: int
var is_dialogue_skipped: bool
@export var button_next: Button
signal next_signal
var is_in_dialogue: bool = false
#-------------------------------------------------------------------------------
@export_category("Confirm Buy Menu")
@export var confirm_buy_menu: Control
@export var confirm_buy_menu_item_name: Label
@export var confirm_buy_menu_item_icon: TextureRect
@export var confirm_buy_menu_button: Button
@export var confirm_buy_menu_item_price: Label
@export var confirm_buy_menu_hold_value: Label
@export var confirm_buy_menu_stored_value: Label
#-------------------------------------------------------------------------------
@export_category("Money Menu")
@export var money_menu: Control
@export var money_menu_label: Label
var how_many_would_you_buy: int = 0
#-------------------------------------------------------------------------------
@export_category("Misc")
@export var debug_label: Label
var tween_Array: Array[Tween]
#-------------------------------------------------------------------------------
const v_scroll_value: float = 90
const hex_color_yellow: String = "ffe500"
#const hex_color_yellow: String = "yellow"
const hex_color_orange: String = "fb7927"
#const hex_color_orange: String = "orange"
#-------------------------------------------------------------------------------
const button_array_minimum_size_y: int = 42
const button_array_font_size: int = 20
var battle_order: int = 2
var world_order: int = 0
var was_status_effect_add_or_removed: bool
#-------------------------------------------------------------------------------
const pop_up_timer: float = 1.18
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MONOVEHAVIOUR
#-------------------------------------------------------------------------------
func _enter_tree() -> void:
	singleton.game_system = self
#-------------------------------------------------------------------------------
func _ready() -> void:
	Pause_Off_1()
	main_canvas_layer.show()
	background_canvas_layer.show()
	player_starting_position = player_characterbody2d.global_position
	#-------------------------------------------------------------------------------
	black_screen_override.show()
	battle_box.hide()
	timer_root.hide()
	black_screen_override.self_modulate = Color.TRANSPARENT
	Set_Camera_Parameters()
	Set_Room(current_room)
	Camera_Set_Target_Position()
	#-------------------------------------------------------------------------------
	escape_menu.hide()
	lose_menu.hide()
	win_menu.hide()
	lock_on.hide()
	battle_background_root.hide()
	battle_menu.hide()
	dialogue_menu.hide()
	button_next.hide()
	pause_menu.hide()
	skill_menu.hide()
	item_menu.hide()
	equip_menu.hide()
	statistics_menu.hide()
	status_menu.hide()
	tp_bar.hide()
	pause_menu_panel.hide()
	go_to_title_menu.hide()
	money_menu.hide()
	confirm_buy_menu.hide()
	singleton.Move_to_Button(pause_menu_button_skill)
	#-------------------------------------------------------------------------------
	Fill_the_ConsumableItems_Stored_from_Hold()
	Pause_Menu_Set()
	pause_menu_button_mouse_blocker.hide()
	pause_menu_fighter_button_mouse_blocker.show()
	#-------------------------------------------------------------------------------
	singleton.Button_Remove_Navigation(skill_menu_button_0)
	singleton.Button_Remove_Navigation(equip_menu_button_0)
	#-------------------------------------------------------------------------------
	singleton.Button_Remove_Navigation(item_menu_all_button_0)
	singleton.Button_Remove_Navigation(item_menu_consumable_button_0)
	singleton.Button_Remove_Navigation(item_menu_equip_button_0)
	singleton.Button_Remove_Navigation(item_menu_key_button_0)
	#-------------------------------------------------------------------------------
	singleton.Button_Remove_Navigation(button_next)
	#-------------------------------------------------------------------------------
	singleton.Destroy_Childrens(skill_menu_button_content)
	singleton.Destroy_Childrens(equip_menu_button_content)
	singleton.Destroy_Childrens(status_menu_button_content)
	singleton.Destroy_Childrens(pause_menu_fighter_button_content)
	#-------------------------------------------------------------------------------
	singleton.Destroy_Childrens(item_menu_all_button_content)
	singleton.Destroy_Childrens(item_menu_consumable_button_content)
	singleton.Destroy_Childrens(item_menu_equip_button_content)
	singleton.Destroy_Childrens(item_menu_key_button_content)
	singleton.Destroy_Childrens(dialogue_menu_button_content)
	#-------------------------------------------------------------------------------
	Set_Idiome()
	button_next.hide()
	#-------------------------------------------------------------------------------
	Set_Fighter_0()
	#-------------------------------------------------------------------------------
	NormalMotion()
	Animation_StateMachine_Set(ally_party[0].character_node.animation_tree, state_machine_layer_1, "Idle")
#-------------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	tween_Array = get_tree().get_processed_tweens()
	#-------------------------------------------------------------------------------
	match(myGAME_STATE):
		GAME_STATE.IN_WORLD:
			Camera_Follow()
			#-------------------------------------------------------------------------------
			if(is_in_dialogue):
				return
			#-------------------------------------------------------------------------------
			if(Input.is_action_just_pressed("ui_accept")):
				var _area2d_array : Array[Area2D] = player_interactable_by_action_area2d.get_overlapping_areas()
				#-------------------------------------------------------------------------------
				if(_area2d_array.size() > 0):
					var _interactable: Interactable_Script = _area2d_array[0] as Interactable_Script
					_interactable.interactable_by_action.call()
					return
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			Player_Movement()
			Followers_Movement()
		#-------------------------------------------------------------------------------
		GAME_STATE.IN_BATTLE:
			Hitbox_Movement()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func _exit_tree() -> void:
	singleton.game_system = null
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PLAYER FUNCTIONS
#-------------------------------------------------------------------------------
func Player_Movement():
	var _run_flag: bool = Input.is_action_pressed("Input_Run")
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#-------------------------------------------------------------------------------
	if(abs(input_dir.x) < dead_zone):
		input_dir.x = 0
	#-------------------------------------------------------------------------------
	if(abs(input_dir.y) < dead_zone):
		input_dir.y = 0
	#-------------------------------------------------------------------------------
	if(ally_party[0].character_node.is_moving):
		#-------------------------------------------------------------------------------
		if(input_dir == Vector2.ZERO):
			Animation_StateMachine_Set(ally_party[0].character_node.animation_tree, state_machine_layer_1, "Idle")
			ally_party[0].character_node.is_moving = false
			input_dir_normal = Vector2.ZERO
			return
		#-------------------------------------------------------------------------------
		else:
			input_dir_normal = input_dir.normalized()
			#-------------------------------------------------------------------------------
			if(ally_party[0].character_node.is_running):
				var _new_velocity: Vector2 = input_dir_normal * 200.0 * deltaTimeScale
				player_characterbody2d.velocity = _new_velocity
				#-------------------------------------------------------------------------------
				if(!_run_flag):
					Animation_StateMachine_Set(ally_party[0].character_node.animation_tree, state_machine_layer_1, "Walk")
					ally_party[0].character_node.is_running = false
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				var _new_velocity: Vector2 = input_dir_normal * 70.0 * deltaTimeScale
				player_characterbody2d.velocity = _new_velocity
				#-------------------------------------------------------------------------------
				if(_run_flag):
					Animation_StateMachine_Set(ally_party[0].character_node.animation_tree, state_machine_layer_1, "Run")
					ally_party[0].character_node.is_running = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			if(ally_party[0].character_node.is_facing_left):
				if(input_dir_normal.x > 0):
					Face_Left(ally_party[0].character_node, false)
					return
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				if(input_dir_normal.x < 0):
					Face_Left(ally_party[0].character_node, true)
					return
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Set_Fighter_Position_History(ally_party[0])
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		if(input_dir != Vector2.ZERO):
			#-------------------------------------------------------------------------------
			if(_run_flag):
				Animation_StateMachine_Set(ally_party[0].character_node.animation_tree, state_machine_layer_1, "Run")
				ally_party[0].character_node.is_running = true
			#-------------------------------------------------------------------------------
			else:
				Animation_StateMachine_Set(ally_party[0].character_node.animation_tree, state_machine_layer_1, "Walk")
				ally_party[0].character_node.is_running = false
			#-------------------------------------------------------------------------------
			ally_party[0].character_node.is_moving = true
			#-------------------------------------------------------------------------------
			if(input_dir.x > 0):
				Face_Left(ally_party[0].character_node, false)
			#-------------------------------------------------------------------------------
			elif(input_dir.x < 0):
				Face_Left(ally_party[0].character_node, true)
			#-------------------------------------------------------------------------------
			return
		#-------------------------------------------------------------------------------
		else:
			var _new_velocity: Vector2 = Vector2.ZERO
			player_characterbody2d.velocity = _new_velocity
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	player_characterbody2d.move_and_slide()
#-------------------------------------------------------------------------------
func Set_Fighter_Position_History(_fighter_node:Fighter_Node):
	_fighter_node.position_history.push_front(_fighter_node.global_position)
	#-------------------------------------------------------------------------------
	if(_fighter_node.position_history.size() > 300):
		_fighter_node.position_history.pop_back()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Followers_Movement():
	var _run_flag: bool = Input.is_action_pressed("Input_Run")
	#-------------------------------------------------------------------------------
	for _i in range(1, ally_party.size()):
		var _distance: float = 20
		#-------------------------------------------------------------------------------
		if(ally_party[_i].global_position.distance_to(ally_party[_i-1].global_position) > _distance):
			var _x: float = ally_party[_i].global_position.x - ally_party[_i-1].global_position.x
			var _y: float = ally_party[_i].global_position.y - ally_party[_i-1].global_position.y
			var _dir: float = atan2(_y, _x)
			var _x2: float = _distance * cos(_dir)
			var _y2: float = _distance * sin(_dir)
			var _new_position: Vector2 = ally_party[_i-1].global_position + Vector2(_x2, _y2)
			#-------------------------------------------------------------------------------
			if(ally_party[_i].character_node.is_moving):
				ally_party[_i].global_position = lerp(ally_party[_i].global_position, _new_position, 0.1*deltaTimeScale)
				#-------------------------------------------------------------------------------
				if(ally_party[_i].global_position.distance_to(_new_position) < 5):
					Animation_StateMachine_Set(ally_party[_i].character_node.animation_tree, state_machine_layer_1, "Idle")
					ally_party[_i].character_node.is_moving = false
				#-------------------------------------------------------------------------------
				else:
					if(ally_party[_i].character_node.is_running):
						#-------------------------------------------------------------------------------
						if(!_run_flag):
							Animation_StateMachine_Set(ally_party[_i].character_node.animation_tree, state_machine_layer_1, "Walk")
							ally_party[_i].character_node.is_running = false
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
					else:
						#-------------------------------------------------------------------------------
						if(_run_flag):
							Animation_StateMachine_Set(ally_party[_i].character_node.animation_tree, state_machine_layer_1, "Run")
							ally_party[_i].character_node.is_running = true
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
					Set_Fighter_Position_History(ally_party[_i])
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				#-------------------------------------------------------------------------------
				if(ally_party[_i].global_position.distance_to(_new_position) > 10):
					#-------------------------------------------------------------------------------
					if(_run_flag):
						Animation_StateMachine_Set(ally_party[_i].character_node.animation_tree, state_machine_layer_1, "Run")
						ally_party[_i].character_node.is_running = true
					#-------------------------------------------------------------------------------
					else:
						Animation_StateMachine_Set(ally_party[_i].character_node.animation_tree, state_machine_layer_1, "Walk")
						ally_party[_i].character_node.is_running = false
					#-------------------------------------------------------------------------------
					ally_party[_i].character_node.is_moving = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(ally_party[_i].character_node.is_facing_left):
			#-------------------------------------------------------------------------------
			if(ally_party[_i].global_position < ally_party[_i-1].global_position):
				Face_Left(ally_party[_i].character_node, false)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			#-------------------------------------------------------------------------------
			if(ally_party[_i].global_position > ally_party[_i-1].global_position):
				Face_Left(ally_party[_i].character_node, true)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CAMERA FUNCTIONS
#-------------------------------------------------------------------------------
func Set_Camera_Parameters():
	viewport_size = Vector2(width, height)
	viewport_center = viewport_size/2.0
	camera_size = viewport_size / camera.zoom
	camera_center = viewport_center / camera.zoom
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Camera_Follow():
	var _new_position: Vector2 = Camera_Get_Target_Position()
	camera.global_position = lerp(camera.global_position, _new_position, 0.2)
#-------------------------------------------------------------------------------
func Camera_Set_Target_Position():
	camera.global_position = Camera_Get_Target_Position()
#-------------------------------------------------------------------------------
func Camera_Get_Target_Position() -> Vector2:
	var _new_position: Vector2 = ally_party[0].global_position + Vector2(0, -camera_offset_y)
	#-------------------------------------------------------------------------------
	_new_position.x = clampf(_new_position.x, current_room.limit_left, current_room.limit_right)
	_new_position.y = clampf(_new_position.y, current_room.limit_top, current_room.limit_botton)
	#-------------------------------------------------------------------------------
	return _new_position
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ROOM FUNCTIONS
#-------------------------------------------------------------------------------
func Set_Room(_room:Room_Script):
	_room.Set_Room()
	Set_Room_Camera_Limits(_room)
#-------------------------------------------------------------------------------
func Set_Room_Camera_Limits(_room:Room_Script):
	var _room_limits: Control = _room.room_limits
	_room.limit_top = _room_limits.global_position.y + camera_center.y
	_room.limit_botton = _room_limits.global_position.y + _room_limits.size.y - camera_center.y
	_room.limit_left = _room_limits.global_position.x + camera_center.x
	_room.limit_right = _room_limits.global_position.x + _room_limits.size.x - camera_center.x
	#-------------------------------------------------------------------------------
	var _center_x: float = _room_limits.global_position.x + _room_limits.size.x *0.5
	var _center_y: float = _room_limits.global_position.y + _room_limits.size.y *0.5
	#-------------------------------------------------------------------------------
	if(_room.limit_top > _center_y): _room.limit_top = _center_y
	if(_room.limit_botton < _center_y): _room.limit_botton = _center_y
	if(_room.limit_left > _center_x): _room.limit_left = _center_x
	if(_room.limit_right < _center_x): _room.limit_right = _center_x
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region GO-TO-TITLE MENU
#-------------------------------------------------------------------------------
func Set_Go_to_Title_Menu():
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit_yes: Callable = func():Set_Go_to_Title_Menu_Yes_Button_Submit()
	var _submit_no: Callable = func():Set_Go_to_Title_Menu_No_Button_Submit()
	main_canvas_layer.nothing_cancel = func():Set_Go_to_Title_Menu_Button_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(go_to_title_menu_button_yes, _selected, _submit_yes)
	singleton.Set_Button(go_to_title_menu_button_no, _selected, _submit_no)
	#-------------------------------------------------------------------------------
	var _button_array: Array[Button] = [
		go_to_title_menu_button_yes, 
		go_to_title_menu_button_no
	]
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Horizontal_Navigation(_button_array)
#-------------------------------------------------------------------------------
func Set_Go_to_Title_Menu_Yes_Button_Submit():
	singleton.Common_Submited()
	Pause_Off_1()
	get_tree().change_scene_to_file("res://Nodes/Scenes/title_scene.tscn")
#-------------------------------------------------------------------------------
func Set_Go_to_Title_Menu_No_Button_Submit():
	Set_Go_to_Title_Menu_Button_Common()
	singleton.Move_to_Button_by_Submit(pause_menu_button_quit)
#-------------------------------------------------------------------------------
func Set_Go_to_Title_Menu_Button_Cancel():
	Set_Go_to_Title_Menu_Button_Common()
	singleton.Move_to_Button_by_Cancel(pause_menu_button_quit)
#-------------------------------------------------------------------------------
func Set_Go_to_Title_Menu_Button_Common():
	go_to_title_menu.hide()
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Close()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE MENU
#-------------------------------------------------------------------------------
func Pause_On_1():
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Close()
	Pause_On_0()
#-------------------------------------------------------------------------------
func Pause_On_0():
	get_tree().set_deferred("paused", true)
#-------------------------------------------------------------------------------
func Pause_Off_1():
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Open()
	Pause_Off_0()
#-------------------------------------------------------------------------------
func Pause_Off_0():
	get_tree().set_deferred("paused", false)
#-------------------------------------------------------------------------------
func PauseMenu_Open():
	pause_menu.show()
	tp_bar.show()
	pause_menu_panel.show()
	#-------------------------------------------------------------------------------
	pause_menu_button_mouse_blocker.hide()
	pause_menu_fighter_button_mouse_blocker.show()
	#-------------------------------------------------------------------------------
	SetMoney_Label()
	Set_TP_Bar(0)
	#-------------------------------------------------------------------------------
	var _button_array: Array[Button]
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		ally_party[_i].fighter_serializable.hp = Get_Max_HP(ally_party[_i].fighter_serializable)
		#-------------------------------------------------------------------------------
		var _party_button: Fighter_Button = Create_Fighter_Button(ally_party[_i])
		_party_button.custom_minimum_size.y = 126
		pause_menu_fighter_button_content.add_child(_party_button)
		ally_button_array.append(_party_button)
		_button_array.append(_party_button as Button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(_button_array)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_button_skill)
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	Pause_On_1()
#-------------------------------------------------------------------------------
func PauseMenu_Close():
	pause_menu.hide()
	tp_bar.hide()
	pause_menu_panel.hide()
	#-------------------------------------------------------------------------------
	var _button_array: Array[Button]
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		_button_array.append(ally_button_array[_i] as Button)
	#-------------------------------------------------------------------------------
	singleton.Destroy_Button_Array(_button_array)
	ally_button_array.clear()
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
	Pause_Off_1()
#-------------------------------------------------------------------------------
func Create_Fighter_Button(_fighter_node:Fighter_Node) -> Fighter_Button:
	var _party_button: Fighter_Button = fighter_button_prefab.instantiate() as Fighter_Button
	#-------------------------------------------------------------------------------
	_party_button.face.texture = _fighter_node.character_node.character_resource.face
	Fighter_Button_Set_Information_and_Idiome(_party_button, _fighter_node.character_node.character_resource, _fighter_node.fighter_serializable)
	Fighter_Button_Set_HP(_party_button, _fighter_node.fighter_serializable)
	#-------------------------------------------------------------------------------
	return _party_button
#-------------------------------------------------------------------------------
func Fighter_Button_Set_HP(_fighter_button:Fighter_Button, _fighter_Serializable:Fighter_Serializable):
	var _max_hp = Get_Max_HP(_fighter_Serializable)
	var _hp = _fighter_Serializable.hp
	#-------------------------------------------------------------------------------
	_fighter_button.hp_label.text = Get_Fighter_Hp_Text(_hp, _max_hp)
	_fighter_button.hp_bar.max_value = _max_hp
	_fighter_button.hp_bar.value = _hp
#-------------------------------------------------------------------------------
func Pause_Menu_Set():
	var _selected: Callable = func(): singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	var _skill_submit: Callable = func(): Pause_Menu_Skill_Button_Submit()
	var _item_submit: Callable = func(): Pause_Menu_Item_Button_Submit()
	var _equip_submit: Callable = func(): Pause_Menu_Equip_Button_Submit()
	var _status_submit: Callable = func(): Pause_Menu_Status_Button_Submit()
	var _statistics_submit: Callable = func(): Pause_Menu_Statistics_Button_Submit()
	var _options_submit: Callable = func(): PauseMenu_OptionButton_Submit()
	var _quit_submit: Callable = func(): PauseMenu_QuitButton_Submit()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(pause_menu_button_skill, _selected, _skill_submit)
	singleton.Set_Button(pause_menu_button_item, _selected, _item_submit)
	singleton.Set_Button(pause_menu_button_equip, _selected, _equip_submit)
	singleton.Set_Button(pause_menu_button_status, _selected, _status_submit)
	singleton.Set_Button(pause_menu_button_statistics, _selected, _statistics_submit)
	singleton.Set_Button(pause_menu_button_options, _selected, _options_submit)
	singleton.Set_Button(pause_menu_button_quit, _selected, _quit_submit)
	#-------------------------------------------------------------------------------
	var _button_array: Array[Button] = [
		pause_menu_button_skill,
		pause_menu_button_item,
		pause_menu_button_equip,
		pause_menu_button_status,
		pause_menu_button_statistics,
		pause_menu_button_options,
		pause_menu_button_quit
	]
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(_button_array)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Pause_Menu_Skill_Button_Submit():
	pause_menu_button_mouse_blocker.show()
	pause_menu_fighter_button_mouse_blocker.hide()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Menu_Skill_Fighter_Button_Cancel()
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): Pause_Menu_Skill_Fighter_Button_Submit(_i)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(ally_button_array[_i], _selected, _submit)
	#-------------------------------------------------------------------------------
	Disable_Item_Button_0(pause_menu_button_skill)
	singleton.Move_to_Button_by_Submit(ally_button_array[0])
#-------------------------------------------------------------------------------
func Pause_Menu_Skill_Fighter_Button_Submit(_fighter_index:int):
	Pause_Skill_Menu_Set(_fighter_index)
	pause_menu.hide()
	skill_menu.show()
#-------------------------------------------------------------------------------
func Pause_Menu_Skill_Fighter_Button_Cancel():
	pause_menu_button_mouse_blocker.hide()
	pause_menu_fighter_button_mouse_blocker.show()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Close()
	Enable_Item_Button_0(pause_menu_button_skill)
	singleton.Move_to_Button_by_Cancel(pause_menu_button_skill)
#-------------------------------------------------------------------------------
func Pause_Menu_Item_Button_Submit():
	Pause_Item_Menu_Set()
	pause_menu.hide()
	item_menu.show()
#-------------------------------------------------------------------------------
func Pause_Menu_Equip_Button_Submit():
	pause_menu_button_mouse_blocker.show()
	pause_menu_fighter_button_mouse_blocker.hide()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Menu_Equip_Fighter_Button_Cancel()
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): Pause_Menu_Equip_Fighter_Button_Submit(_i)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(ally_button_array[_i], _selected, _submit)
	#-------------------------------------------------------------------------------
	Disable_Item_Button_0(pause_menu_button_equip)
	singleton.Move_to_Button_by_Submit(ally_button_array[0])
#-------------------------------------------------------------------------------
func Pause_Menu_Equip_Fighter_Button_Submit(_fighter_index:int):
	pause_menu.hide()
	Pause_Equip_Menu_Set(_fighter_index)
	equip_menu.show()
#-------------------------------------------------------------------------------
func Pause_Menu_Equip_Fighter_Button_Cancel():
	pause_menu_button_mouse_blocker.hide()
	pause_menu_fighter_button_mouse_blocker.show()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Close()
	Enable_Item_Button_0(pause_menu_button_equip)
	singleton.Move_to_Button_by_Cancel(pause_menu_button_equip)
#-------------------------------------------------------------------------------
func Pause_Menu_Statistics_Button_Submit():
	pause_menu_button_mouse_blocker.show()
	pause_menu_fighter_button_mouse_blocker.hide()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Menu_Statistics_Fighter_Button_Cancel()
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): Pause_Menu_Statistics_Fighter_Button_Submit(_i)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(ally_button_array[_i], _selected, _submit)
	#-------------------------------------------------------------------------------
	Disable_Item_Button_0(pause_menu_button_statistics)
	singleton.Move_to_Button_by_Submit(ally_button_array[0])
#-------------------------------------------------------------------------------
func Pause_Menu_Statistics_Fighter_Button_Submit(_fighter_index:int):
	pause_menu.hide()
	statistics_menu.show()
	singleton.Move_to_Button_by_Submit(statistics_menu_button_0)
	#-------------------------------------------------------------------------------
	var _fighter_node: Fighter_Node = ally_party[_fighter_index]
	var _fighter_serializable: Fighter_Serializable = _fighter_node.fighter_serializable
	var _cancel:Callable = func():Pause_Statistics_Menu_Main_Button_Cancel(_fighter_index)
	#-------------------------------------------------------------------------------
	Pause_Statistics_Menu_Set(_fighter_node, _fighter_serializable, _cancel)
	statistics_menu_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Pause_Menu_Statistics_Fighter_Button_Cancel():
	pause_menu_button_mouse_blocker.hide()
	pause_menu_fighter_button_mouse_blocker.show()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Close()
	Enable_Item_Button_0(pause_menu_button_statistics)
	singleton.Move_to_Button_by_Cancel(pause_menu_button_statistics)
#-------------------------------------------------------------------------------
func Pause_Menu_Status_Button_Submit():
	pause_menu_button_mouse_blocker.show()
	pause_menu_fighter_button_mouse_blocker.hide()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Menu_Status_Fighter_Button_Cancel()
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): Pause_Menu_Status_Fighter_Button_Submit(_i)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(ally_button_array[_i], _selected, _submit)
	#-------------------------------------------------------------------------------
	Disable_Item_Button_0(pause_menu_button_status)
	singleton.Move_to_Button_by_Submit(ally_button_array[0])
#-------------------------------------------------------------------------------
func Pause_Menu_Status_Fighter_Button_Submit(_fighter_index:int):
	pause_menu.hide()
	status_menu.show()
	var _cancel:Callable = func():Pause_Status_Menu_Status_Button_Cancel(_fighter_index)
	Pause_Status_Menu_Set(ally_party[_fighter_index].fighter_serializable, _cancel)
	status_menu_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Pause_Menu_Status_Fighter_Button_Cancel():
	pause_menu_button_mouse_blocker.hide()
	pause_menu_fighter_button_mouse_blocker.show()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Close()
	Enable_Item_Button_0(pause_menu_button_status)
	singleton.Move_to_Button_by_Cancel(pause_menu_button_status)
#-------------------------------------------------------------------------------
func PauseMenu_QuitButton_Submit():
	go_to_title_menu.show()
	Set_Go_to_Title_Menu()
	singleton.Move_to_Button_by_Submit(go_to_title_menu_button_no)
#-------------------------------------------------------------------------------
func PauseMenu_AnyButton_Cancel():
	PauseMenu_Close()
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-SKILL MENU
#-------------------------------------------------------------------------------
func Pause_Skill_Menu_Set(_fighter_index:int):
	main_canvas_layer.nothing_cancel = func(): Pause_Skill_Menu_Main_Button_Cancel(_fighter_index)
	#-------------------------------------------------------------------------------
	var _fighter_serializable: Fighter_Serializable = ally_party[_fighter_index].fighter_serializable
	Set_Skill(_fighter_serializable)
	var _skill_serializable_array: Array[Action_Serializable] = Get_Skill(_fighter_serializable)
	#-------------------------------------------------------------------------------
	if(_skill_serializable_array.size() > 0):
		#-------------------------------------------------------------------------------
		for _i in _skill_serializable_array.size():
			var _button: Button = Create_Skill_Button(_skill_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _w: Callable = func():singleton.ScrollContainer_Up(skill_menu_information_root)
			#-------------------------------------------------------------------------------
			var _s: Callable = func():singleton.ScrollContainer_Down(skill_menu_information_root)
			#-------------------------------------------------------------------------------
			var _selected: Callable = func(): Pause_Skill_Menu_Skill_Button_Selected(_skill_serializable_array[_i])
			var _submit: Callable = func(): singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WS(_button, _selected, _submit, _w, _s)
			#-------------------------------------------------------------------------------
			skill_menu_button_content.add_child(_button)
			skill_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		skill_menu_information_root.show()
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		var _button: Button = Create_Empty_Button()
		singleton.Set_Button(_button, _selected, _submit)
		skill_menu_button_content.add_child(_button)
		skill_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		skill_menu_information_root.hide()
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(skill_menu_button_array)
	singleton.Move_to_Button_by_Submit(skill_menu_button_array[0])
	Disable_Item_Button_0(skill_menu_button_0)
#-------------------------------------------------------------------------------
func Pause_Skill_Menu_Skill_Button_Selected(_action_serializable:Action_Serializable):
	Set_Skill_Information(_action_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func Create_Skill_Button(_skill_serializable:Action_Serializable):
	#-------------------------------------------------------------------------------
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	var _name: String = Get_Tr_Skill_Name(_skill_serializable.action_resource)
	_button.text = _name+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_button.icon = _skill_serializable.action_resource.icon
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.add_theme_font_size_override("font_size", 16)
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = ""
	#-------------------------------------------------------------------------------
	if(_skill_serializable.cooldown <= 0 or _skill_serializable.action_resource.max_cooldown <= 0):
		#-------------------------------------------------------------------------------
		var _max_hold: int = _skill_serializable.action_resource.max_hold
		#-------------------------------------------------------------------------------
		if(_max_hold > 0):
			var _hold: int = _skill_serializable.hold
			_label2.text += Get_Hold_Text_B(_skill_serializable)+"  "
		#-------------------------------------------------------------------------------
		if(_skill_serializable.action_resource.tp_cost > 0):
			_label2.text += Get_TpCost_Text_B(_skill_serializable.action_resource) + "  "
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		_label2.text = Get_Tr_CD_Text(_skill_serializable.cooldown)+"  "
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Pause_Skill_Menu_Main_Button_Cancel(_fighter_index:int):
	pause_menu.show()
	skill_menu.hide()
	singleton.Destroy_Button_Array(skill_menu_button_array)
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Menu_Skill_Fighter_Button_Cancel()
	singleton.Move_to_Button_by_Cancel(ally_button_array[_fighter_index])
#-------------------------------------------------------------------------------
func Set_Skill_Information(_action_serializable:Action_Serializable):
	var _hold_text: String = Get_Hold_Text_A(_action_serializable)
	var _tp_cost_text: String = Get_TpCost_Text_A(_action_serializable.action_resource)
	var _cooldown_text: String = Get_CoolDown_Text(_action_serializable)
	#----------------------------------------------------------------------------
	skill_menu_information_icon.texture = _action_serializable.action_resource.icon
	skill_menu_information_name.text = Get_Tr_Skill_Name(_action_serializable.action_resource)
	#----------------------------------------------------------------------------
	skill_menu_information_hold_value.text = _hold_text
	#----------------------------------------------------------------------------
	skill_menu_information_tp_cost_value.text = _tp_cost_text
	skill_menu_information_cooldown_value.text = _cooldown_text
	#----------------------------------------------------------------------------
	skill_menu_information_speed_value.text = str(_action_serializable.action_resource.speed)
	skill_menu_information_presition_value.text = str(_action_serializable.action_resource.presition)+"%"
	#----------------------------------------------------------------------------
	skill_menu_information_action_value.text = Get_Skill_Effect_Text(_action_serializable.action_resource)
	skill_menu_information_target_value.text = Get_Target_Text(_action_serializable.action_resource)
	#----------------------------------------------------------------------------
	Set_Status_Rates(_action_serializable.action_resource, skill_menu_information_status_name, skill_menu_information_status_value)
	#----------------------------------------------------------------------------
	skill_menu_information_description_value.text = Get_Tr_Skill_Description(_action_serializable.action_resource)
	skill_menu_information_description_value.text += Blablabla()
	skill_menu_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Get_Skill_Effect_Text(_action_resource:Action_Resource) -> String:
	var _s: String = ""
	#-------------------------------------------------------------------------------
	if(_action_resource.myEFFECT != Action_Resource.EFFECT.NONE):
		_s += str(_action_resource.value)+" ("
		_s += Get_Tr_Action_Effect(_action_resource.myEFFECT)
		#-------------------------------------------------------------------------------
		if(_action_resource.myATRIBUTE != Action_Resource.ATRIBUTE.NONE):
			_s += " / " + Get_Tr_Action_Atribute_Name(_action_resource.myATRIBUTE)
		#-------------------------------------------------------------------------------
		if(_action_resource.myELEMENT != Action_Resource.ELEMENT.NONE):
			_s += " / " + Get_Tr_Element(_action_resource.myELEMENT)
		#-------------------------------------------------------------------------------
		_s += ")"
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		_s += "-"
	return _s
#-------------------------------------------------------------------------------
func Get_Target_Text(_action_resource:Action_Resource) -> String:
	var _s: String = ""
	#-------------------------------------------------------------------------------
	_s += Get_Tr_Action_Target_Name(_action_resource.myTARGET) + " "
	_s += "(x"+str(_action_resource.repeat)+")"
	#-------------------------------------------------------------------------------
	return _s
#-------------------------------------------------------------------------------
func Set_Status_Rates(_action_resource:Action_Resource, _label_name:Label, _label_rate:Label):
	#-------------------------------------------------------------------------------
	if(_action_resource.status_dictionary.size() > 0):
		_label_name.text = ""
		_label_rate.text = ""
		#-------------------------------------------------------------------------------
		for _i in _action_resource.status_dictionary.size():
			var _key: StringName = _action_resource.status_dictionary.keys()[_i]
			var _value: int = _action_resource.status_dictionary.values()[_i]
			_label_name.text += "* "+Get_Tr_Status_Effect_Name_0(_key)+"\n"
			_label_rate.text += str(_value)+"%"+"\n"
		#-------------------------------------------------------------------------------
		Remove_Last_Letter(_label_name)
		Remove_Last_Letter(_label_rate)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		_label_name.text = "-"
		_label_rate.text = "-"
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Stored_Text(_action_serializable:Action_Serializable) -> String:
	var _stored_text: String
	var _stored: int = _action_serializable.stored
	_stored_text = "["+str(_stored)+"]"
	return _stored_text
#-------------------------------------------------------------------------------
func Get_Hold_Text_A(_action_serializable:Action_Serializable) -> String:
	var _hold_text: String = "-"
	var _max_hold: int = _action_serializable.action_resource.max_hold
	#-------------------------------------------------------------------------------
	if(_max_hold > 0):
		var _hold: int = _action_serializable.hold
		_hold_text = "["+str(_hold)+"/"+str(_max_hold)+"]"
	#-------------------------------------------------------------------------------
	return _hold_text
#-------------------------------------------------------------------------------
func Get_Hold_Text_B(_action_serializable:Action_Serializable) -> String:
	var _hold_text: String = ""
	var _max_hold: int = _action_serializable.action_resource.max_hold
	#-------------------------------------------------------------------------------
	if(_max_hold > 0):
		var _hold: int = _action_serializable.hold
		_hold_text = "["+str(_hold)+"/"+str(_max_hold)+"]"
	#-------------------------------------------------------------------------------
	return _hold_text
#-------------------------------------------------------------------------------
func Get_TpCost_Text_A(_action_resource:Action_Resource) -> String:
	var _tp_cost_text: String = "-"
	var _tp_cost: int = _action_resource.tp_cost
	#-------------------------------------------------------------------------------
	if(_tp_cost > 0):
		_tp_cost_text = Get_Tr_TP_Cost_Text(_tp_cost)
	#-------------------------------------------------------------------------------
	return _tp_cost_text
#-------------------------------------------------------------------------------
func Get_TpCost_Text_B(_action_resource:Action_Resource) -> String:
	var _tp_cost_text: String = ""
	var _tp_cost: int = _action_resource.tp_cost
	#-------------------------------------------------------------------------------
	if(_tp_cost > 0):
		_tp_cost_text = Get_Tr_TP_Cost_Text(_tp_cost)
	#-------------------------------------------------------------------------------
	return _tp_cost_text
#-------------------------------------------------------------------------------
func Get_CoolDown_Text(_action_serializable:Action_Serializable) -> String:
	var _cooldown_text: String
	var _cooldown: int = _action_serializable.action_resource.max_cooldown
	#-------------------------------------------------------------------------------
	if(_cooldown>0):
		_cooldown_text = Get_Tr_CD_Text(_cooldown)
	#-------------------------------------------------------------------------------
	else:
		_cooldown_text = "-"
	#-------------------------------------------------------------------------------
	return _cooldown_text
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ITEM BUTTON WSAD CALLABLES
#-------------------------------------------------------------------------------
var button_consumable_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_consumable_information_root)
#-------------------------------------------------------------------------------
var button_equip_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_equip_information_root)
#-------------------------------------------------------------------------------
var button_key_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_key_information_root)
#-------------------------------------------------------------------------------
var button_consumable_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_consumable_information_root)
#-------------------------------------------------------------------------------
var button_equip_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_equip_information_root)
#-------------------------------------------------------------------------------
var button_key_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_key_information_root)
#-------------------------------------------------------------------------------
var button_all_a: Callable = func():
	Move_To_Item_Information_1(item_menu_key_information_root, item_menu_key_button_array.size())
	Move_To_Item_Button_List(item_menu_key_button_root, item_menu_key_button_0, item_menu_key_button_array)
#-------------------------------------------------------------------------------
var button_consumable_a: Callable = func():
	Move_To_Item_Button_List(item_menu_all_button_root, item_menu_all_button_0, item_menu_all_button_array)
#-------------------------------------------------------------------------------
var button_equip_a: Callable = func():
	Move_To_Item_Information_1(item_menu_consumable_information_root, item_menu_consumable_button_array.size())
	Move_To_Item_Button_List(item_menu_consumable_button_root, item_menu_consumable_button_0, item_menu_consumable_button_array)
#-------------------------------------------------------------------------------
var button_key_a: Callable = func():
	Move_To_Item_Information_1(item_menu_equip_information_root, item_menu_equip_button_array.size())
	Move_To_Item_Button_List(item_menu_equip_button_root, item_menu_equip_button_0, item_menu_equip_button_array)
#-------------------------------------------------------------------------------
var button_all_d: Callable = func():
	Move_To_Item_Information_1(item_menu_consumable_information_root, item_menu_consumable_button_array.size())
	Move_To_Item_Button_List(item_menu_consumable_button_root, item_menu_consumable_button_0, item_menu_consumable_button_array)
#-------------------------------------------------------------------------------
var button_consumable_d: Callable = func():
	Move_To_Item_Information_1(item_menu_equip_information_root, item_menu_equip_button_array.size())
	Move_To_Item_Button_List(item_menu_equip_button_root, item_menu_equip_button_0, item_menu_equip_button_array)
#-------------------------------------------------------------------------------
var button_equip_d: Callable = func():
	Move_To_Item_Information_1(item_menu_key_information_root, item_menu_key_button_array.size())
	Move_To_Item_Button_List(item_menu_key_button_root, item_menu_key_button_0, item_menu_key_button_array)
#-------------------------------------------------------------------------------
var button_key_d: Callable = func():
	Move_To_Item_Button_List(item_menu_all_button_root, item_menu_all_button_0, item_menu_all_button_array)
#-------------------------------------------------------------------------------
var button_all_selected_0: Callable = func():
	Enable_All_Item_Button_0()
	Hide_All_Item_Menues()
	item_menu_all_button_root.show()
	#-------------------------------------------------------------------------------
	Disable_Item_Button_0(item_menu_all_button_0)
	singleton.Move_to_Button(item_menu_all_button_array[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
var button_consumable_selected_0: Callable = func():
	Enable_All_Item_Button_0()
	Hide_All_Item_Menues()
	Hide_All_Item_Information_Root()
	item_menu_consumable_button_root.show()
	#-------------------------------------------------------------------------------
	item_menu_consumable_information_root.show()
	Disable_Item_Button_0(item_menu_consumable_button_0)
	singleton.Move_to_Button(item_menu_consumable_button_array[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
var button_equip_selected_0: Callable = func():
	Enable_All_Item_Button_0()
	Hide_All_Item_Menues()
	Hide_All_Item_Information_Root()
	item_menu_equip_button_root.show()
	#-------------------------------------------------------------------------------
	item_menu_equip_information_root.show()
	Disable_Item_Button_0(item_menu_equip_button_0)
	singleton.Move_to_Button(item_menu_equip_button_array[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
var button_key_selected_0: Callable = func():
	Enable_All_Item_Button_0()
	Hide_All_Item_Menues()
	Hide_All_Item_Information_Root()
	item_menu_key_button_root.show()
	#-------------------------------------------------------------------------------
	item_menu_key_information_root.show()
	Disable_Item_Button_0(item_menu_key_button_0)
	singleton.Move_to_Button(item_menu_key_button_array[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func button_empty_select_1():
	Hide_All_Item_Information_Root()
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func button_all_consumable_select_1(_item_serializable:Action_Serializable):
	button_consumable_select_1(_item_serializable)
	Move_To_Item_Information_0(item_menu_consumable_information_root)
#-------------------------------------------------------------------------------
func button_consumable_select_1(_item_serializable:Action_Serializable):
	Set_Item_Consumable_Information(_item_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func button_all_equip_select_1(_equip_serializable:Equip_Serializable):
	button_equip_select_1(_equip_serializable)
	Move_To_Item_Information_0(item_menu_equip_information_root)
#-------------------------------------------------------------------------------
func button_equip_select_1(_equip_serializable:Equip_Serializable):
	Set_Item_Equip_Information(_equip_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func button_all_key_select_1(_key_serializable:Key_Serializable):
	button_key_select_1(_key_serializable)
	Move_To_Item_Information_0(item_menu_key_information_root)
#-------------------------------------------------------------------------------
func button_key_select_1(_key_serializable:Key_Serializable):
	Set_Item_Key_Information(_key_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-ITEM MENU
#-------------------------------------------------------------------------------
func Pause_Item_Menu_Set():
	#-------------------------------------------------------------------------------
	var _submit_0: Callable = func():singleton.Common_Canceled()
	main_canvas_layer.nothing_cancel = func():Pause_Item_Menu_Main_Button_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(item_menu_all_button_0, button_all_selected_0, _submit_0)
	singleton.Set_Button(item_menu_consumable_button_0, button_consumable_selected_0, _submit_0)
	singleton.Set_Button(item_menu_equip_button_0, button_equip_selected_0, _submit_0)
	singleton.Set_Button(item_menu_key_button_0, button_key_selected_0, _submit_0)
	#-------------------------------------------------------------------------------
	var _consumable_serializable_array: Array[Action_Serializable] = item_consumable_inventory
	var _equip_serializable_array: Array[Equip_Serializable] = item_equip_inventory
	var _key_serializable_array: Array[Key_Serializable] = Get_Key_Item_Inventory()
	#-------------------------------------------------------------------------------
	Sort_Action_by_ID(_consumable_serializable_array)
	Sort_Equip_by_ID(_equip_serializable_array)
	Sort_Key_by_ID(_key_serializable_array)
	#-------------------------------------------------------------------------------
	if(_consumable_serializable_array.size() >0):
		#-------------------------------------------------------------------------------
		for _i in _consumable_serializable_array.size():
			var _hold: int = _consumable_serializable_array[_i].hold
			var _cooldown: int = 0
			#-------------------------------------------------------------------------------
			var _consumable_button: Button = Create_ConsumableItem_Button(_consumable_serializable_array[_i], _hold, _cooldown)
			var _all_button: Button = Create_ConsumableItem_Button(_consumable_serializable_array[_i], _hold, _cooldown)
			#-------------------------------------------------------------------------------
			var _consumable_select_1: Callable = func():button_consumable_select_1(_consumable_serializable_array[_i])
			var _consumable_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_consumable_button, _consumable_select_1, _consumable_submit_1, button_consumable_w, button_consumable_s, button_consumable_a, button_consumable_d)
			item_menu_consumable_button_content.add_child(_consumable_button)
			item_menu_consumable_button_array.append(_consumable_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():button_all_consumable_select_1(_consumable_serializable_array[_i])
			var _all_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_consumable_w, button_consumable_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_consumable_a, button_consumable_d)
		item_menu_consumable_button_content.add_child(_button)
		item_menu_consumable_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	if(_equip_serializable_array.size()>0):
		#-------------------------------------------------------------------------------
		for _i in _equip_serializable_array.size():
			var _equip_button: Button = Create_EquipItem_Button(_equip_serializable_array[_i])
			var _all_button: Button = Create_EquipItem_Button(_equip_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _equip_select_1: Callable = func():button_equip_select_1(_equip_serializable_array[_i])
			var _equip_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_equip_button, _equip_select_1, _equip_submit_1, button_equip_w, button_equip_s, button_equip_a, button_equip_d)
			item_menu_equip_button_content.add_child(_equip_button)
			item_menu_equip_button_array.append(_equip_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():button_all_equip_select_1(_equip_serializable_array[_i])
			var _all_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_equip_w, button_equip_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_equip_a, button_equip_d)
		item_menu_equip_button_content.add_child(_button)
		item_menu_equip_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	if(_key_serializable_array.size()>0):
		#-------------------------------------------------------------------------------
		for _i in _key_serializable_array.size():
			var _key_button: Button = Create_KeyItem_Button(_key_serializable_array[_i])
			var _all_button: Button = Create_KeyItem_Button(_key_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _key_select_1: Callable = func():button_key_select_1(_key_serializable_array[_i])
			var _key_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_key_button, _key_select_1, _key_submit_1, button_key_w, button_key_s, button_key_a, button_key_d)
			item_menu_key_button_content.add_child(_key_button)
			item_menu_key_button_array.append(_key_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():button_all_key_select_1(_key_serializable_array[_i])
			var _all_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_key_w, button_key_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_key_a, button_key_d)
		item_menu_key_button_content.add_child(_button)
		item_menu_key_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	var _all_size:int = _consumable_serializable_array.size() + _equip_serializable_array.size() + _key_serializable_array.size()
	#-------------------------------------------------------------------------------
	if(_all_size <= 0):
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_all_a, button_all_d)
		item_menu_all_button_content.add_child(_button)
		item_menu_all_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_all_button_array)
	#-------------------------------------------------------------------------------
	Show_All_Item_Button_0()
	Move_To_Item_Information_1(item_menu_consumable_information_root, item_menu_consumable_button_array.size())
	Move_To_Item_Button_List(item_menu_consumable_button_root, item_menu_consumable_button_0, item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Move_To_Item_Information_1(information_root:ScrollContainer, array_button_size: int):
	Hide_All_Item_Information_Root()
	#-------------------------------------------------------------------------------
	if(array_button_size > 0):
		information_root.show()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Move_To_Item_Information_0(information_root:ScrollContainer):
	Hide_All_Item_Information_Root()
	information_root.show()
#-------------------------------------------------------------------------------
func Move_To_Item_Button_List(_button_container:Control, _button_0:Button, _button_array:Array[Button]):
	Hide_All_Item_Menues()
	Enable_All_Item_Button_0()
	#-------------------------------------------------------------------------------
	_button_container.show()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(_button_array[0])
	Disable_Item_Button_0(_button_0)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Pause_Item_Menu_Main_All_Button_Selected():
	singleton.Common_Selected()
	Hide_All_Item_Menues()
	Hide_All_Item_Information_Root()
	item_menu_all_button_root.show()
	item_menu_consumable_information_root.show()
#-------------------------------------------------------------------------------
func Set_Item_Consumable_Information(_action_serializable:Action_Serializable):
	var _hold_text: String = Get_Hold_Text_A(_action_serializable)
	var _tp_cost_text: String = Get_TpCost_Text_A(_action_serializable.action_resource)
	var _cooldown_text: String = Get_CoolDown_Text(_action_serializable)
	var _stored_text: String = Get_Stored_Text(_action_serializable)
	#----------------------------------------------------------------------------
	item_menu_consumable_information_icon.texture = _action_serializable.action_resource.icon
	item_menu_consumable_information_name.text = Get_Tr_Consumable_Item_Name(_action_serializable.action_resource)
	#----------------------------------------------------------------------------
	item_menu_consumable_information_hold_value.text = _hold_text
	item_menu_consumable_information_stored_value.text = _stored_text
	#----------------------------------------------------------------------------
	item_menu_consumable_information_tp_cost_value.text = _tp_cost_text
	item_menu_consumable_information_cooldown_value.text = _cooldown_text
	#----------------------------------------------------------------------------
	item_menu_consumable_information_speed_value.text = str(_action_serializable.action_resource.speed)
	item_menu_consumable_information_presition_value.text = str(_action_serializable.action_resource.presition)+"%"
	#----------------------------------------------------------------------------
	item_menu_consumable_information_action_value.text = Get_Skill_Effect_Text(_action_serializable.action_resource)
	item_menu_consumable_information_target_value.text = Get_Target_Text(_action_serializable.action_resource)
	#----------------------------------------------------------------------------
	Set_Status_Rates(_action_serializable.action_resource, item_menu_consumable_information_status_name, item_menu_consumable_information_status_value)
	#----------------------------------------------------------------------------
	item_menu_consumable_information_description_value.text = Get_Tr_Consumable_Item_Description(_action_serializable.action_resource)
	item_menu_consumable_information_description_value.text += Blablabla()
	item_menu_consumable_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Set_Item_Equip_Information(_equip_serializable:Equip_Serializable):
	var _equip_resource: Equip_Resource = _equip_serializable.equip_resource
	#-------------------------------------------------------------------------------
	item_menu_equip_information_icon.texture = _equip_serializable.equip_resource.icon
	item_menu_equip_information_name.text = Get_Tr_Equip_Item_Name(_equip_serializable.equip_resource)
	#-------------------------------------------------------------------------------
	item_menu_equip_information_level_value.text = Get_Level_Required(_equip_resource.level_required)
	item_menu_equip_information_stored_value.text = "["+str(_equip_serializable.stored)+"]"
	item_menu_equip_information_class_value.text = Get_Tr_Fighter_Class_Type(_equip_resource.myFIGHTER_CLASS)
	item_menu_equip_information_type_value.text = Get_Tr_Equip_Type(_equip_resource.myEQUIP_TYPE)
	#-------------------------------------------------------------------------------
	item_menu_equip_information_statistics_name.text = ""
	item_menu_equip_information_statistics_value.text = ""
	#-------------------------------------------------------------------------------
	Set_Item_Equip_Stat("max_hp", _equip_resource.max_hp, "")
	Set_Item_Equip_Stat("physical_attack", _equip_resource.physical_attack, "")
	Set_Item_Equip_Stat("physical_defense", _equip_resource.physical_defense, "")
	Set_Item_Equip_Stat("magical_attack", _equip_resource.magical_attack, "")
	Set_Item_Equip_Stat("magical_defense", _equip_resource.magical_defense, "")
	Set_Item_Equip_Stat("luck", _equip_resource.luck, "")
	#-------------------------------------------------------------------------------
	Set_Item_Equip_Stat("physical_presition_rate", _equip_resource.physical_presition_rate, "%")
	Set_Item_Equip_Stat("physical_evasion_rate", _equip_resource.physical_evasion_rate, "%")
	Set_Item_Equip_Stat("magical_presition_rate", _equip_resource.magical_presition_rate, "%")
	Set_Item_Equip_Stat("magical_evasion_rate", _equip_resource.magical_evasion_rate, "%")
	Set_Item_Equip_Stat("critical_presition_rate", _equip_resource.critical_presition_rate, "%")
	Set_Item_Equip_Stat("critical_evasion_rate", _equip_resource.critical_evasion_rate, "%")
	#-------------------------------------------------------------------------------
	Set_Item_Equip_Stat("target_rate", _equip_resource.target_rate, "%")
	Set_Item_Equip_Stat("guard_effect", _equip_resource.guard_effect, "%")
	Set_Item_Equip_Stat("recovery_effect", _equip_resource.recovery_effect, "%")
	Set_Item_Equip_Stat("pharmacology", _equip_resource.pharmacology, "%")
	Set_Item_Equip_Stat("tp_cost_rate", _equip_resource.tp_cost_rate, "%")
	Set_Item_Equip_Stat("tp_charge_rate", _equip_resource.tp_charge_rate, "%")
	Set_Item_Equip_Stat("tp_recovery", _equip_resource.tp_recovery, "%")
	Set_Item_Equip_Stat("hp_recovery", _equip_resource.hp_recovery, "%")
	#-------------------------------------------------------------------------------
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.NORMAL, _equip_resource.normal)
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.WATER, _equip_resource.water)
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.FIRE, _equip_resource.fire)
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.EARTH, _equip_resource.earth)
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.WIND, _equip_resource.wind)
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.ICE, _equip_resource.ice)
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.THUNDER, _equip_resource.thunder)
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.LIGHT, _equip_resource.light)
	Set_Item_Equip_Element_4_Stats(Action_Resource.ELEMENT.DARK, _equip_resource.dark)
	#-------------------------------------------------------------------------------
	Set_Item_Equip_Status_Resistance_Rate(_equip_resource.status_resistance_dictionary)
	Set_Item_Equip_Skills(_equip_resource.skill_resource_array)
	#-------------------------------------------------------------------------------
	Remove_Last_Letter(item_menu_equip_information_statistics_name)
	Remove_Last_Letter(item_menu_equip_information_statistics_value)
	#-------------------------------------------------------------------------------
	Show_Line_if_String_is_Empty(item_menu_equip_information_statistics_name)
	Show_Line_if_String_is_Empty(item_menu_equip_information_statistics_value)
	#-------------------------------------------------------------------------------
	item_menu_equip_information_description_value.text = Get_Tr_Equip_Item_Description(_equip_serializable.equip_resource)
	item_menu_equip_information_description_value.text += Blablabla()
	item_menu_equip_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Get_Equip_Stored_in_Inventory(_equip_serializable_array:Array[Equip_Serializable], _equip_resource:Equip_Resource) -> int:
	#-------------------------------------------------------------------------------
	for _i in _equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_equip_serializable_array[_i].equip_resource == _equip_resource):
			return _equip_serializable_array[_i].stored
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return 0
#-------------------------------------------------------------------------------
func Set_User_Equip_Information(_equip_serializable:Equip_Serializable):
	#-------------------------------------------------------------------------------
	if(_equip_serializable.equip_resource != null):
		var _equip_resource: Equip_Resource = _equip_serializable.equip_resource
		#-------------------------------------------------------------------------------
		equip_menu_information_icon.texture = _equip_resource.icon
		equip_menu_information_name.text = Get_Tr_Equip_Item_Name(_equip_resource)
		#-------------------------------------------------------------------------------
		equip_menu_information_level_value.text = Get_Level_Required(_equip_resource.level_required)
		var _stored: int = Get_Equip_Stored_in_Inventory(item_equip_inventory, _equip_resource)
		equip_menu_information_stored_value.text = "["+str(_stored)+"]"
		equip_menu_information_class_value.text = Get_Tr_Fighter_Class_Type(_equip_resource.myFIGHTER_CLASS)
		equip_menu_information_type_value.text = Get_Tr_Equip_Type(_equip_resource.myEQUIP_TYPE)
		#-------------------------------------------------------------------------------
		equip_menu_information_statistics_name.text = ""
		equip_menu_information_statistics_value.text = ""
		#-------------------------------------------------------------------------------
		Set_User_Equip_Stat("max_hp", _equip_resource.max_hp, "")
		Set_User_Equip_Stat("physical_attack", _equip_resource.physical_attack, "")
		Set_User_Equip_Stat("physical_defense", _equip_resource.physical_defense, "")
		Set_User_Equip_Stat("magical_attack", _equip_resource.magical_attack, "")
		Set_User_Equip_Stat("magical_defense", _equip_resource.magical_defense, "")
		Set_User_Equip_Stat("luck", _equip_resource.luck, "")
		#-------------------------------------------------------------------------------
		Set_User_Equip_Stat("physical_presition_rate", _equip_resource.physical_presition_rate, "%")
		Set_User_Equip_Stat("physical_evasion_rate", _equip_resource.physical_evasion_rate, "%")
		Set_User_Equip_Stat("magical_presition_rate", _equip_resource.magical_presition_rate, "%")
		Set_User_Equip_Stat("magical_evasion_rate", _equip_resource.magical_evasion_rate, "%")
		Set_User_Equip_Stat("critical_presition_rate", _equip_resource.critical_presition_rate, "%")
		Set_User_Equip_Stat("critical_evasion_rate", _equip_resource.critical_evasion_rate, "%")
		#-------------------------------------------------------------------------------
		Set_User_Equip_Stat("target_rate", _equip_resource.target_rate, "%")
		Set_User_Equip_Stat("guard_effect", _equip_resource.guard_effect, "%")
		Set_User_Equip_Stat("recovery_effect", _equip_resource.recovery_effect, "%")
		Set_User_Equip_Stat("pharmacology", _equip_resource.pharmacology, "%")
		Set_User_Equip_Stat("tp_cost_rate", _equip_resource.tp_cost_rate, "%")
		Set_User_Equip_Stat("tp_charge_rate", _equip_resource.tp_charge_rate, "%")
		Set_User_Equip_Stat("tp_recovery", _equip_resource.tp_recovery, "%")
		Set_User_Equip_Stat("hp_recovery", _equip_resource.hp_recovery, "%")
		#-------------------------------------------------------------------------------
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.NORMAL, _equip_resource.normal)
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.WATER, _equip_resource.water)
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.FIRE, _equip_resource.fire)
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.EARTH, _equip_resource.earth)
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.WIND, _equip_resource.wind)
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.ICE, _equip_resource.ice)
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.THUNDER, _equip_resource.thunder)
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.LIGHT, _equip_resource.light)
		Set_User_Equip_Element_4_Stats(Action_Resource.ELEMENT.DARK, _equip_resource.dark)
		#-------------------------------------------------------------------------------
		Set_User_Equip_Status_Resistance_Rate(_equip_resource.status_resistance_dictionary)
		Set_User_Equip_Skills(_equip_resource.skill_resource_array)
		#-------------------------------------------------------------------------------
		Remove_Last_Letter(equip_menu_information_statistics_name)
		Remove_Last_Letter(equip_menu_information_statistics_value)
		#-------------------------------------------------------------------------------
		Show_Line_if_String_is_Empty(equip_menu_information_statistics_name)
		Show_Line_if_String_is_Empty(equip_menu_information_statistics_value)
		#-------------------------------------------------------------------------------
		equip_menu_information_description_value.text = Get_Tr_Equip_Item_Description(_equip_serializable.equip_resource)
		equip_menu_information_description_value.text += Blablabla()
		equip_menu_information_root.get_v_scroll_bar().value = 0
		equip_menu_information_root.show()
	#-------------------------------------------------------------------------------
	else:
		equip_menu_information_root.hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Level_Required(_level_required:int) -> String:
	#-------------------------------------------------------------------------------
	if(_level_required > 0):
		return str(_level_required)
	#-------------------------------------------------------------------------------
	else:
		return "-"
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_User_Status_Information(_status_serializable:Status_Serializable):
	#-------------------------------------------------------------------------------
	var _status_resource: Status_Resource = _status_serializable.status_resource
	#-------------------------------------------------------------------------------
	status_menu_information_icon.texture = _status_resource.icon
	status_menu_information_name.text = Get_Tr_Status_Effect_Name_1(_status_resource)
	#-------------------------------------------------------------------------------
	var _turns: int = clampi(_status_serializable.turns, 0, _status_resource.max_turns)
	#-------------------------------------------------------------------------------
	if(_status_resource.is_infinite):
		status_menu_information_turns_value.text ="-"
	#-------------------------------------------------------------------------------
	else:
		status_menu_information_turns_value.text ="["+str(_turns)+"/"+str(_status_resource.max_turns)+"]"
	#-------------------------------------------------------------------------------
	status_menu_information_statistics_name.text = ""
	status_menu_information_statistics_value.text = ""
	#-------------------------------------------------------------------------------
	Set_User_Status_Stat("max_hp", _status_resource.max_hp, "")
	Set_User_Status_Stat("physical_attack", _status_resource.physical_attack, "")
	Set_User_Status_Stat("physical_defense", _status_resource.physical_defense, "")
	Set_User_Status_Stat("magical_attack", _status_resource.magical_attack, "")
	Set_User_Status_Stat("magical_defense", _status_resource.magical_defense, "")
	Set_User_Status_Stat("luck", _status_resource.luck, "")
	#-------------------------------------------------------------------------------
	Set_User_Status_Stat("physical_presition_rate", _status_resource.physical_presition_rate, "%")
	Set_User_Status_Stat("physical_evasion_rate", _status_resource.physical_evasion_rate, "%")
	Set_User_Status_Stat("magical_presition_rate", _status_resource.magical_presition_rate, "%")
	Set_User_Status_Stat("magical_evasion_rate", _status_resource.magical_evasion_rate, "%")
	Set_User_Status_Stat("critical_presition_rate", _status_resource.critical_presition_rate, "%")
	Set_User_Status_Stat("critical_evasion_rate", _status_resource.critical_evasion_rate, "%")
	#-------------------------------------------------------------------------------
	Set_User_Status_Stat("target_rate", _status_resource.target_rate, "%")
	Set_User_Status_Stat("guard_effect", _status_resource.guard_effect, "%")
	Set_User_Status_Stat("recovery_effect", _status_resource.recovery_effect, "%")
	Set_User_Status_Stat("pharmacology", _status_resource.pharmacology, "%")
	Set_User_Status_Stat("tp_cost_rate", _status_resource.tp_cost_rate, "%")
	Set_User_Status_Stat("tp_charge_rate", _status_resource.tp_charge_rate, "%")
	Set_User_Status_Stat("tp_recovery", _status_resource.tp_recovery, "%")
	Set_User_Status_Stat("hp_recovery", _status_resource.hp_recovery, "%")
	#-------------------------------------------------------------------------------
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.NORMAL, _status_resource.normal)
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.WATER, _status_resource.water)
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.FIRE, _status_resource.fire)
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.EARTH, _status_resource.earth)
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.WIND, _status_resource.wind)
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.ICE, _status_resource.ice)
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.THUNDER, _status_resource.thunder)
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.LIGHT, _status_resource.light)
	Set_User_Status_Element_4_Stats(Action_Resource.ELEMENT.DARK, _status_resource.dark)
	#-------------------------------------------------------------------------------
	Set_User_Status_Status_Resistance_Rate(_status_resource.status_resistance_dictionary)
	Set_User_Status_Skills(_status_resource.skill_resource_array)
	#-------------------------------------------------------------------------------
	Remove_Last_Letter(status_menu_information_statistics_name)
	Remove_Last_Letter(status_menu_information_statistics_value)
	#-------------------------------------------------------------------------------
	Show_Line_if_String_is_Empty(status_menu_information_statistics_name)
	Show_Line_if_String_is_Empty(status_menu_information_statistics_value)
	#-------------------------------------------------------------------------------
	status_menu_information_description_value.text = Get_Tr_Status_Effect_Description(_status_resource)
	status_menu_information_description_value.text += Blablabla()
	status_menu_information_root.get_v_scroll_bar().value = 0
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Item_Equip_Stat(_name:String, _int:int, _unit: String):
	Set_Equip_Stat(item_menu_equip_information_statistics_name, _name, item_menu_equip_information_statistics_value, _int, _unit)
#-------------------------------------------------------------------------------
func Set_User_Equip_Stat(_name:String, _int:int, _unit: String):
	Set_Equip_Stat(equip_menu_information_statistics_name, _name, equip_menu_information_statistics_value, _int, _unit)
#-------------------------------------------------------------------------------
func Set_User_Status_Stat(_name:String, _int:int, _unit: String):
	Set_Equip_Stat(status_menu_information_statistics_name, _name, status_menu_information_statistics_value, _int, _unit)
#-------------------------------------------------------------------------------
func Set_Equip_Stat(_name_label:Label, _name:String, _value_label:Label, _int:int, _unit: String):
	#-------------------------------------------------------------------------------
	if(_int == 0):
		return
	#-------------------------------------------------------------------------------
	_name_label.text += String_With_Asterisco_and_2_Points(tr(_name))+"\n"
	_value_label.text += Get_Number_with_Sign(_int)+_unit+"\n"
#-------------------------------------------------------------------------------
func Set_Item_Equip_Element_4_Stats(_element_type:Action_Resource.ELEMENT, _element:Vector4i):
	Set_Equip_Element_4_Stats(item_menu_equip_information_statistics_name, _element_type, item_menu_equip_information_statistics_value, _element)
#-------------------------------------------------------------------------------
func Set_User_Equip_Element_4_Stats(_element_type:Action_Resource.ELEMENT, _element:Vector4i):
	Set_Equip_Element_4_Stats(equip_menu_information_statistics_name, _element_type, equip_menu_information_statistics_value, _element)
#-------------------------------------------------------------------------------
func Set_User_Status_Element_4_Stats(_element_type:Action_Resource.ELEMENT, _element:Vector4i):
	Set_Equip_Element_4_Stats(status_menu_information_statistics_name, _element_type, status_menu_information_statistics_value, _element)
#-------------------------------------------------------------------------------
func Set_Equip_Element_4_Stats(_name_label:Label, _element_type:Action_Resource.ELEMENT, _value_label:Label, _element:Vector4i):
	#-------------------------------------------------------------------------------
	var _element_name: String = Get_Tr_Element(_element_type)
	if(_element.x != 0):
		var _name: String = _element_name+" ("+tr("power_text")+")"
		_name_label.text += String_With_Asterisco_and_2_Points(_name)+"\n"
		_value_label.text += Get_Number_with_Sign(_element.x)+"%"+"\n"
	#-------------------------------------------------------------------------------
	if(_element.y != 0):
		var _name: String = _element_name+" ("+tr("absortion_text")+")"
		_name_label.text += String_With_Asterisco_and_2_Points(_name)+"\n"
		_value_label.text += Get_Number_with_Sign(_element.y)+"%"+"\n"
	#-------------------------------------------------------------------------------
	if(_element.z != 0):
		var _name: String = _element_name+" ("+tr("affinity_text")+")"
		_name_label.text += String_With_Asterisco_and_2_Points(_name)+"\n"
		_value_label.text += Get_Number_with_Sign(_element.z)+"%"+"\n"
	#-------------------------------------------------------------------------------
	if(_element.w != 0):
		var _name: String = _element_name+" ("+tr("repulsion_text")+")"
		_name_label.text += String_With_Asterisco_and_2_Points(_name)+"\n"
		_value_label.text += Get_Number_with_Sign(_element.w)+"%"+"\n"
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Item_Equip_Status_Resistance_Rate(_status_dictionary:Dictionary[StringName, int]):
	Set_Equip_Status_Resistance_Rate(item_menu_equip_information_statistics_name, item_menu_equip_information_statistics_value, _status_dictionary)
#-------------------------------------------------------------------------------
func Set_User_Equip_Status_Resistance_Rate(_status_dictionary:Dictionary[StringName, int]):
	Set_Equip_Status_Resistance_Rate(equip_menu_information_statistics_name, equip_menu_information_statistics_value, _status_dictionary)
#-------------------------------------------------------------------------------
func Set_User_Status_Status_Resistance_Rate(_status_dictionary:Dictionary[StringName, int]):
	Set_Equip_Status_Resistance_Rate(status_menu_information_statistics_name, status_menu_information_statistics_value, _status_dictionary)
#-------------------------------------------------------------------------------
func Set_Equip_Status_Resistance_Rate(_name_label:Label, _value_label:Label, _status_dictionary:Dictionary[StringName, int]):
	#-------------------------------------------------------------------------------
	for _i in _status_dictionary.size():
		var _key: StringName = _status_dictionary.keys()[_i]
		var _value: int = _status_dictionary.values()[_i]
		var _name: StringName = Get_Tr_Status_Effect_Name_0(_key)+" ("+tr("resistance_text")+")"
		_name_label.text += String_With_Asterisco_and_2_Points(_name)+"\n"
		_value_label.text += Get_Number_with_Sign(_value)+"%"+"\n"
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Item_Equip_Skills(_skill_resource_array:Array[Action_Resource]):
	Set_Equip_Skills(item_menu_equip_information_statistics_name, item_menu_equip_information_statistics_value, _skill_resource_array)
#-------------------------------------------------------------------------------
func Set_User_Equip_Skills(_skill_resource_array:Array[Action_Resource]):
	Set_Equip_Skills(equip_menu_information_statistics_name, equip_menu_information_statistics_value, _skill_resource_array)
#-------------------------------------------------------------------------------
func Set_User_Status_Skills(_skill_resource_array:Array[Action_Resource]):
	Set_Equip_Skills(status_menu_information_statistics_name, status_menu_information_statistics_value, _skill_resource_array)
#-------------------------------------------------------------------------------
func Set_Equip_Skills(_name_label:Label, _value_label:Label, _skill_resource_array:Array[Action_Resource]):
	#-------------------------------------------------------------------------------
	for _i in _skill_resource_array.size():
		_name_label.text += String_With_Asterisco_and_2_Points("+ "+tr("pause_menu_button_skill"))+"\n"
		_value_label.text += Get_Tr_Skill_Name(_skill_resource_array[_i])+"\n"
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Number_with_Sign(_int:int) -> String:
	var _s:String = ""
	if(_int > 0):
		return "+"+str(_int)
	#-------------------------------------------------------------------------------
	else:
		return str(_int)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Item_Key_Information(_key_serializable:Key_Serializable):
	item_menu_key_information_icon.texture = _key_serializable.key_resource.icon
	item_menu_key_information_name.text = Get_Tr_Key_Item_Name(_key_serializable.key_resource)
	#-------------------------------------------------------------------------------
	item_menu_key_information_stored_value.text = "["+str(_key_serializable.stored)+"]"
	item_menu_key_information_description_value.text = Get_Tr_Key_Item_Description(_key_serializable.key_resource)
	item_menu_key_information_description_value.text += Blablabla()
	item_menu_key_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Pause_Item_Menu_Main_Consumable_Button_Selected():
	singleton.Common_Selected()
	Hide_All_Item_Menues()
	Hide_All_Item_Information_Root()
	item_menu_consumable_button_root.show()
	item_menu_consumable_information_root.show()
#-------------------------------------------------------------------------------
func Pause_Item_Menu_Main_Equip_Button_Selected():
	singleton.Common_Selected()
	Hide_All_Item_Menues()
	Hide_All_Item_Information_Root()
	item_menu_equip_button_root.show()
	item_menu_equip_information_root.show()
#-------------------------------------------------------------------------------
func Pause_Item_Menu_Main_Key_Button_Selected():
	singleton.Common_Selected()
	Hide_All_Item_Menues()
	Hide_All_Item_Information_Root()
	item_menu_key_button_root.show()
	item_menu_key_information_root.show()
#-------------------------------------------------------------------------------
func Hide_All_Item_Menues():
	item_menu_all_button_root.hide()
	item_menu_consumable_button_root.hide()
	item_menu_equip_button_root.hide()
	item_menu_key_button_root.hide()
#-------------------------------------------------------------------------------
func Enable_All_Item_Button_0():
	Enable_Item_Button_0(item_menu_all_button_0)
	Enable_Item_Button_0(item_menu_consumable_button_0)
	Enable_Item_Button_0(item_menu_equip_button_0)
	Enable_Item_Button_0(item_menu_key_button_0)
#-------------------------------------------------------------------------------
func Hide_All_Item_Button_0():
	item_menu_all_button_0.hide()
	item_menu_consumable_button_0.hide()
	item_menu_equip_button_0.hide()
	item_menu_key_button_0.hide()
#-------------------------------------------------------------------------------
func Show_All_Item_Button_0():
	item_menu_all_button_0.show()
	item_menu_consumable_button_0.show()
	item_menu_equip_button_0.show()
	item_menu_key_button_0.show()
#-------------------------------------------------------------------------------
func Enable_Item_Button_0(_button:Button):
	_button.disabled = false
	_button.focus_mode = Control.FOCUS_ALL
#-------------------------------------------------------------------------------
func Disable_Item_Button_0(_button:Button):
	_button.disabled = true
	_button.focus_mode = Control.FOCUS_NONE
#-------------------------------------------------------------------------------
func Hide_All_Item_Information_Root():
	item_menu_consumable_information_root.hide()
	item_menu_equip_information_root.hide()
	item_menu_key_information_root.hide()
#-------------------------------------------------------------------------------
func Pause_Item_Menu_Main_Button_Cancel():
	singleton.Destroy_Button_Array(item_menu_all_button_array)
	singleton.Destroy_Button_Array(item_menu_consumable_button_array)
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	singleton.Destroy_Button_Array(item_menu_key_button_array)
	pause_menu.show()
	item_menu.hide()
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Close()
	singleton.Move_to_Button_by_Cancel(pause_menu_button_item)
#-------------------------------------------------------------------------------
func Create_ConsumableItem_Button(_item_serializable: Action_Serializable, _hold:int, _cooldown:int) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = Get_Tr_Consumable_Item_Name(_item_serializable.action_resource)+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_button.icon = _item_serializable.action_resource.icon
	#-------------------------------------------------------------------------------
	var _label2: RichTextLabel = RichTextLabel.new()
	_label2.bbcode_enabled = true
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.mouse_filter = Control.MOUSE_FILTER_PASS
	_label2.text = ""
	#-------------------------------------------------------------------------------
	var _font_size:String = "[font_size=16]"
	var _no_font_size:String = "[/font_size]"
	#-------------------------------------------------------------------------------
	if(_cooldown <= 0 or _item_serializable.action_resource.max_cooldown <= 0):
		#-------------------------------------------------------------------------------
		if(_item_serializable.action_resource.tp_cost > 0):
			_label2.text += _font_size+Get_Tr_TP_Cost_Text(_item_serializable.action_resource.tp_cost)+"  "+_no_font_size
		#-------------------------------------------------------------------------------
		var _max_hold: int = _item_serializable.action_resource.max_hold
		#-------------------------------------------------------------------------------
		if(_max_hold > 0):
			var _s: String = _font_size+"[lb]"+str(_hold)+"/"+str(_max_hold)+"[rb]"+"  "+_no_font_size
			#-------------------------------------------------------------------------------
			if(_hold < _item_serializable.hold):
				_label2.text += "[color="+hex_color_yellow+"]"+_s+"[/color]"
			#-------------------------------------------------------------------------------
			else:
				_label2.text += _s
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _s: String = _font_size+Get_Tr_CD_Text(_cooldown)+"  "+_no_font_size
		#-------------------------------------------------------------------------------
		if(_cooldown > _item_serializable.cooldown):
			_label2.text = "[color="+hex_color_yellow+"]"+_s+"[/color]"
		#-------------------------------------------------------------------------------
		else:
			_label2.text = _s
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_EquipItem_Button(_equip_serializable: Equip_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = Get_Tr_Equip_Item_Name(_equip_serializable.equip_resource)+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_button.icon = _equip_serializable.equip_resource.icon
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.add_theme_font_size_override("font_size", 16)
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = "["+str(_equip_serializable.stored)+"]  "
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_KeyItem_Button(_key_serializable: Key_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = Get_Tr_Key_Item_Name(_key_serializable.key_resource)+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_button.icon = _key_serializable.key_resource.icon
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.add_theme_font_size_override("font_size", 16)
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = "["+str(_key_serializable.stored)+"]  "
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-EQUIP MENU
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Set(_fighter_index:int):
	main_canvas_layer.nothing_cancel = func():Pause_Equip_Menu_Main_Button_Cancel(_fighter_index)
	#-------------------------------------------------------------------------------
	var _fighter_serializable: Fighter_Serializable = ally_party[_fighter_index].fighter_serializable
	var _equip_serializable_array: Array[Equip_Serializable] = _fighter_serializable.equip_serializable_array
	#-------------------------------------------------------------------------------
	if(_equip_serializable_array.size() > 0):
		equip_menu_button_type.show()
		equip_menu_button_type.text = ""
		#-------------------------------------------------------------------------------
		for _i in _equip_serializable_array.size():
			var _button: Button = Create_EquipSlot_Button(_equip_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _w: Callable = func():Pause_Equip_Menu_Button_W(_equip_serializable_array[_i])
			var _s: Callable = func():Pause_Equip_Menu_Button_S(_equip_serializable_array[_i])
			var _selected_1: Callable = func():Pause_Equip_Menu_Button_Selected(_equip_serializable_array[_i])
			var _submit_1: Callable = func():Pause_Equip_Menu_Equip_Slot_Submit(_fighter_index, _i)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WS(_button, _selected_1, _submit_1, _w, _s)
			equip_menu_button_content.add_child(_button)
			equip_menu_button_array.append(_button)
			#-------------------------------------------------------------------------------
			equip_menu_button_type.text += "* "+Get_Tr_Equip_Type(_equip_serializable_array[_i].myEQUIP_TYPE)+":  "+"\n"
		#-------------------------------------------------------------------------------
		Remove_Last_Letter(equip_menu_button_type)
		#-------------------------------------------------------------------------------
		equip_menu_information_root.show()
	#-------------------------------------------------------------------------------
	else:
		equip_menu_button_type.hide()
		#-------------------------------------------------------------------------------
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _selected: Callable = func():singleton.Common_Selected()
		var _submit: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button(_button, _selected, _submit)
		equip_menu_button_content.add_child(_button)
		equip_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		equip_menu_information_root.hide()
	#-------------------------------------------------------------------------------
	Disable_Item_Button_0(equip_menu_button_0)
	singleton.Button_Array_Set_Vertical_Navigation(equip_menu_button_array)
	singleton.Move_to_Button_by_Submit(equip_menu_button_array[0])
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Button_W(_equip_serializable:Equip_Serializable):
	#-------------------------------------------------------------------------------
	if(_equip_serializable.equip_resource != null):
		singleton.ScrollContainer_Up(equip_menu_information_root)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Button_S(_equip_serializable:Equip_Serializable):
	#-------------------------------------------------------------------------------
	if(_equip_serializable.equip_resource != null):
		singleton.ScrollContainer_Down(equip_menu_information_root)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Button_Selected(_equip_serializable:Equip_Serializable):
	Set_User_Equip_Information(_equip_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Equip_Slot_Submit(_fighter_index:int, _equip_index:int):
	equip_menu.hide()
	item_menu.show()
	#-------------------------------------------------------------------------------
	var _empty_button: Button = Create_EquipEmpty_Button()
	#-------------------------------------------------------------------------------
	var _selected_0: Callable = func():
		item_menu_equip_information_root.hide()
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	var _submit_0: Callable = func():Pause_Equip_Menu_Equip_Slot_Equip_Empty_Submit(_fighter_index, _equip_index)
	main_canvas_layer.nothing_cancel = func():Pause_Equip_Menu_Equip_Slot_Equip_Item_Cancel(_fighter_index, _equip_index)
	#-------------------------------------------------------------------------------
	singleton.Set_Button(_empty_button, _selected_0, _submit_0)
	item_menu_equip_button_content.add_child(_empty_button)
	item_menu_equip_button_array.append(_empty_button)
	#-------------------------------------------------------------------------------
	var _current_Fighter: Fighter_Serializable = ally_party[_fighter_index].fighter_serializable
	var _current_equip_slot: Equip_Serializable = _current_Fighter.equip_serializable_array[_equip_index]
	#-------------------------------------------------------------------------------
	for _i in item_equip_inventory.size():
		if(Is_Weapon_Avalible_to_be_Equipable(item_equip_inventory[_i].equip_resource, _current_equip_slot, _current_Fighter.fighter_resource.myFIGHTER_CLASS)):
			var _button: Button = Create_EquipItem_Button(item_equip_inventory[_i])
			#-------------------------------------------------------------------------------
			var _w_1: Callable = func():singleton.ScrollContainer_Up(item_menu_equip_information_root)
			var _s_1: Callable = func():singleton.ScrollContainer_Down(item_menu_equip_information_root)
			#-------------------------------------------------------------------------------
			var _selected_1: Callable = func():
				Set_Item_Equip_Information(item_equip_inventory[_i])
				item_menu_equip_information_root.show()
				singleton.Common_Selected()
			#-------------------------------------------------------------------------------
			var _submit_1: Callable = func(): Pause_Equip_Menu_Equip_Slot_Equip_Item_Submit(_fighter_index, _equip_index, item_equip_inventory[_i])
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WS(_button, _selected_1, _submit_1, _w_1, _s_1)
			item_menu_equip_button_content.add_child(_button)
			item_menu_equip_button_array.append(_button)
			#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	Hide_All_Item_Button_0()
	item_menu_equip_button_0.show()
	Disable_Item_Button_0(item_menu_equip_button_0)
	Hide_All_Item_Menues()
	item_menu_equip_button_root.show()
	Move_To_Item_Information_0(item_menu_equip_information_root)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button_by_Submit(item_menu_equip_button_array[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Is_Weapon_Avalible_to_be_Equipable(_equip_resource:Equip_Resource, _equip_serializable:Equip_Serializable, _myFIGHTER_CLASS:Fighter_Resource.FIGHTER_CLASS) -> bool:
	if(_equip_resource.myEQUIP_TYPE == _equip_serializable.myEQUIP_TYPE):
		#-------------------------------------------------------------------------------
		if(_equip_resource.myFIGHTER_CLASS == Fighter_Resource.FIGHTER_CLASS.EVERYONE or _equip_resource.myFIGHTER_CLASS == _myFIGHTER_CLASS):
			return true
		#-------------------------------------------------------------------------------
		else:
			return false
	#-------------------------------------------------------------------------------
	else:
		return false
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Equip_Slot_Equip_Item_Submit(_fighter_index:int, _equip_index:int, _equip_serializable:Equip_Serializable):
	item_menu.hide()
	equip_menu.show()
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	var _equip_slot: Equip_Serializable = ally_party[_fighter_index].fighter_serializable.equip_serializable_array[_equip_index]
	#-------------------------------------------------------------------------------
	if(_equip_slot.equip_resource != null):
		Add_Equip_Item_To_Inventory(_equip_slot.equip_resource, 1)
	#-------------------------------------------------------------------------------
	Remove_Equip_Item_From_Inventory(_equip_serializable.equip_resource, 1)
	Equip_Item_to_Fighter(_fighter_index, _equip_index, _equip_serializable)
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Equip_Menu_Main_Button_Cancel(_fighter_index)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button_by_Equip(equip_menu_button_array[_equip_index])
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Equip_Slot_Equip_Empty_Submit(_fighter_index:int, _equip_index:int):
	item_menu.hide()
	equip_menu.show()
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	var _current_equip_slot: Equip_Serializable = ally_party[_fighter_index].fighter_serializable.equip_serializable_array[_equip_index]
	#-------------------------------------------------------------------------------
	if(_current_equip_slot.equip_resource != null):
		Add_Equip_Item_To_Inventory(_current_equip_slot.equip_resource, 1)
	#-------------------------------------------------------------------------------
	Unequip_Item_to_Fighter(_fighter_index, _equip_index)
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Equip_Menu_Main_Button_Cancel(_fighter_index)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button_by_Unequip(equip_menu_button_array[_equip_index])
#-------------------------------------------------------------------------------
func Equip_Item_to_Fighter(_fighter_index:int, _equip_index:int, _equip_serializable:Equip_Serializable):
	var _equip_slot: Equip_Serializable = ally_party[_fighter_index].fighter_serializable.equip_serializable_array[_equip_index]
	_equip_slot.equip_resource = _equip_serializable.equip_resource
	_equip_slot.stored = 1
	equip_menu_button_array[_equip_index].icon = _equip_serializable.equip_resource.icon
	equip_menu_button_array[_equip_index].text = "  "+Get_Tr_Equip_Item_Name(_equip_slot.equip_resource)+"  "
#-------------------------------------------------------------------------------
func Unequip_Item_to_Fighter(_fighter_index:int, _equip_index:int):
	var _equip_slot: Equip_Serializable = ally_party[_fighter_index].fighter_serializable.equip_serializable_array[_equip_index]
	_equip_slot.equip_resource = null
	_equip_slot.stored = 0
	equip_menu_button_array[_equip_index].icon = null
	equip_menu_button_array[_equip_index].text = "  ["+Get_Tr_Equip_Null_Name()+"]  "
#-------------------------------------------------------------------------------
func Remove_Equip_Item_From_Inventory(_equip_resource:Equip_Resource, _remove:int):
	#-------------------------------------------------------------------------------
	for _i in item_equip_inventory.size():
		#-------------------------------------------------------------------------------
		if(item_equip_inventory[_i].equip_resource == _equip_resource):
			item_equip_inventory[_i].stored -= _remove
			#-------------------------------------------------------------------------------
			if(item_equip_inventory[_i].stored <= 0):
				item_equip_inventory.remove_at(_i)
			#-------------------------------------------------------------------------------
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Add_Equip_Item_To_Inventory(_equip_resource:Equip_Resource, _add:int):
	#-------------------------------------------------------------------------------
	for _i in item_equip_inventory.size():
		#-------------------------------------------------------------------------------
		if(item_equip_inventory[_i].equip_resource == _equip_resource):
			item_equip_inventory[_i].stored += _add
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
	_equip_serializable.equip_resource = _equip_resource
	_equip_serializable.myEQUIP_TYPE = _equip_resource.myEQUIP_TYPE
	_equip_serializable.stored = _add
	#-------------------------------------------------------------------------------
	item_equip_inventory.append(_equip_serializable)
	return
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Equip_Slot_Equip_Item_Cancel(_fighter_index:int, _equip_index:int):
	item_menu.hide()
	equip_menu.show()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Equip_Menu_Main_Button_Cancel(_fighter_index)
	#-------------------------------------------------------------------------------
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	singleton.Move_to_Button_by_Cancel(equip_menu_button_array[_equip_index])
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Main_Button_Cancel(_fighter_index:int):
	singleton.Destroy_Button_Array(equip_menu_button_array)
	pause_menu.show()
	equip_menu.hide()
	Fighter_Button_Set_HP(ally_button_array[_fighter_index], ally_party[_fighter_index].fighter_serializable)
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Menu_Equip_Fighter_Button_Cancel()
	#-------------------------------------------------------------------------------
	var _button: Button = ally_button_array[_fighter_index] as Button
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
func Create_EquipEmpty_Button() -> Button:
	var _empty_button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_empty_button.icon = null
	_empty_button.text = "  ["+Get_Tr_Equip_Null_Name()+"]  "
	_empty_button.add_theme_font_size_override("font_size", button_array_font_size)
	_empty_button.custom_minimum_size.y = button_array_minimum_size_y
	_empty_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	#-------------------------------------------------------------------------------
	return _empty_button
#-------------------------------------------------------------------------------
func Create_EquipSlot_Button(_equip_serializable: Equip_Serializable) -> Button:
	var _button: Button
	#-------------------------------------------------------------------------------
	if(_equip_serializable.equip_resource == null):
		_button = Create_EquipEmpty_Button()
	#-------------------------------------------------------------------------------
	else:
		_button = Button.new()
		#-------------------------------------------------------------------------------
		_button.text = Get_Tr_Equip_Item_Name(_equip_serializable.equip_resource)+"  "
		_button.add_theme_font_size_override("font_size", button_array_font_size)
		_button.custom_minimum_size.y = button_array_minimum_size_y
		_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		_button.icon = _equip_serializable.equip_resource.icon
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-STATUS-EFFECT MENU
#-------------------------------------------------------------------------------
func Pause_Status_Menu_Set(_fighter_serializable: Fighter_Serializable, _cancel:Callable):
	var _status_serializable_array: Array[Status_Serializable] = Get_Status_Serializable_Array(_fighter_serializable)
	#-------------------------------------------------------------------------------
	Sort_Status_by_ID(_status_serializable_array)
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = _cancel
	#-------------------------------------------------------------------------------
	if(_status_serializable_array.size() > 0):
		#-------------------------------------------------------------------------------
		for _i in _status_serializable_array.size():
			var _button: Button = Create_StatusEffect_Serializable_Button(_status_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _w: Callable = func():singleton.ScrollContainer_Up(status_menu_information_root)
			var _s: Callable = func():singleton.ScrollContainer_Down(status_menu_information_root)
			#-------------------------------------------------------------------------------
			var _selected: Callable = func():
				singleton.Common_Selected()
				Set_User_Status_Information(_status_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _submit: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WS(_button, _selected, _submit, _w, _s)
			status_menu_button_content.add_child(_button)
			status_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		status_menu_information_root.show()
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		var _selected: Callable = func():singleton.Common_Selected()
		var _submit: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		var _button:Button = Create_Empty_Button()
		singleton.Set_Button(_button, _selected, _submit)
		status_menu_button_content.add_child(_button)
		status_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		status_menu_information_root.hide()
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(status_menu_button_array)
	Disable_Item_Button_0(status_menu_button_0)
	singleton.Move_to_Button_by_Submit(status_menu_button_array[0])
#-------------------------------------------------------------------------------
func Create_StatusEffect_Serializable_Button(_status_serializable: Status_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = Get_Tr_Status_Effect_Name_1(_status_serializable.status_resource)+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_button.icon = _status_serializable.status_resource.icon
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.add_theme_font_size_override("font_size", 16)
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#-------------------------------------------------------------------------------
	if(_status_serializable.status_resource.is_infinite):
		#∞, ꝏ, Ꝏ
		_label2.text = "[Ꝏ]  "
	#-------------------------------------------------------------------------------
	else:
		var _turns: int = clampi(_status_serializable.turns, 0, _status_serializable.status_resource.max_turns)
		_label2.text = "["+str(_turns)+"/"+str(_status_serializable.status_resource.max_turns)+"]  "
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_Empty_Button() -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = ""
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Pause_Status_Menu_Status_Button_Cancel(_fighter_index:int):
	singleton.Destroy_Button_Array(status_menu_button_array)
	status_menu.hide()
	pause_menu.show()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): Pause_Menu_Status_Fighter_Button_Cancel()
	#-------------------------------------------------------------------------------
	var _button:Button = ally_button_array[_fighter_index] as Button
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-STATISTICS MENU
#-------------------------------------------------------------------------------
func Pause_Statistics_Menu_Set(_fighter_node: Fighter_Node, _fighter_serializable: Fighter_Serializable, _cancel:Callable):
	#-------------------------------------------------------------------------------
	var _w: Callable = func(): singleton.ScrollContainer_Up(statistics_menu_information_root)
	var _s: Callable = func(): singleton.ScrollContainer_Down(statistics_menu_information_root)
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit: Callable = func():pass
	main_canvas_layer.nothing_cancel = _cancel
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WS_Up_Down(statistics_menu_button_0, _selected, _submit, _w, _s)
	#-------------------------------------------------------------------------------
	var _character: Character_Resource = _fighter_node.character_node.character_resource
	statistics_menu_information_fighter_face.texture = _character.face
	#-------------------------------------------------------------------------------
	statistics_menu_information_fighter_name.text = Get_Tr_Character_Name(_character)
	statistics_menu_information_fighter_title.text = Get_Tr_Character_Title(_character)
	#-------------------------------------------------------------------------------
	var _max_hp: int = Get_Max_HP(_fighter_serializable)
	statistics_menu_information_fighter_hp_value.text = Get_Fighter_Hp_Text(_max_hp, _max_hp)
	statistics_menu_information_fighter_hp_slider.max_value = _max_hp
	statistics_menu_information_fighter_hp_slider.value = _max_hp
	#-------------------------------------------------------------------------------
	statistics_menu_information_level_value.text = Get_Tr_Fighter_Class_Type(_fighter_serializable.fighter_resource.myFIGHTER_CLASS)+"\n"
	statistics_menu_information_level_value.text += str(_fighter_serializable.level)+"\n"
	var _max_experience: int = Get_Max_Experience(_fighter_serializable)
	var _experience: int = clampi(_fighter_serializable.experience, 0, _max_experience-1)
	statistics_menu_information_level_value.text += singleton.format_number_with_dots(_experience)+"\n"
	statistics_menu_information_level_value.text += singleton.format_number_with_dots(_max_experience)
	#-------------------------------------------------------------------------------
	statistics_menu_information_base_stats_name.text = ""
	statistics_menu_information_base_stats_value.text = ""
	Set_Fighter_Base_Stat("max_hp", _max_hp)
	Set_Fighter_Base_Stat("physical_attack", Get_Physical_Attack(_fighter_serializable))
	Set_Fighter_Base_Stat("physical_defense", Get_Physical_Defense(_fighter_serializable))
	Set_Fighter_Base_Stat("magical_attack", Get_Magical_Attack(_fighter_serializable))
	Set_Fighter_Base_Stat("magical_defense", Get_Magical_Defense(_fighter_serializable))
	Set_Fighter_Base_Stat("luck", Get_Luck(_fighter_serializable))
	Remove_Last_Letter(statistics_menu_information_base_stats_name)
	Remove_Last_Letter(statistics_menu_information_base_stats_value)
	#-------------------------------------------------------------------------------
	statistics_menu_information_extra_stats_name.text = ""
	statistics_menu_information_extra_stats_value.text = ""
	Set_Fighter_Extra_Stat("physical_presition_rate", Get_Physical_Presition_Rate(_fighter_serializable))
	Set_Fighter_Extra_Stat("physical_evasion_rate", Get_Physical_Evasion_Rate(_fighter_serializable))
	Set_Fighter_Extra_Stat("magical_presition_rate", Get_Magical_Presition_Rate(_fighter_serializable))
	Set_Fighter_Extra_Stat("magical_evasion_rate", Get_Magical_Evasion_Rate(_fighter_serializable))
	Set_Fighter_Extra_Stat("critical_presition_rate", Get_Crítical_Presition_Rate(_fighter_serializable))
	Set_Fighter_Extra_Stat("critical_evasion_rate", Get_Crítical_Evasion_Rate(_fighter_serializable))
	Remove_Last_Letter(statistics_menu_information_extra_stats_name)
	Remove_Last_Letter(statistics_menu_information_extra_stats_value)
	#-------------------------------------------------------------------------------
	statistics_menu_information_special_stats_name.text = ""
	statistics_menu_information_special_stats_value.text = ""
	Set_Fighter_Special_Stat("target_rate", Get_Target_Rate(_fighter_serializable))
	Set_Fighter_Special_Stat("guard_effect", Get_Guard_Effect(_fighter_serializable))
	Set_Fighter_Special_Stat("recovery_effect", Get_Recovery_Effect(_fighter_serializable))
	Set_Fighter_Special_Stat("pharmacology", Get_Pharmacology(_fighter_serializable))
	Set_Fighter_Special_Stat("tp_cost_rate", Get_TP_Cost_Rate(_fighter_serializable))
	Set_Fighter_Special_Stat("tp_charge_rate", Get_TP_Charge_Rate(_fighter_serializable))
	Set_Fighter_Special_Stat("tp_recovery", Get_TP_Recovery(_fighter_serializable))
	Set_Fighter_Special_Stat("hp_recovery", Get_HP_Recovery(_fighter_serializable))
	Remove_Last_Letter(statistics_menu_information_special_stats_name)
	Remove_Last_Letter(statistics_menu_information_special_stats_value)
	#-------------------------------------------------------------------------------
	Set_Fighter_Equip_Stats(_fighter_serializable.equip_serializable_array)
	Set_Fighter_Skill_List(_fighter_serializable)
	Set_Fighter_Status_Resistance(_fighter_serializable)
	Set_Fighter_All_Elemental_Rate(_fighter_serializable)
	Set_Fighter_Description(_character)
#-------------------------------------------------------------------------------
func Set_Fighter_Base_Stat(_name:String, _int:int):
	statistics_menu_information_base_stats_name.text += String_With_Asterisco_and_2_Points(tr(_name))+"\n"
	statistics_menu_information_base_stats_value.text += str(_int)+"\n"
#-------------------------------------------------------------------------------
func Set_Fighter_Extra_Stat(_name:String, _int:int):
	statistics_menu_information_extra_stats_name.text += String_With_Asterisco_and_2_Points(tr(_name))+"\n"
	statistics_menu_information_extra_stats_value.text += str(_int)+"%"+"\n"
#-------------------------------------------------------------------------------
func Set_Fighter_Special_Stat(_name:String, _int:int):
	statistics_menu_information_special_stats_name.text += String_With_Asterisco_and_2_Points(tr(_name))+"\n"
	statistics_menu_information_special_stats_value.text += str(_int)+"%"+"\n"
#-------------------------------------------------------------------------------
func Set_Fighter_Equip_Stats(_equip_serializable_array:Array[Equip_Serializable]):
	statistics_menu_information_equip_type.text = ""
	statistics_menu_information_equip_value.text = ""
	#-------------------------------------------------------------------------------
	for _i in _equip_serializable_array.size():
		var _name: String = Get_Tr_Equip_Type(_equip_serializable_array[_i].myEQUIP_TYPE)
		var _value: String
		#-------------------------------------------------------------------------------
		if(_equip_serializable_array[_i].equip_resource != null): 
			_value = Get_Tr_Equip_Item_Name(_equip_serializable_array[_i].equip_resource)
		#-------------------------------------------------------------------------------
		else:
			_value = "-"
		#-------------------------------------------------------------------------------
		statistics_menu_information_equip_type.text += "* "+_name+":"+"\n"
		statistics_menu_information_equip_value.text += _value+"\n"
	#-------------------------------------------------------------------------------
	Remove_Last_Letter(statistics_menu_information_equip_type)
	Remove_Last_Letter(statistics_menu_information_equip_value)
	#-------------------------------------------------------------------------------
	Show_Line_if_String_is_Empty(statistics_menu_information_equip_type)
	Show_Line_if_String_is_Empty(statistics_menu_information_equip_value)
#-------------------------------------------------------------------------------
func Set_Fighter_Skill_List(_fighter_serializable:Fighter_Serializable):
	Set_Skill(_fighter_serializable)
	var _skill_serializable_array: Array[Action_Serializable] = Get_Skill(_fighter_serializable)
	#-------------------------------------------------------------------------------
	statistics_menu_information_skill_name.text = ""
	#-------------------------------------------------------------------------------
	for _i in _skill_serializable_array.size():
		statistics_menu_information_skill_name.text += "* "+Get_Tr_Skill_Name(_skill_serializable_array[_i].action_resource)+"\n"
	#-------------------------------------------------------------------------------
	Remove_Last_Letter(statistics_menu_information_skill_name)
	Show_Line_if_String_is_Empty(statistics_menu_information_skill_name)
#-------------------------------------------------------------------------------
func Set_Fighter_Status_Resistance(_fighter_serializable:Fighter_Serializable):
	var _dictionary: Dictionary[StringName, int] = Get_Fighter_Status_Resistance_Dictionary(_fighter_serializable)
	#-------------------------------------------------------------------------------
	if(_dictionary.size() > 0):
		statistics_menu_information_status_name.text = ""
		statistics_menu_information_status_value.text = ""
		#-------------------------------------------------------------------------------
		for _i in _dictionary.size():
			statistics_menu_information_status_name.text = "* "+Get_Tr_Status_Effect_Name_0(_dictionary.keys()[_i])+"\n"
			statistics_menu_information_status_value.text = str(_dictionary.values()[_i])+"%"+"\n"
		#-------------------------------------------------------------------------------
		Remove_Last_Letter(statistics_menu_information_status_name)
		Remove_Last_Letter(statistics_menu_information_status_value)
	#-------------------------------------------------------------------------------
	else:
		statistics_menu_information_status_name.text = "-"
		statistics_menu_information_status_value.text = "-"
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Fighter_All_Elemental_Rate(_fighter_serializable:Fighter_Serializable):
	statistics_menu_information_elemental_type_name.text = ""
	statistics_menu_information_elemental_power_value.text = ""
	statistics_menu_information_elemental_absorb_value.text = ""
	statistics_menu_information_elemental_affinity_value.text = ""
	statistics_menu_information_elemental_repulsion_value.text = ""
	#-------------------------------------------------------------------------------
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.NORMAL, Get_Fighter_Elemental_Stats_Normal(_fighter_serializable))
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.WATER, Get_Fighter_Elemental_Stats_Water(_fighter_serializable))
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.FIRE, Get_Fighter_Elemental_Stats_Fire(_fighter_serializable))
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.EARTH, Get_Fighter_Elemental_Stats_Earth(_fighter_serializable))
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.WATER, Get_Fighter_Elemental_Stats_Water(_fighter_serializable))
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.ICE, Get_Fighter_Elemental_Stats_Ice(_fighter_serializable))
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.THUNDER, Get_Fighter_Elemental_Stats_Thunder(_fighter_serializable))
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.LIGHT, Get_Fighter_Elemental_Stats_Light(_fighter_serializable))
	Set_Fighter_1_Elemental_Rate(Action_Resource.ELEMENT.DARK, Get_Fighter_Elemental_Stats_Dark(_fighter_serializable))
	#-------------------------------------------------------------------------------
	Remove_Last_Letter(statistics_menu_information_elemental_type_name)
	Remove_Last_Letter(statistics_menu_information_elemental_power_value)
	Remove_Last_Letter(statistics_menu_information_elemental_absorb_value)
	Remove_Last_Letter(statistics_menu_information_elemental_affinity_value)
	Remove_Last_Letter(statistics_menu_information_elemental_repulsion_value)
#-------------------------------------------------------------------------------
func Set_Fighter_1_Elemental_Rate(_element_type:Action_Resource.ELEMENT, _element:Vector4i):
	var _element_name: StringName = Get_Tr_Element(_element_type)
	#-------------------------------------------------------------------------------
	statistics_menu_information_elemental_type_name.text += String_With_Asterisco_and_2_Points(_element_name)+"\n"
	statistics_menu_information_elemental_power_value.text += str(_element.x)+"%"+"\n"
	statistics_menu_information_elemental_absorb_value.text += str(_element.y)+"%"+"\n"
	statistics_menu_information_elemental_affinity_value.text += str(_element.z)+"%"+"\n"
	statistics_menu_information_elemental_repulsion_value.text += str(_element.w)+"%"+"\n"
#-------------------------------------------------------------------------------
func Remove_Last_Letter(_label:Label):
	_label.text = _label.text.left(-1)
#-------------------------------------------------------------------------------
func Show_Line_if_String_is_Empty(_label:Label):
	#-------------------------------------------------------------------------------
	if(_label.text == ""):
		_label.text = "-"
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Fighter_Description(_character_resource:Character_Resource):
	statistics_menu_information_description_value.text = Get_Tr_Character_Description(_character_resource)
	statistics_menu_information_description_value.text += Blablabla() 
#-------------------------------------------------------------------------------
func Pause_Statistics_Menu_Main_Button_Cancel(_fighter_index:int):
	pause_menu.show()
	statistics_menu.hide()
	main_canvas_layer.nothing_cancel = func(): Pause_Menu_Statistics_Fighter_Button_Cancel()
	var _button: Button = ally_button_array[_fighter_index] as Button
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region INVENTORY FUNCTIONS
#-------------------------------------------------------------------------------
func Fill_the_ConsumableItems_Stored_from_Hold():
	#-------------------------------------------------------------------------------
	for _i in item_consumable_inventory.size():
		#-------------------------------------------------------------------------------
		if(item_consumable_inventory[_i].hold > item_consumable_inventory[_i].action_resource.max_hold):
			var _extra: int = item_consumable_inventory[_i].hold - item_consumable_inventory[_i].action_resource.max_hold
			item_consumable_inventory[_i].hold = item_consumable_inventory[_i].action_resource.max_hold
			item_consumable_inventory[_i].stored += _extra
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Fill_the_ConsumableItems_Hold_from_Stored_and_Remove_Cooldown():
	var _item_serializable_array: Array[Action_Serializable] = item_consumable_inventory
	#-------------------------------------------------------------------------------
	for _i in _item_serializable_array.size():
		#-------------------------------------------------------------------------------
		_item_serializable_array[_i].cooldown = 0
		#-------------------------------------------------------------------------------
		if(_item_serializable_array[_i].hold < _item_serializable_array[_i].action_resource.max_hold):
			var _lo_que_falta: int = _item_serializable_array[_i].action_resource.max_hold - _item_serializable_array[_i].hold 
			_item_serializable_array[_i].stored -= _lo_que_falta
			#-------------------------------------------------------------------------------
			if(_item_serializable_array[_i].stored < 0):
				_lo_que_falta += _item_serializable_array[_i].stored
				_item_serializable_array[_i].stored = 0
			#-------------------------------------------------------------------------------
			_item_serializable_array[_i].hold += _lo_que_falta
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Max_Experience(_fighter_serializable:Fighter_Serializable) -> int:
	var _experience: int = 100000 + 50000 * _fighter_serializable.level
	return _experience
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region GET BASE STATS
#-------------------------------------------------------------------------------
func Get_Max_HP(_fighter_serializable:Fighter_Serializable) -> int:
	var _max_hp: int = _fighter_serializable.fighter_resource.max_hp
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_max_hp += _fighter_serializable.equip_serializable_array[_i].equip_resource.max_hp
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_max_hp += _fighter_serializable.status_serializable_array[_i].status_resource.max_hp
	#-------------------------------------------------------------------------------
	return _max_hp
#-------------------------------------------------------------------------------
func Get_Physical_Attack(_fighter_serializable:Fighter_Serializable) -> int:
	var _physical_attack: int = _fighter_serializable.fighter_resource.physical_attack
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_physical_attack += _fighter_serializable.equip_serializable_array[_i].equip_resource.physical_attack
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_physical_attack += _fighter_serializable.status_serializable_array[_i].status_resource.physical_attack
	#-------------------------------------------------------------------------------
	return _physical_attack
#-------------------------------------------------------------------------------
func Get_Physical_Defense(_fighter_serializable:Fighter_Serializable) -> int:
	var _physical_defense: int = _fighter_serializable.fighter_resource.physical_defense
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_physical_defense += _fighter_serializable.equip_serializable_array[_i].equip_resource.physical_defense
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_physical_defense += _fighter_serializable.status_serializable_array[_i].status_resource.physical_defense
	#-------------------------------------------------------------------------------
	return _physical_defense
#-------------------------------------------------------------------------------
func Get_Magical_Attack(_fighter_serializable:Fighter_Serializable) -> int:
	var _magical_attack: int = _fighter_serializable.fighter_resource.magical_attack
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_magical_attack += _fighter_serializable.equip_serializable_array[_i].equip_resource.magical_attack
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_magical_attack += _fighter_serializable.status_serializable_array[_i].status_resource.magical_attack
	#-------------------------------------------------------------------------------
	return _magical_attack
#-------------------------------------------------------------------------------
func Get_Magical_Defense(_fighter_serializable:Fighter_Serializable) -> int:
	var _magical_defense: int = _fighter_serializable.fighter_resource.magical_defense
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_magical_defense += _fighter_serializable.equip_serializable_array[_i].equip_resource.magical_defense
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_magical_defense += _fighter_serializable.status_serializable_array[_i].status_resource.magical_defense
	#-------------------------------------------------------------------------------
	return _magical_defense
#-------------------------------------------------------------------------------
func Get_Luck(_fighter_serializable:Fighter_Serializable) -> int:
	var _luck: int = _fighter_serializable.fighter_resource.luck
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_luck += _fighter_serializable.equip_serializable_array[_i].equip_resource.luck
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_luck += _fighter_serializable.status_serializable_array[_i].status_resource.luck
	#-------------------------------------------------------------------------------
	return _luck
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region GET EXTRA STATS
#-------------------------------------------------------------------------------
func Get_Physical_Presition_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _physical_presition_rate: int = _fighter_serializable.fighter_resource.physical_presition_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_physical_presition_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.physical_presition_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_physical_presition_rate += _fighter_serializable.status_serializable_array[_i].status_resource.physical_presition_rate
	#-------------------------------------------------------------------------------
	return _physical_presition_rate
#-------------------------------------------------------------------------------
func Get_Physical_Evasion_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _physical_evasion_rate: int = _fighter_serializable.fighter_resource.physical_evasion_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_physical_evasion_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.physical_evasion_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_physical_evasion_rate += _fighter_serializable.status_serializable_array[_i].status_resource.physical_evasion_rate
	#-------------------------------------------------------------------------------
	return _physical_evasion_rate
#-------------------------------------------------------------------------------
func Get_Magical_Presition_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _magical_presition_rate: int = _fighter_serializable.fighter_resource.magical_presition_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_magical_presition_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.magical_presition_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_magical_presition_rate += _fighter_serializable.status_serializable_array[_i].status_resource.magical_presition_rate
	#-------------------------------------------------------------------------------
	return _magical_presition_rate
#-------------------------------------------------------------------------------
func Get_Magical_Evasion_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _magical_evasion_rate: int = _fighter_serializable.fighter_resource.magical_evasion_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_magical_evasion_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.magical_evasion_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_magical_evasion_rate += _fighter_serializable.status_serializable_array[_i].status_resource.magical_evasion_rate
	#-------------------------------------------------------------------------------
	return _magical_evasion_rate
#-------------------------------------------------------------------------------
func Get_Crítical_Presition_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _critical_presition_rate: int = _fighter_serializable.fighter_resource.critical_presition_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_critical_presition_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.critical_presition_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_critical_presition_rate += _fighter_serializable.status_serializable_array[_i].status_resource.critical_presition_rate
	#-------------------------------------------------------------------------------
	return _critical_presition_rate
#-------------------------------------------------------------------------------
func Get_Crítical_Evasion_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _critical_evasion_rate: int = _fighter_serializable.fighter_resource.critical_evasion_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_critical_evasion_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.critical_evasion_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_critical_evasion_rate += _fighter_serializable.status_serializable_array[_i].status_resource.critical_evasion_rate
	#-------------------------------------------------------------------------------
	return _critical_evasion_rate
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region GET SPECIAL STATS
#-------------------------------------------------------------------------------
func Get_Target_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _target_rate: int = _fighter_serializable.fighter_resource.target_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_target_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.target_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_target_rate += _fighter_serializable.status_serializable_array[_i].status_resource.target_rate
	#-------------------------------------------------------------------------------
	return _target_rate
#-------------------------------------------------------------------------------
func Get_Guard_Effect(_fighter_serializable:Fighter_Serializable) -> int:
	var _guard_effect: int = _fighter_serializable.fighter_resource.guard_effect
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_guard_effect += _fighter_serializable.equip_serializable_array[_i].equip_resource.guard_effect
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_guard_effect += _fighter_serializable.status_serializable_array[_i].status_resource.guard_effect
	#-------------------------------------------------------------------------------
	return _guard_effect
#-------------------------------------------------------------------------------
func Get_Recovery_Effect(_fighter_serializable:Fighter_Serializable) -> int:
	var _recovery_effect: int = _fighter_serializable.fighter_resource.recovery_effect
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_recovery_effect += _fighter_serializable.equip_serializable_array[_i].equip_resource.recovery_effect
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_recovery_effect += _fighter_serializable.status_serializable_array[_i].status_resource.recovery_effect
	#-------------------------------------------------------------------------------
	return _recovery_effect
#-------------------------------------------------------------------------------
func Get_Pharmacology(_fighter_serializable:Fighter_Serializable) -> int:
	var _pharmacology: int = _fighter_serializable.fighter_resource.pharmacology
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_pharmacology += _fighter_serializable.equip_serializable_array[_i].equip_resource.pharmacology
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_pharmacology += _fighter_serializable.status_serializable_array[_i].status_resource.pharmacology
	#-------------------------------------------------------------------------------
	return _pharmacology
#-------------------------------------------------------------------------------
func Get_TP_Cost_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _tp_cost_rate: int = _fighter_serializable.fighter_resource.tp_cost_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_tp_cost_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.tp_cost_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_tp_cost_rate += _fighter_serializable.status_serializable_array[_i].status_resource.tp_cost_rate
	#-------------------------------------------------------------------------------
	return _tp_cost_rate
#-------------------------------------------------------------------------------
func Get_TP_Charge_Rate(_fighter_serializable:Fighter_Serializable) -> int:
	var _tp_charge_rate: int = _fighter_serializable.fighter_resource.tp_charge_rate
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_tp_charge_rate += _fighter_serializable.equip_serializable_array[_i].equip_resource.tp_charge_rate
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_tp_charge_rate += _fighter_serializable.status_serializable_array[_i].status_resource.tp_charge_rate
	#-------------------------------------------------------------------------------
	return _tp_charge_rate
#-------------------------------------------------------------------------------
func Get_TP_Recovery(_fighter_serializable:Fighter_Serializable) -> int:
	var _tp_recovery: int = _fighter_serializable.fighter_resource.tp_recovery
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_tp_recovery += _fighter_serializable.equip_serializable_array[_i].equip_resource.tp_recovery
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_tp_recovery += _fighter_serializable.status_serializable_array[_i].status_resource.tp_recovery
	#-------------------------------------------------------------------------------
	return _tp_recovery
#-------------------------------------------------------------------------------
func Get_HP_Recovery(_fighter_serializable:Fighter_Serializable) -> int:
	var _hp_recovery: int = _fighter_serializable.fighter_resource.hp_recovery
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_hp_recovery += _fighter_serializable.equip_serializable_array[_i].equip_resource.hp_recovery
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_hp_recovery += _fighter_serializable.status_serializable_array[_i].status_resource.hp_recovery
	#-------------------------------------------------------------------------------
	return _hp_recovery
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region SET/GET SKILL RESIALIZABLE ARRAY
#-------------------------------------------------------------------------------
func Get_Skill(_fighter_serializable: Fighter_Serializable) -> Array[Action_Serializable]:
	var _skill_array: Array[Action_Serializable]
	#-------------------------------------------------------------------------------
	_skill_array.append_array(_fighter_serializable.skill_serializable_array)
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		var _equip_serializable: Equip_Serializable = _fighter_serializable.equip_serializable_array[_i]
		#-------------------------------------------------------------------------------
		if(_equip_serializable != null):
			_skill_array.append_array(_equip_serializable.skill_serializable_array)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		var _status_serializable: Status_Serializable = _fighter_serializable.status_serializable_array[_i]
		_skill_array.append_array(_status_serializable.skill_serializable_array)
	#-------------------------------------------------------------------------------
	Sort_Action_by_ID(_skill_array)
	#-------------------------------------------------------------------------------
	return _skill_array
#-------------------------------------------------------------------------------
func Sort_Action_by_ID(_action_array: Array[Action_Serializable]):
	#-------------------------------------------------------------------------------
	for _i in _action_array.size():
		#-------------------------------------------------------------------------------
		for _j in range(_i+1, _action_array.size()):
			var _a_name: String = singleton.get_resource_filename(_action_array[_i].action_resource)
			var _b_name: String = singleton.get_resource_filename(_action_array[_j].action_resource)
			#-------------------------------------------------------------------------------
			if(_a_name > _b_name):
				var _a: Action_Serializable = _action_array[_i]
				_action_array[_i] = _action_array[_j]
				_action_array[_j] = _a
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Sort_Equip_by_ID(_equip_array: Array[Equip_Serializable]):
	#-------------------------------------------------------------------------------
	for _i in _equip_array.size():
		#-------------------------------------------------------------------------------
		for _j in range(_i+1, _equip_array.size()):
			var _a_name: String = singleton.get_resource_filename(_equip_array[_i].equip_resource)
			var _b_name: String = singleton.get_resource_filename(_equip_array[_j].equip_resource)
			#-------------------------------------------------------------------------------
			if(_a_name > _b_name):
				var _a: Equip_Serializable = _equip_array[_i]
				_equip_array[_i] = _equip_array[_j]
				_equip_array[_j] = _a
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Sort_Key_by_ID(_key_array: Array[Key_Serializable]):
	#-------------------------------------------------------------------------------
	for _i in _key_array.size():
		#-------------------------------------------------------------------------------
		for _j in range(_i+1, _key_array.size()):
			var _a_name: String = singleton.get_resource_filename(_key_array[_i].key_resource)
			var _b_name: String = singleton.get_resource_filename(_key_array[_j].key_resource)
			#-------------------------------------------------------------------------------
			if(_a_name > _b_name):
				var _a: Key_Serializable = _key_array[_i]
				_key_array[_i] = _key_array[_j]
				_key_array[_j] = _a
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Sort_Status_by_ID(_status_serializable_array: Array[Status_Serializable]):
	#-------------------------------------------------------------------------------
	for _i in _status_serializable_array.size():
		#-------------------------------------------------------------------------------
		for _j in range(_i+1, _status_serializable_array.size()):
			var _a_name: String = singleton.get_resource_filename(_status_serializable_array[_i].status_resource)
			var _b_name: String = singleton.get_resource_filename(_status_serializable_array[_j].status_resource)
			#-------------------------------------------------------------------------------
			if(_a_name > _b_name):
				var _a: Status_Serializable = _status_serializable_array[_i]
				_status_serializable_array[_i] = _status_serializable_array[_j]
				_status_serializable_array[_j] = _a
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Skill(_fighter_serializable: Fighter_Serializable):
	#-------------------------------------------------------------------------------
	_fighter_serializable.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	var _attack_serializable: Action_Serializable = Create_Skill_Serializable(attack_resource)
	_fighter_serializable.skill_serializable_array.append(_attack_serializable)
	#-------------------------------------------------------------------------------
	var _guard_serializable: Action_Serializable = Create_Skill_Serializable(guard_resource)
	_fighter_serializable.skill_serializable_array.append(_guard_serializable)
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.fighter_resource.skill_resource_array.size():
		var _skill_serializable: Action_Serializable = Create_Skill_Serializable(_fighter_serializable.fighter_resource.skill_resource_array[_i])
		_fighter_serializable.skill_serializable_array.append(_skill_serializable)
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		var _equip_serializable: Equip_Serializable = _fighter_serializable.equip_serializable_array[_i]
		_equip_serializable.skill_serializable_array.clear()
		#-------------------------------------------------------------------------------
		if(_equip_serializable.equip_resource != null):
			#-------------------------------------------------------------------------------
			for _j in _equip_serializable.equip_resource.skill_resource_array.size():
				var _skill_serializable: Action_Serializable = Create_Skill_Serializable(_equip_serializable.equip_resource.skill_resource_array[_j])
				_equip_serializable.skill_serializable_array.append(_skill_serializable)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		var _status_serializable: Status_Serializable = _fighter_serializable.status_serializable_array[_i]
		_status_serializable.skill_serializable_array.clear()
		#-------------------------------------------------------------------------------
		for _j in _status_serializable.status_resource.skill_resource_array.size():
			var _skill_serializable: Action_Serializable = Create_Skill_Serializable(_status_serializable.status_resource.skill_resource[_j])
			_status_serializable.skill_serializable_array.append(_skill_serializable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region GET STATUS RESISTANCES
#-------------------------------------------------------------------------------
func Get_Fighter_Status_Resistance_Dictionary(_fighter_serializable:Fighter_Serializable) -> Dictionary[StringName, int]:
	var _dictionary: Dictionary[StringName, int] = {}
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.fighter_resource.status_resistance_dictionary.size():
		var _key: StringName = _fighter_serializable.fighter_resource.status_resistance_dictionary.keys()[_i]
		var _value: int = _fighter_serializable.fighter_resource.status_resistance_dictionary.values()[_i]
		_dictionary.set(_key, _dictionary.get(_key, 0) + _value)
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			#-------------------------------------------------------------------------------
			for _j in _fighter_serializable.equip_serializable_array[_i].equip_resource.status_resistance_dictionary.size():
				var _key: StringName = _fighter_serializable.equip_serializable_array[_i].equip_resource.status_resistance_dictionary.keys()[_j]
				var _value: int = _fighter_serializable.equip_serializable_array[_i].equip_resource.status_resistance_dictionary.values()[_j]
				_dictionary.set(_key, _dictionary.get(_key, 0) + _value)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		#-------------------------------------------------------------------------------
		for _j in _fighter_serializable.status_serializable_array[_i].status_resource.status_resistance_dictionary.size():
			var _key: StringName = _fighter_serializable.status_serializable_array[_i].status_resource.status_resistance_dictionary.keys()[_j]
			var _value: int = _fighter_serializable.status_serializable_array[_i].status_resource.status_resistance_dictionary.values()[_j]
			_dictionary.set(_key, _dictionary.get(_key, 0) + _value)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _dictionary
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region GET ELEMENTAL RATE
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Normal(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _normal: Vector4i = _fighter_serializable.fighter_resource.normal
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_normal += _fighter_serializable.equip_serializable_array[_i].equip_resource.normal
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_normal += _fighter_serializable.status_serializable_array[_i].status_resource.normal
	#-------------------------------------------------------------------------------
	return _normal
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Water(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _water: Vector4i = _fighter_serializable.fighter_resource.water
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_water += _fighter_serializable.equip_serializable_array[_i].equip_resource.water
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_water += _fighter_serializable.status_serializable_array[_i].status_resource.water
	#-------------------------------------------------------------------------------
	return _water
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Fire(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _fire: Vector4i = _fighter_serializable.fighter_resource.fire
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_fire += _fighter_serializable.equip_serializable_array[_i].equip_resource.fire
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_fire += _fighter_serializable.status_serializable_array[_i].status_resource.fire
	#-------------------------------------------------------------------------------
	return _fire
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Earth(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _earth: Vector4i = _fighter_serializable.fighter_resource.earth
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_earth += _fighter_serializable.equip_serializable_array[_i].equip_resource.earth
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_earth += _fighter_serializable.status_serializable_array[_i].status_resource.earth
	#-------------------------------------------------------------------------------
	return _earth
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Wind(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _wind: Vector4i = _fighter_serializable.fighter_resource.wind
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_wind += _fighter_serializable.equip_serializable_array[_i].equip_resource.wind
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_wind += _fighter_serializable.status_serializable_array[_i].status_resource.wind
	#-------------------------------------------------------------------------------
	return _wind
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Ice(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _ice: Vector4i = _fighter_serializable.fighter_resource.ice
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_ice += _fighter_serializable.equip_serializable_array[_i].equip_resource.ice
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_ice += _fighter_serializable.status_serializable_array[_i].status_resource.ice
	#-------------------------------------------------------------------------------
	return _ice
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Thunder(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _thunder: Vector4i = _fighter_serializable.fighter_resource.thunder
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_thunder += _fighter_serializable.equip_serializable_array[_i].equip_resource.thunder
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_thunder += _fighter_serializable.status_serializable_array[_i].status_resource.thunder
	#-------------------------------------------------------------------------------
	return _thunder
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Light(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _light: Vector4i = _fighter_serializable.fighter_resource.light
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_light += _fighter_serializable.equip_serializable_array[_i].equip_resource.light
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_light += _fighter_serializable.status_serializable_array[_i].status_resource.light
	#-------------------------------------------------------------------------------
	return _light
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats_Dark(_fighter_serializable:Fighter_Serializable) -> Vector4i:
	var _dark: Vector4i = _fighter_serializable.fighter_resource.dark
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_serializable.equip_serializable_array[_i].equip_resource != null):
			_dark += _fighter_serializable.equip_serializable_array[_i].equip_resource.dark
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		_dark += _fighter_serializable.status_serializable_array[_i].status_resource.dark
	#-------------------------------------------------------------------------------
	return _dark
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region OPTION MENU FUNCTIONS
#-------------------------------------------------------------------------------
func PauseMenu_OptionButton_Submit():
	singleton.option_menu.show()
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit: Callable = func():OptionMenu_BackButton_Subited()
	main_canvas_layer.nothing_cancel = func():OptionMenu_BackButton_Canceled()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(singleton.option_menu.back, _selected, _submit)
	pause_menu.hide()
	tp_bar.hide()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(singleton.option_menu.back)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Subited() -> void:
	OptionMenu_BackButton_Common()
	singleton.Move_to_Button_by_Submit(pause_menu_button_options)
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Canceled() -> void:
	OptionMenu_BackButton_Common()
	singleton.Move_to_Button_by_Cancel(pause_menu_button_options)
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Common() -> void:
	singleton.option_menu.Save_OptionSaveData_Json()
	singleton.option_menu.hide()
	Set_Idiome()
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Close()
	tp_bar.show()
	pause_menu.show()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region LOCALIZATION FUNCTIONS
#-------------------------------------------------------------------------------
func Set_Idiome():
	pause_menu_button_title.text = String_With_2_Spaces(tr("pause_menu_button_title"))
	#-------------------------------------------------------------------------------
	var _information: String = tr("information_text")
	#-------------------------------------------------------------------------------
	var _habilities: String = tr("pause_menu_button_skill")
	pause_menu_button_skill.text = String_With_2_Spaces(_habilities)
	skill_menu_button_0.text = String_With_2_Spaces(_habilities)
	skill_menu_button_title.text = _habilities+":"
	#-------------------------------------------------------------------------------
	pause_menu_button_item.text = String_With_2_Spaces(tr("pause_menu_button_item"))
	#-------------------------------------------------------------------------------
	var _all_items: String = tr("item_menu_all_item_button")
	item_menu_all_button_0.text = String_With_2_Spaces(_all_items)
	item_menu_all_button_title.text = _all_items+":"
	#-------------------------------------------------------------------------------
	var _consumable_items: String = tr("item_menu_consumable_item_button")
	item_menu_consumable_button_0.text = String_With_2_Spaces(_consumable_items)
	item_menu_consumable_button_title.text = _consumable_items+":"
	#-------------------------------------------------------------------------------
	var _equip_items: String = tr("item_menu_equip_item_button")
	item_menu_equip_button_0.text = String_With_2_Spaces(_equip_items)
	item_menu_equip_button_title.text = _equip_items+":"
	#-------------------------------------------------------------------------------
	var _key_items: String = tr("item_menu_key_item_button")
	item_menu_key_button_0.text = String_With_2_Spaces(_key_items)
	item_menu_key_button_title.text = _key_items+":"
	#-------------------------------------------------------------------------------
	var _equipment: String = tr("pause_menu_button_equip")
	pause_menu_button_equip.text = String_With_2_Spaces(_equipment)
	equip_menu_button_0.text = String_With_2_Spaces(_equipment)
	equip_menu_button_title.text = _equipment+":"
	#-------------------------------------------------------------------------------
	var _status: String = tr("pause_menu_button_status")
	pause_menu_button_status.text = String_With_2_Spaces(_status)
	status_menu_button_0.text = String_With_2_Spaces(_status)
	status_menu_button_title.text = _status+":"
	#-------------------------------------------------------------------------------
	var _statistics: String = tr("pause_menu_button_statistics")
	pause_menu_button_statistics.text = String_With_2_Spaces(_statistics)
	statistics_menu_button_0.text = String_With_2_Spaces(_statistics)
	#-------------------------------------------------------------------------------
	pause_menu_button_options.text = String_With_2_Spaces(tr("options_button"))
	pause_menu_button_quit.text = String_With_2_Spaces(tr("pause_menu_button_quit"))
	#-------------------------------------------------------------------------------
	pause_menu_fighter_button_title.text = String_With_2_Spaces(tr("pause_menu_fighter_button_title"))
	#-------------------------------------------------------------------------------
	tp_bar_name.text = Get_Tr_Tp()
	#-------------------------------------------------------------------------------
	skill_menu_information_title.text = _information+":"
	item_manu_information_title.text = _information+":"
	equip_menu_information_title.text = _information+":"
	status_menu_information_title.text = _information+":"
	#-------------------------------------------------------------------------------
	var _uses: String = String_With_Asterisco_and_2_Points(tr("uses_text"))
	skill_menu_information_hold_title.text = _uses
	#-------------------------------------------------------------------------------
	var _level: String = String_With_Asterisco_and_2_Points(tr("level_text"))
	item_menu_equip_information_level_title.text = _level
	equip_menu_information_level_title.text = _level
	#-------------------------------------------------------------------------------
	var _class: String = String_With_Asterisco_and_2_Points(tr("fighter_type_text"))
	item_menu_equip_information_class_title.text = _class
	equip_menu_information_class_type.text = _class
	#-------------------------------------------------------------------------------
	var _equip_type: String = String_With_Asterisco_and_2_Points(tr("equip_type_text"))
	item_menu_equip_information_type_title.text = _equip_type
	equip_menu_information_type_title.text = _equip_type
	#-------------------------------------------------------------------------------
	var _hold: String = String_With_Asterisco_and_2_Points(tr("bag_text"))
	item_menu_consumable_information_hold_title.text = _hold
	#-------------------------------------------------------------------------------
	var _stored: String = String_With_Asterisco_and_2_Points(tr("stored_text"))
	item_menu_consumable_information_stored_title.text = _stored
	item_menu_equip_information_stored_title.text = _stored
	item_menu_key_information_stored_title.text = _stored
	equip_menu_information_stored_title.text = _stored
	#-------------------------------------------------------------------------------
	var _tp_cost: String = String_With_Asterisco_and_2_Points(tr("cost_text"))
	skill_menu_information_tp_cost_title.text = _tp_cost
	item_menu_consumable_information_tp_cost_title.text = _tp_cost
	#-------------------------------------------------------------------------------
	var _cooldown: String = String_With_Asterisco_and_2_Points(tr("cooldown_text"))
	skill_menu_information_cooldown_title.text = _cooldown
	item_menu_consumable_information_cooldown_title.text = _cooldown
	#-------------------------------------------------------------------------------
	var _speed: String = String_With_Asterisco_and_2_Points(tr("speed_text"))
	skill_menu_information_speed_title.text = _speed
	item_menu_consumable_information_speed_title.text = _speed
	#-------------------------------------------------------------------------------
	var _presition: String = String_With_Asterisco_and_2_Points(tr("presition_text"))
	skill_menu_information_presition_title.text = _presition
	item_menu_consumable_information_presition_title.text = _presition
	#-------------------------------------------------------------------------------
	var _effect: String = String_With_Asterisco_and_2_Points(tr("effect_text"))
	skill_menu_information_action_title.text = _effect
	item_menu_consumable_information_action_title.text = _effect
	#-------------------------------------------------------------------------------
	var _target: String = String_With_Asterisco_and_2_Points(tr("target_text"))
	skill_menu_information_target_title.text = _target
	item_menu_consumable_information_target_title.text = _target
	#-------------------------------------------------------------------------------
	var _status_effect_rate: String = tr("status_rate_text")+":"
	skill_menu_information_status_title.text = _status_effect_rate
	item_menu_consumable_information_status_title.text = _status_effect_rate
	#-------------------------------------------------------------------------------
	var _stats_rate: String = tr("stats_rate_text")+":"
	item_menu_equip_information_statistics_title.text = _stats_rate
	equip_menu_information_statistics_title.text = _stats_rate
	status_menu_information_statistics_title.text = _stats_rate
	#-------------------------------------------------------------------------------
	var _turns: String = String_With_Asterisco_and_2_Points(tr("turns_text"))
	status_menu_information_turns_title.text = _turns
	#-------------------------------------------------------------------------------
	var _description: String = tr("description_text")+":"
	skill_menu_information_description_title.text = _description
	item_menu_consumable_information_description_title.text = _description
	item_menu_equip_information_description_title.text = _description
	item_menu_key_information_description_title.text = _description
	equip_menu_information_description_title.text = _description
	status_menu_information_description_title.text = _description
	#-------------------------------------------------------------------------------
	statistics_menu_information_level_title.text = String_With_Asterisco_and_2_Points(tr("fighter_type_text"))+"\n"
	statistics_menu_information_level_title.text += String_With_Asterisco_and_2_Points(tr("level_text"))+"\n"
	statistics_menu_information_level_title.text += String_With_Asterisco_and_2_Points(tr("experience_text"))+"\n"
	statistics_menu_information_level_title.text += String_With_Asterisco_and_2_Points(tr("next_text"))
	#-------------------------------------------------------------------------------
	statistics_menu_information_base_stats_title.text = tr("base_stats")
	statistics_menu_information_extra_stats_title.text = tr("extra_stats")
	statistics_menu_information_special_stats_title.text = tr("special_stats")
	statistics_menu_information_equip_title.text = tr(_equipment)
	statistics_menu_information_skill_title.text = tr(_habilities)
	statistics_menu_information_status_title.text = tr("status_effect_resistances")
	statistics_menu_information_description_title.text = _description
	statistics_menu_information_elemental_title.text = tr("elemental_rate")
	statistics_menu_information_elemental_power_title.text = tr("power_text")
	statistics_menu_information_elemental_absorb_title.text = tr("absortion_text")
	statistics_menu_information_elemental_affinity_title.text = tr("affinity_text")
	statistics_menu_information_elemental_repulsion_title.text = tr("repulsion_text")
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		#-------------------------------------------------------------------------------
		if(ally_button_array[_i] != null):
			Fighter_Button_Set_Information_and_Idiome(ally_button_array[_i], ally_party[_i].character_node.character_resource, ally_party[_i].fighter_serializable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Fighter_Button_Set_Information_and_Idiome(_fighter_button:Fighter_Button, _character_resource:Character_Resource, _fighter_serializable:Fighter_Serializable):
	_fighter_button.name_label.text = Get_Tr_Character_Name(_character_resource)
	_fighter_button.title_label.text = Get_Tr_Character_Title(_character_resource)
	_fighter_button.class_label.text = "["+Get_Tr_Fighter_Class_Type(_fighter_serializable.fighter_resource.myFIGHTER_CLASS)+"]"
	_fighter_button.level_label.text = "[Level: "+str(_fighter_serializable.level)+"]"
	#-------------------------------------------------------------------------------
	_fighter_button.status_label.text = String_With_Asterisco_and_2_Points(tr("pause_menu_button_status"))+" "+str(_fighter_serializable.status_serializable_array.size())
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TEXT FUNCTIONS
#-------------------------------------------------------------------------------
func Blablabla() -> String:
	var _s:String = ""
	_s += "\n"
	_s += "\n"
	_s += "Bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla."
	return _s
#-------------------------------------------------------------------------------
func String_With_2_Spaces(_s:String) -> String:
	return "  "+_s+"  "
#-------------------------------------------------------------------------------
func String_With_Asterisco_and_2_Points(_s:String) -> String:
	return " * "+_s+":"
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ANIMATION FUNCTIONS
#-------------------------------------------------------------------------------
func Animation_StateMachine_Set(_animation_tree:AnimationTree, _state_machine:String, _anim:String):
	var _playback: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/"+_state_machine+"_StateMachine/playback")
	_playback.call_deferred("travel", _anim)
#-------------------------------------------------------------------------------
func Animation_StateMachine_Get(_animation_tree:AnimationTree, _state_machine:String) -> StringName:
	var _playback: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/"+_state_machine+"_StateMachine/playback")
	return _playback.get_current_node()
#-------------------------------------------------------------------------------
func Animation_StateMachine_Reply(_animation_tree:AnimationTree, _state_machine:String):
	var _playback: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/"+_state_machine+"_StateMachine/playback")
	_playback.call_deferred("travel", _playback.get_current_node())
#-------------------------------------------------------------------------------
func Face_Left(_user:Character_Node, _b:bool):
	#-------------------------------------------------------------------------------
	if(_b):
		_user.pivot.scale.x = -1
	#-------------------------------------------------------------------------------
	else:
		_user.pivot.scale.x = 1
	#-------------------------------------------------------------------------------
	_user.is_facing_left = _b
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region DEBUG FUNCTIONS
#-------------------------------------------------------------------------------
func Debug_Information() -> void:
	var _s: String = ""
	_s += "* Joystick: " + str(input_dir)+"\n"
	_s += "* Joystick Normal: " + str(input_dir_normal)+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "* Grab Focus: " + str(get_viewport().gui_get_focus_owner())+"\n"
	_s += "* All Tweens: "+str(tween_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "* myGAME_STATE: " + GAME_STATE.keys()[myGAME_STATE]+"\n"
	_s += "* myBATTLE_STATE: " + BATTLE_STATE.keys()[myBATTLE_STATE]+"\n"
	_s += "* myLOSE_STATE: " + LOSE_STATE.keys()[myLOSE_STATE]+"\n"
	_s += "* is_in_dialogue: " + str(is_in_dialogue)+"\n"
	_s += "* Current Fighter Turn: " + str(current_fighter_turn)+"\n"
	_s += "-------------------------------------------------------\n"
	_s += Get_Alive_Fighter_and_Actions_Text("Ally", ally_party)
	_s += "-------------------------------------------------------\n"
	_s += Get_Alive_Fighter_and_Actions_Text("Enemy", enemy_party)
	_s += "-------------------------------------------------------\n"
	if(ally_party[0].fighter_serializable_in_battle != null):
		_s += "evasion_rate: "+str(Get_Physical_Presition_Rate(ally_party[0].fighter_serializable_in_battle))+"\n"
	_s += "-------------------------------------------------------\n"
	#_s += "Enemy Bullets Enabled: " + str(enemyBullets_Enabled_Array.size())+"\n"
	#_s += "Enemy Bullets Disabled: " + str(enemyBullets_Disabled_Array.size())+"\n"
	#_s += "-------------------------------------------------------\n"
	debug_label.text = _s
#-------------------------------------------------------------------------------
func Get_Alive_Fighter_and_Actions_Text(_name:String, _fighter_node_array:Array[Fighter_Node]) ->String:
	var _s:String = ""
	#-------------------------------------------------------------------------------
	for _i in _fighter_node_array.size():
		var _fighter_node: Fighter_Node = _fighter_node_array[_i]
		var _fighter_serializable: Fighter_Serializable = _fighter_node.fighter_serializable_in_battle
		#-------------------------------------------------------------------------------
		if(_fighter_serializable != null):
			_s += "----> * "+_name+" "+str(_i)
			if(_fighter_serializable.hp >0):
				_s += " (Alive): "
			#-------------------------------------------------------------------------------
			else:
				_s += " (Dead): "
			#-------------------------------------------------------------------------------
			if(_fighter_node.action_serializable == null):
				_s += "null"+"\n"
			#-------------------------------------------------------------------------------
			else:
				_s += singleton.get_resource_filename(_fighter_node.action_serializable.action_resource)+"\n"
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _s
#-------------------------------------------------------------------------------
func Set_SlowMotion() -> void:
	#-------------------------------------------------------------------------------
	if(Input.is_action_just_pressed("Debug_SlowMotion")):
		if(isSlowMotion):
			NormalMotion()
		#-------------------------------------------------------------------------------
		else:
			SlowMotion()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func SlowMotion():
	Engine.time_scale = 0.3
	deltaTimeScale = 0.3
	isSlowMotion = true
#-------------------------------------------------------------------------------
func NormalMotion():
	Engine.time_scale = 1.0
	deltaTimeScale = 1.0
	isSlowMotion = false
#-------------------------------------------------------------------------------
func Set_DebugInfo() -> void:
	#-------------------------------------------------------------------------------
	if(Input.is_action_just_pressed("Debug_Info")):
		debug_label.visible = !debug_label.visible
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region DIALOGUE FUNCTIONS
#-------------------------------------------------------------------------------
func Next_Button_Set():
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.Scroll_Richtext_Up(dialogue_menu_value)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.Scroll_Richtext_Down(dialogue_menu_value)
	#-------------------------------------------------------------------------------
	var _submit:Callable = func():
		next_signal.emit()
	#-------------------------------------------------------------------------------
	singleton.Set_Dialogue_Button(button_next, _submit, _w, _s)
	singleton.Move_to_Button(button_next)
	await next_signal
#-------------------------------------------------------------------------------
func Skip_Dialogue_Button_Set():
	#-------------------------------------------------------------------------------
	var _w: Callable = func(): pass
	#-------------------------------------------------------------------------------
	var _s: Callable = func(): pass
	#-------------------------------------------------------------------------------
	var _submit:Callable = func():
		is_dialogue_skipped = true
	#-------------------------------------------------------------------------------
	singleton.Set_Dialogue_Button(button_next, _submit, _w, _s)
	singleton.Move_to_Button(button_next)
#-------------------------------------------------------------------------------
func Dialogue(_value:String):
	await Dialogue_0(_value)
	await Next_Button_Set()
#-------------------------------------------------------------------------------
func Dialogue_0(_value:String):
	player_interactable_by_action_collider.disabled = true
	dialogue_menu_face.hide()
	dialogue_menu_audio.stream = ally_party[0].character_node.character_resource.voice
	dialogue_menu_name.text = ""
	dialogue_menu_name.hide()
	dialogue_menu_value.visible_characters = 0
	dialogue_index = 0
	is_dialogue_skipped = false
	#-------------------------------------------------------------------------------
	Skip_Dialogue_Button_Set()
	await Dialogue_Effect_Puntiation(_value)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Dialogue_with_Face(_character_resource:Character_Resource, _value:String):
	await Dialogue_with_Face_0(_character_resource, _value)
	await Next_Button_Set()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Dialogue_with_Face_0(_character_resource:Character_Resource, _value:String):
	player_interactable_by_action_collider.disabled = true
	dialogue_menu_face.show()
	dialogue_menu_face.texture = _character_resource.face
	dialogue_menu_audio.stream = _character_resource.voice
	dialogue_menu_name.show()
	#dialogue_menu_name.text = "[lb]"+Get_Tr_Character_Name(_character_resource)+"[rb]:"
	dialogue_menu_name.text = "[u]"+Get_Tr_Character_Name(_character_resource)+":"+"[/u]"
	dialogue_menu_value.visible_characters = 0
	dialogue_index = 0
	is_dialogue_skipped = false
	#-------------------------------------------------------------------------------
	Skip_Dialogue_Button_Set()
	await Dialogue_Effect_Puntiation(_value)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Dialogue_with_Face(_character_resource:Character_Resource):
	dialogue_menu_face.show()
	dialogue_menu_face.texture = _character_resource.face
	dialogue_menu_audio.stream = _character_resource.voice
	dialogue_menu_name.show()
	#dialogue_menu_name.text = "[lb]"+_name+"[rb]:"
	dialogue_menu_name.text = "[u]"+singleton.get_resource_filename(_character_resource)+":"+"[/u]"
	dialogue_menu_value.text = ""
	dialogue_menu_value.visible_characters = 0
	dialogue_index = 0
	is_dialogue_skipped = false
	#-------------------------------------------------------------------------------
	Skip_Dialogue_Button_Set()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Dialogue_Effect(_text:String):
	await Dialogue_Effect_Timer(_text, 1)
#-------------------------------------------------------------------------------
func Dialogue_Effect_Timer(_text:String, _timer:int):
	dialogue_menu_value.text += _text
	var _length: int = dialogue_menu_value.text.length()
	#-------------------------------------------------------------------------------
	for _i in _length-1:
		#-------------------------------------------------------------------------------
		if(is_dialogue_skipped):
			dialogue_index = _length
			dialogue_menu_value.visible_characters = _length
			return
		#-------------------------------------------------------------------------------
		var _letter: String = dialogue_menu_value.text[dialogue_index]
		#-------------------------------------------------------------------------------
		dialogue_index += 1
		dialogue_menu_value.visible_characters = dialogue_index
		#-------------------------------------------------------------------------------
		if(_letter != " "):
			dialogue_menu_audio.pitch_scale = randf_range(0.95, 1.05)
			dialogue_menu_audio.play()
			await Dialogue_Pause(_timer)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	dialogue_index = _length
	dialogue_menu_value.visible_characters = _length
	await Dialogue_Pause(1)
#-------------------------------------------------------------------------------
func Dialogue_Effect_Puntiation(_text:String):
	dialogue_menu_value.text = _text
	var _length: int = dialogue_menu_value.text.length()
	#-------------------------------------------------------------------------------
	for _i in _length-1:
		#-------------------------------------------------------------------------------
		if(is_dialogue_skipped):
			dialogue_index = _length
			dialogue_menu_value.visible_characters = _length
			return
		#-------------------------------------------------------------------------------
		var _letter: String = dialogue_menu_value.text[dialogue_index]
		#-------------------------------------------------------------------------------
		dialogue_index += 1
		dialogue_menu_value.visible_characters = dialogue_index
		#-------------------------------------------------------------------------------
		if(_letter != " "):
			dialogue_menu_audio.pitch_scale = randf_range(0.95, 1.05)
			dialogue_menu_audio.play()
			#-------------------------------------------------------------------------------
			if(_letter == "." or _letter == "?" or _letter == "!"):
				await Dialogue_Pause(14)
			#-------------------------------------------------------------------------------
			elif(_letter == "," or _letter == ";"):
				await Dialogue_Pause(7)
			#-------------------------------------------------------------------------------
			else:
				await Dialogue_Pause(1)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	dialogue_index = _length
	dialogue_menu_value.visible_characters = _length
	await Dialogue_Pause(1)
#-------------------------------------------------------------------------------
func Dialogue_Pause(_timer:int):
	#-------------------------------------------------------------------------------
	for _i in _timer:
		#-------------------------------------------------------------------------------
		if(is_dialogue_skipped):
			return
		#-------------------------------------------------------------------------------
		await Seconds(0.03)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Dialogue_Open():
	button_next.show()
	singleton.Move_to_Button(button_next)
	is_in_dialogue = true
	dialogue_menu.show()
#-------------------------------------------------------------------------------
func Dialogue_Close():
	Dialogue_Close_0()
	player_interactable_by_action_collider.disabled = false
	is_in_dialogue = false
#-------------------------------------------------------------------------------
func Dialogue_Close_0():
	button_next.hide()
	dialogue_menu.hide()
#-------------------------------------------------------------------------------
func Disable_Pause_Input():
	main_canvas_layer.nothing_cancel = func(): pass
#-------------------------------------------------------------------------------
func Enable_Pause_Input():
	main_canvas_layer.nothing_cancel = func(): PauseMenu_Open()
#-------------------------------------------------------------------------------
func Stop_Moving():
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		Animation_StateMachine_Set(ally_party[_i].character_node.animation_tree, state_machine_layer_1, "Idle")
		ally_party[_i].character_node.is_moving = false
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Open_Dialogue_Options(_array_string:Array[String]):
	button_next.hide()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func():pass
	#-------------------------------------------------------------------------------
	if(_array_string.size() > 0):
		singleton.Destroy_Button_Array(dialogue_menu_button_array)
		#-------------------------------------------------------------------------------
		for _i in _array_string.size():
			var _button: Button = Button.new()
			_button.text = "  "+_array_string[_i]+"  "
			_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			#-------------------------------------------------------------------------------
			var _selected: Callable = func():singleton.Common_Selected()
			#-------------------------------------------------------------------------------
			var _submit: Callable = func():
				singleton.Common_Submited()
				dialogue_option_index = _i
				next_signal.emit()
			#-------------------------------------------------------------------------------
			singleton.Set_Button(_button, _selected, _submit)
			dialogue_menu_button_content.add_child(_button)
			dialogue_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		singleton.Move_to_Button(dialogue_menu_button_array[0])
		singleton.Button_Array_Set_Vertical_Navigation(dialogue_menu_button_array)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Close_Dialogue_Options():
	button_next.show()
	singleton.Destroy_Button_Array(dialogue_menu_button_array)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MONEY FUNCTIONS
#-------------------------------------------------------------------------------
func SetMoney_Label():
	var _s: String = "  "+Get_Money_Label(money_inventory.stored)+"  "
	pause_menu_money_label.text = _s
	money_menu_label.text = _s
#-------------------------------------------------------------------------------
func Get_Money_Label(_value:int) -> String:
	return "$"+str(_value)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MARKET MENU
#-------------------------------------------------------------------------------
func Open_Market(_merchant_name:String, _consumableitem_array:Array[Action_Serializable], _equipitem_array:Array[Equip_Serializable], _keyitem_array:Array[Key_Serializable]):
	item_menu.show()
	Pause_On_0()
	tp_bar.show()
	pause_menu_panel.show()
	#-------------------------------------------------------------------------------
	money_menu.show()
	SetMoney_Label()
	#-------------------------------------------------------------------------------
	var _submit_0: Callable = func():pass
	main_canvas_layer.nothing_cancel = func():Close_Market()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(item_menu_all_button_0, button_all_selected_0, _submit_0)
	singleton.Set_Button(item_menu_consumable_button_0, button_consumable_selected_0, _submit_0)
	singleton.Set_Button(item_menu_equip_button_0, button_equip_selected_0, _submit_0)
	singleton.Set_Button(item_menu_key_button_0, button_key_selected_0, _submit_0)
	#-------------------------------------------------------------------------------
	if(_consumableitem_array.size()>0):
		#-------------------------------------------------------------------------------
		for _i in _consumableitem_array.size():
			var _hold: int = _consumableitem_array[_i].stored
			var _cooldown: int = _consumableitem_array[_i].cooldown
			#-------------------------------------------------------------------------------
			var _consumable_button: Button = Create_ConsumableItem_InMarket_Button(_consumableitem_array[_i])
			var _all_button: Button = Create_ConsumableItem_InMarket_Button(_consumableitem_array[_i])
			#-------------------------------------------------------------------------------
			var _consumable_selected_1: Callable = func():BuyMenu_Item_Consumable_Selected(_consumableitem_array[_i])
			var _consumable_submit_1: Callable = func():BuyMenu_ItemConsumable_Submit(_consumable_button, _merchant_name, _consumableitem_array[_i])
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_consumable_button, _consumable_selected_1, _consumable_submit_1, button_consumable_w, button_consumable_s, button_consumable_a, button_consumable_d)
			item_menu_consumable_button_content.add_child(_consumable_button)
			item_menu_consumable_button_array.append(_consumable_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():BuyMenu_All_Item_Consumable_Selected(_consumableitem_array[_i])
			var _all_submit_1: Callable = func():BuyMenu_ItemConsumable_Submit(_all_button, _merchant_name, _consumableitem_array[_i])
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_consumable_w, button_consumable_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_consumable_a, button_consumable_d)
		item_menu_consumable_button_content.add_child(_button)
		item_menu_consumable_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	if(_equipitem_array.size()>0):
		#-------------------------------------------------------------------------------
		for _i in _equipitem_array.size():
			var _equip_button: Button = Create_EquipItem_InMarket_Button(_equipitem_array[_i])
			var _all_button: Button = Create_EquipItem_InMarket_Button(_equipitem_array[_i])
			#-------------------------------------------------------------------------------
			var _equip_selected_1: Callable = func():BuyMenu_EquipItem_Selected(_equipitem_array[_i])
			var _equip_submit_1: Callable = func():BuyMenu_EquipItem_Submit(_equip_button, _merchant_name, _equipitem_array[_i], _equip_button, _all_button)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_equip_button, _equip_selected_1, _equip_submit_1, button_equip_w, button_equip_s, button_equip_a, button_equip_d)
			item_menu_equip_button_content.add_child(_equip_button)
			item_menu_equip_button_array.append(_equip_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():BuyMenu_All_EquipItem_Selected(_equipitem_array[_i])
			var _all_submit_1: Callable = func():BuyMenu_EquipItem_Submit(_all_button, _merchant_name, _equipitem_array[_i], _equip_button, _all_button)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_equip_w, button_equip_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_equip_a, button_equip_d)
		item_menu_equip_button_content.add_child(_button)
		item_menu_equip_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	if(_keyitem_array.size()>0):
		#-------------------------------------------------------------------------------
		for _i in _keyitem_array.size():
			var _key_button: Button = Create_KeyItem_InMarket_Button(_keyitem_array[_i])
			var _all_button: Button = Create_KeyItem_InMarket_Button(_keyitem_array[_i])
			#-------------------------------------------------------------------------------
			var _key_selected_1: Callable = func():BuyMenu_KeyItem_Selected(_keyitem_array[_i])
			var _key_submit_1: Callable = func():BuyMenu_KeyItem_Submit(_key_button, _merchant_name, _keyitem_array[_i], _key_button, _all_button)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_key_button, _key_selected_1, _key_submit_1, button_key_w, button_key_s, button_key_a, button_key_d)
			item_menu_key_button_content.add_child(_key_button)
			item_menu_key_button_array.append(_key_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():BuyMenu_All_KeyItem_Selected(_keyitem_array[_i])
			var _all_submit_1: Callable = func():BuyMenu_KeyItem_Submit(_all_button, _merchant_name, _keyitem_array[_i], _key_button, _all_button)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_key_w, button_key_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_key_a, button_key_d)
		item_menu_key_button_content.add_child(_button)
		item_menu_key_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	var _all_size:int = _consumableitem_array.size() + _equipitem_array.size() + _keyitem_array.size()
	#-------------------------------------------------------------------------------
	if(_all_size <= 0):
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_all_a, button_all_d)
		item_menu_all_button_content.add_child(_button)
		item_menu_all_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_all_button_array)
	#-------------------------------------------------------------------------------
	Show_All_Item_Button_0()
	Move_To_Item_Button_List(item_menu_all_button_root, item_menu_all_button_0, item_menu_all_button_array)
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	await next_signal
#-------------------------------------------------------------------------------
func Close_Market():
	item_menu.hide()
	tp_bar.hide()
	pause_menu_panel.hide()
	money_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Destroy_Button_Array(item_menu_all_button_array)
	singleton.Destroy_Button_Array(item_menu_consumable_button_array)
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	singleton.Destroy_Button_Array(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func(): pass
	next_signal.emit()
	#-------------------------------------------------------------------------------
	Pause_Off_0()
#-------------------------------------------------------------------------------
func BuyMenu_All_Item_Consumable_Selected(_item_serializable: Action_Serializable):
	BuyMenu_Item_Consumable_Selected(_item_serializable)
	Move_To_Item_Information_0(item_menu_consumable_information_root)
#-------------------------------------------------------------------------------
func BuyMenu_Item_Consumable_Selected(_item_serializable: Action_Serializable):
	#-------------------------------------------------------------------------------
	for _i in item_consumable_inventory.size():
		#-------------------------------------------------------------------------------
		if(item_consumable_inventory[_i].action_resource == _item_serializable.action_resource):
			Set_Item_Consumable_Information(item_consumable_inventory[_i])
			singleton.Common_Selected()
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _item_serializable_new: Action_Serializable = Create_Consumable_Serializable(_item_serializable.action_resource)
	Set_Item_Consumable_Information(_item_serializable_new)
	singleton.Common_Selected()
	return
#-------------------------------------------------------------------------------
func BuyMenu_ItemConsumable_Submit(_button:Button, _merchant_name: String, _item_serializable: Action_Serializable):
	var _price: int = _item_serializable.action_resource.price
	#-------------------------------------------------------------------------------
	if(_price >= money_inventory.stored):
		singleton.Common_Canceled()
		return
	#-------------------------------------------------------------------------------
	var _up: Callable = func():Increase_How_Many_Do_Want_to_Buy(_price, 10, false, 99)
	var _down: Callable = func():Decrease_How_Many_Do_Want_to_Buy(_price, 10, false, 99)
	var _left: Callable = func():Decrease_How_Many_Do_Want_to_Buy(_price, 1, false, 99)
	var _right: Callable = func():Increase_How_Many_Do_Want_to_Buy(_price, 1, false, 99)
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _final_price: int = _price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_final_price <= money_inventory.stored):
			_item_serializable.hold -= how_many_would_you_buy
			money_inventory.stored -= _final_price
			#-------------------------------------------------------------------------------
			var _id: String = Get_MerchantId_and_ItemId_and_Hold(_merchant_name, _item_serializable.action_resource)
			key_dictionary[_id] = _item_serializable.stored
			#-------------------------------------------------------------------------------
			var _inventory_item_serializable: Action_Serializable = Add_ConsumableItem_to_Inventory(_item_serializable, how_many_would_you_buy)
			Set_Item_Consumable_Information(_inventory_item_serializable)
			#-------------------------------------------------------------------------------
			Set_Max_Items_You_Can_Buy(99, _price, _final_price)
			SetMoney_Label()
			Print_How_Many_Do_You_Buy(_price, false, 99)
			Print_How_Many_Do_You_Hold_and_Stored(_inventory_item_serializable)
			#-------------------------------------------------------------------------------
			singleton.Play_SFX_Shop()
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = Get_Tr_Consumable_Item_Name(_item_serializable.action_resource)
	confirm_buy_menu_item_icon.texture = _item_serializable.action_resource.icon
	how_many_would_you_buy = 1
	Print_How_Many_Do_You_Buy(_price, false, 99)
	var _item_in_inventory: Action_Serializable = Get_ConsumableItem_in_Inventory(_item_serializable.action_resource)
	Print_How_Many_Do_You_Hold_and_Stored(_item_in_inventory)
	Confirm_Buy_Menu_Submit(_submit, _button, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func BuyMenu_All_EquipItem_Selected(_equip_serializable: Equip_Serializable):
	BuyMenu_EquipItem_Selected(_equip_serializable)
	Move_To_Item_Information_0(item_menu_equip_information_root)
#-------------------------------------------------------------------------------
func BuyMenu_EquipItem_Selected(_equip_serializable: Equip_Serializable):
	#-------------------------------------------------------------------------------
	for _i in item_equip_inventory.size():
		#----------------------------------------------------------------
		if(item_equip_inventory[_i].equip_resource == _equip_serializable.equip_resource):
			Set_Item_Equip_Information(item_equip_inventory[_i])
			singleton.Common_Selected()
			return
		#----------------------------------------------------------------
	#----------------------------------------------------------------
	var _equip_serializable_new: Equip_Serializable = Create_Equip_Serializable(_equip_serializable.equip_resource, 0)
	Set_Item_Equip_Information(_equip_serializable_new)
	singleton.Common_Selected()
	return
#-------------------------------------------------------------------------------
func BuyMenu_EquipItem_Submit(_button:Button, _merchant_name: String, _equip_serializable: Equip_Serializable, _equipitem_button:Button, _allitem_button:Button):
	var _price: int = _equip_serializable.equip_resource.price
	#-------------------------------------------------------------------------------
	if(_price >= money_inventory.stored or _equip_serializable.stored <= 0):
		singleton.Common_Canceled()
		return
	#-------------------------------------------------------------------------------
	var _up: Callable = func():Increase_How_Many_Do_Want_to_Buy(_price, 10, true, _equip_serializable.stored)
	var _down: Callable = func():Decrease_How_Many_Do_Want_to_Buy(_price, 10, true, _equip_serializable.stored)
	var _left: Callable = func():Decrease_How_Many_Do_Want_to_Buy(_price, 1, true, _equip_serializable.stored)
	var _right: Callable = func():Increase_How_Many_Do_Want_to_Buy(_price, 1, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _final_price: int = _price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_final_price <= money_inventory.stored and how_many_would_you_buy <= _equip_serializable.stored):
			_equip_serializable.stored -= how_many_would_you_buy
			money_inventory.stored -= _final_price
			#-------------------------------------------------------------------------------
			var _id: String = Get_MerchantId_and_ItemId_and_Hold(_merchant_name, _equip_serializable.equip_resource)
			key_dictionary[_id] = _equip_serializable.stored
			#-------------------------------------------------------------------------------
			Change_EquipItem_Hold_Label(_equip_serializable, _equipitem_button)
			Change_EquipItem_Hold_Label(_equip_serializable, _allitem_button)
			#-------------------------------------------------------------------------------
			var _inventory_equip_serializable: Equip_Serializable = Add_EquipItem_to_Inventory(_equip_serializable, how_many_would_you_buy)
			Set_Item_Equip_Information(_inventory_equip_serializable)
			#-------------------------------------------------------------------------------
			Set_Max_Items_You_Can_Buy(_equip_serializable.stored, _price, _final_price)
			SetMoney_Label()
			Print_How_Many_Do_You_Buy(_price, true, _equip_serializable.stored)
			Print_How_Many_Do_You_Stored(_inventory_equip_serializable.stored)
			#-------------------------------------------------------------------------------
			singleton.Play_SFX_Shop()
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = Get_Tr_Equip_Item_Name(_equip_serializable.equip_resource)
	confirm_buy_menu_item_icon.texture = _equip_serializable.equip_resource.icon
	how_many_would_you_buy = 1
	Print_How_Many_Do_You_Buy(_price, true, _equip_serializable.stored)
	var _equip_in_inventory: Equip_Serializable = Get_EquipItem_in_Inventory(_equip_serializable.equip_resource)
	Print_How_Many_Do_You_Stored(_equip_in_inventory.stored)
	Confirm_Buy_Menu_Submit(_submit, _button, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func BuyMenu_All_KeyItem_Selected(_key_serializable: Key_Serializable):
	BuyMenu_KeyItem_Selected(_key_serializable)
	Move_To_Item_Information_0(item_menu_key_information_root)
#----------------------------------------------------------------
func BuyMenu_KeyItem_Selected(_key_serializable: Key_Serializable):
	#----------------------------------------------------------------
	for _i in item_key_inventory.size():
		#----------------------------------------------------------------
		if(item_key_inventory[_i].key_resource == _key_serializable.key_resource):
			Set_Item_Key_Information(item_key_inventory[_i])
			singleton.Common_Selected()
			return
		#----------------------------------------------------------------
	#----------------------------------------------------------------
	var _keyitem_serializable_new: Key_Serializable = Create_Key_Serializable(_key_serializable.key_resource, 0)
	Set_Item_Key_Information(_keyitem_serializable_new)
	singleton.Common_Selected()
	return
#-------------------------------------------------------------------------------
func BuyMenu_KeyItem_Submit(_button:Button, _merchant_name: String, _key_serializable: Key_Serializable, _keyitem_button:Button, _allitem_button:Button):
	var _price: int = _key_serializable.key_resource.price
	#-------------------------------------------------------------------------------
	if(_price >= money_inventory.stored or _key_serializable.stored <= 0):
		singleton.Common_Canceled()
		return
	#-------------------------------------------------------------------------------
	var _up: Callable = func():Increase_How_Many_Do_Want_to_Buy(_price, 10, true, _key_serializable.stored)
	var _down: Callable = func():Decrease_How_Many_Do_Want_to_Buy(_price, 10, true, _key_serializable.stored)
	var _left: Callable = func():Decrease_How_Many_Do_Want_to_Buy(_price, 1, true, _key_serializable.stored)
	var _right: Callable = func():Increase_How_Many_Do_Want_to_Buy(_price, 1, true, _key_serializable.stored)
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _final_price: int = _price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_final_price <= money_inventory.stored and how_many_would_you_buy <= _key_serializable.stored):
			_key_serializable.stored -= how_many_would_you_buy
			money_inventory.stored -= _final_price
			#-------------------------------------------------------------------------------
			var _id: String = Get_MerchantId_and_ItemId_and_Hold(_merchant_name, _key_serializable.key_resource)
			key_dictionary[_id] = _key_serializable.stored
			#-------------------------------------------------------------------------------
			Change_KeyItem_Hold_Label(_key_serializable, _keyitem_button)
			Change_KeyItem_Hold_Label(_key_serializable, _allitem_button)
			#-------------------------------------------------------------------------------
			var _inventory_keyitem_serializable: Key_Serializable = Add_KeyItem_to_Inventory(_key_serializable, how_many_would_you_buy)
			Set_Item_Key_Information(_inventory_keyitem_serializable)
			#-------------------------------------------------------------------------------
			Set_Max_Items_You_Can_Buy(_key_serializable.stored, _price, _final_price)
			SetMoney_Label()
			Print_How_Many_Do_You_Buy(_price, true, _key_serializable.stored)
			Print_How_Many_Do_You_Stored(_inventory_keyitem_serializable.stored)
			#-------------------------------------------------------------------------------
			singleton.Play_SFX_Shop()
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = Get_Tr_Key_Item_Name(_key_serializable.key_resource)
	confirm_buy_menu_item_icon.texture = _key_serializable.key_resource.icon
	how_many_would_you_buy = 1
	Print_How_Many_Do_You_Buy(_price, true, _key_serializable.stored)
	var _key_in_inventory: Key_Serializable = Get_KeyItem_in_Inventory(_key_serializable.key_resource)
	Print_How_Many_Do_You_Stored(_key_in_inventory.stored)
	Confirm_Buy_Menu_Submit(_submit, _button, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func Increase_How_Many_Do_Want_to_Buy(_price:int, _int:int, _has_limited_stored:bool, _stored:int):
	var _old_value: int = how_many_would_you_buy
	how_many_would_you_buy += _int
	#-------------------------------------------------------------------------------
	var _final_price: int = _price * how_many_would_you_buy
	#-------------------------------------------------------------------------------
	Set_Max_Items_You_Can_Buy(_stored, _price, _final_price)
	Print_How_Many_Do_You_Buy(_price, _has_limited_stored, _stored)
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy > _old_value):
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Decrease_How_Many_Do_Want_to_Buy(_price:int, _int:int, _has_limited_stored:bool, _stored:int):
	var _old_value: int = how_many_would_you_buy
	how_many_would_you_buy -= _int
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy < 1):
		how_many_would_you_buy = 1
	#-------------------------------------------------------------------------------
	Print_How_Many_Do_You_Buy(_price, _has_limited_stored, _stored)
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy < _old_value):
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Change_EquipItem_Hold_Label(_equip_serializable: Equip_Serializable, _button:Button):
	var _label: Label = _button.get_child(0) as Label
	_label.text = ""
	_label.text += "["+str(_equip_serializable.stored)+"]  "
	_label.text += Get_Money_Label(_equip_serializable.equip_resource.price)+"  "
#-------------------------------------------------------------------------------
func Set_Max_Items_You_Can_Buy(_stored:int, _price:int, _whole_cost:int):
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy > _stored):
		how_many_would_you_buy = _stored
	#-------------------------------------------------------------------------------
	while(money_inventory.stored < _whole_cost):
		how_many_would_you_buy -= 1
		_whole_cost = _price * how_many_would_you_buy
	#-------------------------------------------------------------------------------
	if(how_many_would_you_buy < 1):
		how_many_would_you_buy = 1
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Change_KeyItem_Hold_Label(_key_serializable: Key_Serializable, _button:Button):
	var _label: Label = _button.get_child(0) as Label
	_label.text = ""
	_label.text += "["+str(_key_serializable.stored)+"]  "
	_label.text += Get_Money_Label(_key_serializable.key_resource.price)+"  "
#-------------------------------------------------------------------------------
func Create_ConsumableItem_InMarket_Button(_item_serializable: Action_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = Get_Tr_Consumable_Item_Name(_item_serializable.action_resource)+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_button.icon = _item_serializable.action_resource.icon
	#-------------------------------------------------------------------------------
	var _label2: RichTextLabel = RichTextLabel.new()
	_label2.bbcode_enabled = true
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.mouse_filter = Control.MOUSE_FILTER_PASS
	_label2.text = ""
	_label2.text += "[font_size=16]"+Get_Money_Label(_item_serializable.action_resource.price)+"  "+"[/font_size]"
	#_label2.text += "["+str(_item_serializable.stored)+"]  "
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_EquipItem_InMarket_Button(_equip_serializable: Equip_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = Get_Tr_Equip_Item_Name(_equip_serializable.equip_resource)+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_button.icon = _equip_serializable.equip_resource.icon
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.add_theme_font_size_override("font_size", 16)
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = ""
	_label2.text += "["+str(_equip_serializable.stored)+"]  "
	_label2.text += Get_Money_Label(_equip_serializable.equip_resource.price)+"  "
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Create_KeyItem_InMarket_Button(_key_serializable: Key_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = Get_Tr_Key_Item_Name(_key_serializable.key_resource)+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_button.icon = _key_serializable.key_resource.icon
	#-------------------------------------------------------------------------------
	var _label2: Label = Label.new()
	_label2.add_theme_font_size_override("font_size", 16)
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.text = ""
	_label2.text += "["+str(_key_serializable.stored)+"]  "
	_label2.text += Get_Money_Label(_key_serializable.key_resource.price)+"  "
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CONFIRM BUY MENU
#-------------------------------------------------------------------------------
func Confirm_Buy_Menu_Submit(_submit:Callable, _button:Button, _up:Callable, _down:Callable, _left:Callable, _right:Callable):
	confirm_buy_menu.show()
	_button.disabled = true
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		confirm_buy_menu.hide()
		_button.disabled = false
		main_canvas_layer.nothing_cancel = func(): Close_Market()
		singleton.Move_to_Button(_button)
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = _cancel
	#-------------------------------------------------------------------------------
	singleton.Set_Button_Up_Down_Left_Right(confirm_buy_menu_button, func():pass, _submit, _up, _down, _left, _right)
	singleton.Move_to_Button(confirm_buy_menu_button)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Print_How_Many_Do_You_Buy(_price:int, _has_limited_stored:bool, _stored:int):
	#-------------------------------------------------------------------------------
	if(_has_limited_stored):
		confirm_buy_menu_button.text = "["+str(how_many_would_you_buy)+"/"+str(_stored)+"]"
	#-------------------------------------------------------------------------------
	else:
		confirm_buy_menu_button.text = "["+str(how_many_would_you_buy)+"]"
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_price.text = Get_Money_Label(_price * how_many_would_you_buy)
	confirm_buy_menu_item_price.text += "  /  "+Get_Money_Label(money_inventory.stored)
#-------------------------------------------------------------------------------
func Print_How_Many_Do_You_Hold_and_Stored(_action_serializable:Action_Serializable):
	confirm_buy_menu_hold_value.text = "["+str(_action_serializable.hold)+"/"+str(_action_serializable.action_resource.max_hold)+"]"
	confirm_buy_menu_stored_value.text = "["+str(_action_serializable.stored)+"]"
#-------------------------------------------------------------------------------
func Print_How_Many_Do_You_Stored(_stored:int):
	confirm_buy_menu_hold_value.text = "-"
	confirm_buy_menu_stored_value.text = "["+str(_stored)+"]"
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region GET ID FUNCTIONS
#-------------------------------------------------------------------------------
func Get_Item_Script_ID(_node:Node) -> String:
	var _s: String = current_room.room_id+"_"+_node.name
	return _s
#-------------------------------------------------------------------------------
func Get_Room_Path(_room_name:String) -> String:
	return "res://Nodes/Prefabs/Rooms/"+_room_name+".tscn"
#-------------------------------------------------------------------------------
func Get_MerchantId_and_ItemId_and_Hold(_name:String, _resource:Resource) -> String:
	var _id: String = current_room.room_id+"_"+_name+"_"+singleton.get_resource_filename(_resource)+"_hold"
	return _id
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ADD/GET ITEMS FUNCTIONS
#-------------------------------------------------------------------------------
func Add_ConsumableItem_to_Inventory(_item_serializable: Action_Serializable, _hold:int) -> Action_Serializable:
	#-------------------------------------------------------------------------------
	for _i in item_consumable_inventory.size():
		#-------------------------------------------------------------------------------
		if(item_consumable_inventory[_i].action_resource == _item_serializable.action_resource):
			#-------------------------------------------------------------------------------
			if(_item_serializable.action_resource.max_hold > 0):
				item_consumable_inventory[_i].hold += _hold
				#-------------------------------------------------------------------------------
				if(item_consumable_inventory[_i].hold > _item_serializable.action_resource.max_hold):
					var _extra: int = item_consumable_inventory[_i].hold - _item_serializable.action_resource.max_hold
					item_consumable_inventory[_i].hold = _item_serializable.action_resource.max_hold
					item_consumable_inventory[_i].stored += _extra
					return item_consumable_inventory[_i]
				#-------------------------------------------------------------------------------
				else:
					return item_consumable_inventory[_i]
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				item_consumable_inventory[_i].stored += _hold
				return item_consumable_inventory[_i]
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _new_item: Action_Serializable = Duplicate_Consumable_Serializable(_item_serializable)
	#-------------------------------------------------------------------------------
	if(_item_serializable.action_resource.max_hold > 0):
		_new_item.hold = _hold
		#-------------------------------------------------------------------------------
		if(_new_item.hold > _item_serializable.action_resource.max_hold):
			var _extra: int = _new_item.hold - _item_serializable.action_resource.max_hold
			_new_item.hold = _item_serializable.action_resource.max_hold
			_new_item.stored += _extra
			item_consumable_inventory.append(_new_item)
			return _new_item
		#-------------------------------------------------------------------------------
		else:
			item_consumable_inventory.append(_new_item)
			return _new_item
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		_new_item.stored = _hold
		item_consumable_inventory.append(_new_item)
		return _new_item
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_ConsumableItem_in_Inventory(_item_resource: Action_Resource) -> Action_Serializable:
	#-------------------------------------------------------------------------------
	for _i in item_consumable_inventory.size():
		#-------------------------------------------------------------------------------
		if(item_consumable_inventory[_i].action_resource == _item_resource):
			return item_consumable_inventory[_i]
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _new_item: Action_Serializable = Create_Consumable_Serializable(_item_resource)
	#-------------------------------------------------------------------------------
	return _new_item
#-------------------------------------------------------------------------------
func Add_EquipItem_to_Inventory(_equip_serializable: Equip_Serializable, _hold:int) -> Equip_Serializable:
	return Add_Equip_Serializable_to_Array(item_equip_inventory, _equip_serializable.equip_resource, _hold)
#-------------------------------------------------------------------------------
func Get_EquipItem_in_Inventory(_equip_resource:Equip_Resource) -> Equip_Serializable:
	#-------------------------------------------------------------------------------
	for _i in item_equip_inventory.size():
		#-------------------------------------------------------------------------------
		if(item_equip_inventory[_i].equip_resource == _equip_resource):
			return item_equip_inventory[_i]
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
	_equip_serializable.equip_resource = _equip_resource
	_equip_serializable.stored = 0
	#-------------------------------------------------------------------------------
	return _equip_serializable
#-------------------------------------------------------------------------------
func Add_Equip_Serializable_to_Array(_equip_array:Array[Equip_Serializable], _equip_resource:Equip_Resource, _hold: int) -> Equip_Serializable:
	#-------------------------------------------------------------------------------
	for _i in _equip_array.size():
		#-------------------------------------------------------------------------------
		if(_equip_array[_i].equip_resource == _equip_resource):
			_equip_array[_i].stored += _hold
			return _equip_array[_i]
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_serializable: Equip_Serializable = Create_Equip_Serializable_with_Equip_Resource(_equip_resource, _hold)
	_equip_array.append(_equip_serializable)
	return _equip_serializable
#-------------------------------------------------------------------------------
func Create_Equip_Serializable_with_Equip_Resource(_equip_resource:Equip_Resource, _hold:int) -> Equip_Serializable:
	var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
	#-------------------------------------------------------------------------------
	_equip_serializable.equip_resource = _equip_resource
	_equip_serializable.stored = _hold
	#-------------------------------------------------------------------------------
	return _equip_serializable
#-------------------------------------------------------------------------------
func Add_KeyItem_to_Inventory(_key_serializable: Key_Serializable, _hold:int) -> Key_Serializable:
	#-------------------------------------------------------------------------------
	if(_key_serializable.key_resource == money_inventory.key_resource):
		money_inventory.stored += _hold
		return money_inventory
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		for _i in item_key_inventory.size():
			#-------------------------------------------------------------------------------
			if(item_key_inventory[_i].key_resource == _key_serializable.key_resource):
				item_key_inventory[_i].stored += _hold
				return item_key_inventory[_i]
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		var _new_key_serializable: Key_Serializable = Create_Key_Serializable(_key_serializable.key_resource, _hold)
		item_key_inventory.append(_new_key_serializable)
		return _new_key_serializable
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_KeyItem_in_Inventory(_key_resource:Key_Resource) -> Key_Serializable:
	#-------------------------------------------------------------------------------
	if(_key_resource == money_inventory.key_resource):
		return money_inventory
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		for _i in item_key_inventory.size():
			#-------------------------------------------------------------------------------
			if(item_key_inventory[_i].key_resource == _key_resource):
				return item_key_inventory[_i]
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		var _new_key_serializable: Key_Serializable = Create_Key_Serializable(_key_resource, 0)
		return _new_key_serializable
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region ENTER BATTLE FUNCTIONS
#-------------------------------------------------------------------------------
func Set_Battle_Background():
	battle_background_root.show()
	battle_background_root.size = Vector2(width, height)/camera.zoom + Vector2(2,2)
	battle_background_root.global_position = camera.global_position - battle_background_root.size*0.5
#-------------------------------------------------------------------------------
func Set_Fighter_Before_Battle(_fighter_node_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	for _i in _fighter_node_array.size():
		_fighter_node_array[_i].fighter_serializable_in_battle = Duplicate_Fighter_Serializable(_fighter_node_array[_i].fighter_serializable)
		var _fighter_serializable: Fighter_Serializable = _fighter_node_array[_i].fighter_serializable_in_battle
		Set_Skill(_fighter_serializable)
		#-------------------------------------------------------------------------------
		var _max_hp: int = Get_Max_HP(_fighter_serializable)
		var _hp: int = _max_hp
		#-------------------------------------------------------------------------------
		_fighter_serializable.hp = _max_hp
		#-------------------------------------------------------------------------------
		var _fighter_ui: Fighter_UI = _fighter_node_array[_i].fighter_ui
		_fighter_ui.hp_label.text = Get_Fighter_Hp_Text(_hp, _max_hp)
		_fighter_ui.hp_bar.max_value = _max_hp
		_fighter_ui.hp_bar.value = _hp
		#-------------------------------------------------------------------------------
		_fighter_ui.global_position = Get_Position_in_Canvas_Layer(_fighter_node_array[_i].global_position)
		#-------------------------------------------------------------------------------
		var _name: String = Get_Tr_Character_Name(_fighter_node_array[_i].character_node.character_resource)
		var _level: String = "[Lv."+str(_fighter_node_array[_i].fighter_serializable_in_battle.level)+"]"
		_fighter_ui.button.text = "  "+_name+" "+_level+"  "
		#-------------------------------------------------------------------------------
		_fighter_ui.button.show()
		_fighter_ui.button_root.hide()
		_fighter_ui.dialogue_root.hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_All_Fighters_its_Ally_and_Enemy_Parties():
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		ally_party[_i].user_party = ally_party
		ally_party[_i].opponent_party = enemy_party
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].user_party = enemy_party
		enemy_party[_i].opponent_party = ally_party
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Fighter_After_Battle(_fighter_node_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	for _i in _fighter_node_array.size():
		_fighter_node_array[_i].fighter_serializable = Duplicate_Fighter_Serializable(_fighter_node_array[_i].fighter_serializable_in_battle)
		var _fighter_serializable: Fighter_Serializable = _fighter_node_array[_i].fighter_serializable
		Set_Skill(_fighter_serializable)
		#-------------------------------------------------------------------------------
		var _max_hp: int = Get_Max_HP(_fighter_serializable)
		var _hp: int = _max_hp
		#-------------------------------------------------------------------------------
		_fighter_serializable.hp = _max_hp
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_All_Fighters_Position_1():
	await Set_All_Fighters_Position_Common(0.17, 0.42, -0.15, 0.25)
#-------------------------------------------------------------------------------
func Set_All_Fighters_Position_2():
	await Set_All_Fighters_Position_Common(0.35, 0.35, -0.4, 0.63)
#-------------------------------------------------------------------------------
func Set_All_Fighters_Last_Position():
	#-------------------------------------------------------------------------------
	var _tween:Tween = create_tween()
	var _timer: float = 0.3
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		Animation_StateMachine_Set(ally_party[_i].character_node.animation_tree, state_machine_layer_1, "Idle")
		ally_party[_i].z_index = world_order
		_tween.parallel().tween_property(ally_party[_i].character_node, "position", Vector2.ZERO, _timer)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		Animation_StateMachine_Set(enemy_party[_i].character_node.animation_tree, state_machine_layer_1, "Idle")
		enemy_party[_i].z_index = world_order
		_tween.parallel().tween_property(enemy_party[_i].character_node, "position", Vector2.ZERO, _timer)
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Set_All_Fighters_Position_Common(_x1:float, _x2:float, _y1:float, _y2:float):
	var _camera_center: Vector2 = camera.global_position
	#-------------------------------------------------------------------------------
	var _ally_dx: float = (_x2-_x1) / (ally_party.size()+1)
	var _ally_dy: float = (_y2-_y1) / (ally_party.size()+1)
	#-------------------------------------------------------------------------------
	var _tween:Tween = create_tween()
	var _timer: float = 0.3
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		Face_Left(ally_party[_i].character_node, false)
		Animation_StateMachine_Set(ally_party[_i].character_node.animation_tree, state_machine_layer_1, "Battle_Idle")
		ally_party[_i].z_index = battle_order
		ally_party[_i].show()
		#-------------------------------------------------------------------------------
		var _x: float = camera_size.x * (-_x1 - (_i+1) * _ally_dx)
		var _y: float = camera_size.y * (_y1 + (_i+1) * _ally_dy)
		#-------------------------------------------------------------------------------
		var _final_position: Vector2 = _camera_center + Vector2(_x, _y)
		var _final_position_ui: Vector2 = Get_Position_in_Canvas_Layer(_final_position)
		#-------------------------------------------------------------------------------
		_tween.parallel().tween_property(ally_party[_i].character_node, "global_position", _final_position, _timer)
		_tween.parallel().tween_property(ally_party[_i].fighter_ui, "global_position", _final_position_ui, _timer)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _enemy_dx: float = (_x2-_x1) / (enemy_party.size()+1)
	var _enemy_dy: float = (_y2-_y1) / (enemy_party.size()+1)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():	
		Face_Left(enemy_party[_i].character_node, true)
		Animation_StateMachine_Set(enemy_party[_i].character_node.animation_tree, state_machine_layer_1, "Battle_Idle")
		enemy_party[_i].z_index = battle_order
		enemy_party[_i].show()
		#-------------------------------------------------------------------------------
		var _x: float = camera_size.x * (_x1 + (_i+1) * _enemy_dx)
		var _y: float = camera_size.y * (_y1 + (_i+1) * _enemy_dy)
		#-------------------------------------------------------------------------------
		var _final_position: Vector2 = _camera_center + Vector2(_x, _y)
		var _final_position_ui: Vector2 = Get_Position_in_Canvas_Layer(_final_position)
		#-------------------------------------------------------------------------------
		_tween.parallel().tween_property(enemy_party[_i].character_node, "global_position", _final_position, _timer)
		_tween.parallel().tween_property(enemy_party[_i].fighter_ui, "global_position", _final_position_ui, _timer)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	await _tween.finished
#-------------------------------------------------------------------------------
func Create_All_Fighter_UI():
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		Create_Fighter_UI(ally_party[_i], fighter_ally_ui_prefab)
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		Create_Fighter_UI(enemy_party[_i], fighter_enemy_ui_prefab)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Delete_All_Fighters_UI():
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		ally_party[_i].fighter_ui.queue_free()
		ally_party[_i].fighter_ui = null
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].fighter_ui.queue_free()
		enemy_party[_i].fighter_ui = null
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Show_All_Fighters_UI():
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		ally_party[_i].fighter_ui.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].fighter_ui.show()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Create_Fighter_UI(_fighter_node:Fighter_Node, _fighter_ui_prefab:PackedScene):
	var _fighter_ui: Fighter_UI = _fighter_ui_prefab.instantiate() as Fighter_UI
	_fighter_node.fighter_ui = _fighter_ui
	battle_ui.add_child(_fighter_ui)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func BattleMenu_Set(_user:Fighter_Node):
	main_canvas_layer.nothing_cancel = func():BattleMenu_Cancel()
	#-------------------------------------------------------------------------------
	var _selected: Callable = func(): singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	var _skill_submit: Callable = func(): Battle_Menu_Skill_Button_Submit(_user)
	var _item_submit: Callable = func(): Battle_Menu_Item_Button_Submit(_user)
	var _status_submit: Callable = func(): Battle_Menu_Status_Button_Submit(_user)
	var _statistics_submit: Callable = func(): Battle_Menu_Statistics_Button_Submit(_user)
	#-------------------------------------------------------------------------------
	singleton.Set_Button(battle_menu_button_skill, _selected, _skill_submit)
	singleton.Set_Button(battle_menu_button_item, _selected, _item_submit)
	singleton.Set_Button(battle_menu_button_status, _selected, _status_submit)
	singleton.Set_Button(battle_menu_button_statistics, _selected, _statistics_submit)
	#-------------------------------------------------------------------------------
	var _button_array: Array[Button] = [
		battle_menu_button_skill,
		battle_menu_button_item,
		battle_menu_button_status,
		battle_menu_button_statistics
	]
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(_button_array)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Cancel():
	ally_party[current_fighter_turn].action_serializable = null
	#-------------------------------------------------------------------------------
	var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	current_fighter_turn -= 1
	#-------------------------------------------------------------------------------
	if(current_fighter_turn < 0):
		lock_on.hide()
		Set_Escape_Menu()
	#-------------------------------------------------------------------------------
	else:
		var _tp: int = Get_Future_TP()
		Set_TP_Bar(_tp)
		Set_Lock_On_Position(_alive_ally_party[current_fighter_turn])
		_alive_ally_party[current_fighter_turn].action_serializable = null
		BattleMenu_Set(_alive_ally_party[current_fighter_turn])
		singleton.Move_to_Button_by_Cancel(battle_menu_button_skill)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Escape_Menu():
	escape_menu.show()
	battle_menu.hide()
	var _yes_submit: Callable = func():Escape_Menu_Yes_Button_Submit()
	var _no_submit: Callable = func():Escape_Menu_No_Button_Submit()
	var _selected: Callable = func():singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func():Escape_Menu_Any_Button_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(escape_menu_yes_button, _selected, _yes_submit)
	singleton.Set_Button(escape_menu_no_button, _selected, _no_submit)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button_by_Cancel(escape_menu_no_button)
#-------------------------------------------------------------------------------
func Escape_Menu_Yes_Button_Submit():
	myBATTLE_STATE = BATTLE_STATE.YOU_ESCAPE
	main_canvas_layer.nothing_cancel = func():pass
	#-------------------------------------------------------------------------------
	escape_menu.hide()
	singleton.Common_Submited()
	next_signal.emit()
#-------------------------------------------------------------------------------
func Escape_Menu_No_Button_Submit():
	Escape_Menu_No_Button_Common()
	singleton.Move_to_Button_by_Submit(battle_menu_button_skill)
#-------------------------------------------------------------------------------
func Escape_Menu_Any_Button_Cancel():
	Escape_Menu_No_Button_Common()
	singleton.Move_to_Button_by_Cancel(battle_menu_button_skill)
#-------------------------------------------------------------------------------
func Escape_Menu_No_Button_Common():
	battle_menu.show()
	escape_menu.hide()
	main_canvas_layer.nothing_cancel = func():BattleMenu_Cancel()
	current_fighter_turn = 0
	lock_on.show()
	var _alive_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	Set_Lock_On_Position(_alive_party[current_fighter_turn])
#-------------------------------------------------------------------------------
#region BATTLE STATE-MACHINE
#-------------------------------------------------------------------------------
func Enter_Battle(_array_enemy_party:Array[Fighter_Node]):
	enemy_party = _array_enemy_party
	#-------------------------------------------------------------------------------
	myGAME_STATE = GAME_STATE.IN_BATTLE
	myBATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
	player_interactable_by_action_collider.disabled = true
	#-------------------------------------------------------------------------------
	singleton.Stop_BGM()
	singleton.Play_SFX_Enter_Battle()
	await Fade_Out_Override()
	#-------------------------------------------------------------------------------
	Set_Battle_Background()
	tp_bar.show()
	tp = 100
	Set_TP_Bar(tp)
	dialogue_menu.show()
	#-------------------------------------------------------------------------------
	Set_Inventory_When_Enter_Battle()
	#-------------------------------------------------------------------------------
	Create_All_Fighter_UI()
	Set_Fighter_Before_Battle(ally_party)
	Set_Fighter_Before_Battle(enemy_party)
	Set_All_Fighters_its_Ally_and_Enemy_Parties()
	#-------------------------------------------------------------------------------
	await Set_All_Fighters_Position_1()
	#-------------------------------------------------------------------------------
	await Fade_In_Override()
	await Seconds(0.1)
	singleton.Play_BGM_Battle1()
	battle_menu.show()
	#-------------------------------------------------------------------------------
	current_fighter_turn = 0
	lock_on.show()
	var _alive_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	Set_Lock_On_Position(_alive_party[current_fighter_turn])
	#-------------------------------------------------------------------------------
	var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	BattleMenu_Set(_alive_ally_party[current_fighter_turn])
	singleton.Move_to_Button(battle_menu_button_skill)
#-------------------------------------------------------------------------------
func You_Retry():
	myBATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
	#-------------------------------------------------------------------------------
	await Fade_Out_Override()
	#-------------------------------------------------------------------------------
	tp = 100
	Set_TP_Bar(tp)
	#-------------------------------------------------------------------------------
	Set_Inventory_When_Enter_Battle()
	#-------------------------------------------------------------------------------
	Set_Fighter_Before_Battle(ally_party)
	Set_Fighter_Before_Battle(enemy_party)
	Set_All_Fighters_its_Ally_and_Enemy_Parties()
	#-------------------------------------------------------------------------------
	await Set_All_Fighters_Position_1()
	#-------------------------------------------------------------------------------
	await Fade_In_Override()
	await Seconds(0.1)
	battle_menu.show()
	#-------------------------------------------------------------------------------
	current_fighter_turn = 0
	lock_on.show()
	var _alive_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	Set_Lock_On_Position(_alive_party[current_fighter_turn])
	#-------------------------------------------------------------------------------
	var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	BattleMenu_Set(_alive_ally_party[current_fighter_turn])
	singleton.Move_to_Button(battle_menu_button_skill)
#-------------------------------------------------------------------------------
func Win_Effect():
	myGAME_STATE = GAME_STATE.IN_MENU
	#-------------------------------------------------------------------------------
	win_menu.show()
	await Seconds(2.0)
	win_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Stop_BGM()
	singleton.Play_SFX_Escape_Battle()
	await Fade_Out_Override()
#-------------------------------------------------------------------------------
func You_Win():
	#-------------------------------------------------------------------------------
	battle_background_root.hide()
	tp_bar.hide()
	dialogue_menu.hide()
	#-------------------------------------------------------------------------------
	Set_Inventory_When_Exit_Battle()
	Fill_the_ConsumableItems_Hold_from_Stored_and_Remove_Cooldown()
	Remove_Zero_Consumable_Item_in_Hold_and_Stored()
	#-------------------------------------------------------------------------------
	Delete_All_Fighters_UI()
	Set_Fighter_After_Battle(ally_party)
	Set_Fighter_After_Battle(enemy_party)
	await Set_All_Fighters_Last_Position()
	#-------------------------------------------------------------------------------
	await Fade_In_Override()
	await Seconds(0.1)
	singleton.Play_BGM_Stage1()
	#-------------------------------------------------------------------------------
	lock_on.hide()
	myGAME_STATE = GAME_STATE.IN_WORLD
	player_interactable_by_action_collider.disabled = false
#-------------------------------------------------------------------------------
func You_Lose():
	lose_menu.show()
	battle_menu.hide()
	lock_on.hide()
	dialogue_menu.show()
	#-------------------------------------------------------------------------------
	var _retry_submit: Callable = func():Lose_Menu_Retry_Button_Submit()
	var _go_to_savepoint_submit: Callable = func():Lose_Menu_Go_To_SavePoint_Button_Submit()
	var _give_up_submit: Callable = func():Lose_Menu_Give_Up_Button_Submit()
	var _selected: Callable = func():singleton.Common_Selected()
	main_canvas_layer.nothing_cancel = func():pass
	#-------------------------------------------------------------------------------
	singleton.Set_Button(lose_menu_retry_button, _selected, _retry_submit)
	singleton.Set_Button(lose_menu_go_to_savepoint_button, _selected, _go_to_savepoint_submit)
	singleton.Set_Button(lose_menu_give_up_button, _selected, _give_up_submit)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button_by_Cancel(lose_menu_retry_button)
	#-------------------------------------------------------------------------------
	await next_signal
#-------------------------------------------------------------------------------
func Lose_Menu_Retry_Button_Submit():
	myLOSE_STATE = LOSE_STATE.YOU_RETRY
	#-------------------------------------------------------------------------------
	lose_menu.hide()
	singleton.Common_Submited()
	next_signal.emit()
#-------------------------------------------------------------------------------
func Lose_Menu_Go_To_SavePoint_Button_Submit():
	myLOSE_STATE = LOSE_STATE.YOU_ESCAPE_TO_SAVEPOINT
	#-------------------------------------------------------------------------------
	lose_menu.hide()
	singleton.Common_Submited()
	next_signal.emit()
#-------------------------------------------------------------------------------
func Lose_Menu_Give_Up_Button_Submit():
	myLOSE_STATE = LOSE_STATE.YOU_GIVE_UP
	#-------------------------------------------------------------------------------
	lose_menu.hide()
	singleton.Common_Submited()
	next_signal.emit()
#-------------------------------------------------------------------------------
func You_Give_Up():
	Set_Go_to_Title_Menu_Yes_Button_Submit()
#-------------------------------------------------------------------------------
func You_Escape():
	battle_background_root.hide()
	tp_bar.hide()
	dialogue_menu.hide()
	lock_on.hide()
	#-------------------------------------------------------------------------------
	#Set_Inventory_When_Exit_Battle()
	Delete_All_Fighters_UI()
	#Set_Fighter_After_Battle(ally_party)
	#Set_Fighter_After_Battle(enemy_party)
	await Set_All_Fighters_Last_Position()
	#-------------------------------------------------------------------------------
	await Fade_In_Override()
	await Seconds(0.1)
	singleton.Play_BGM_Stage1()
	#-------------------------------------------------------------------------------
	myGAME_STATE = GAME_STATE.IN_WORLD
	player_interactable_by_action_collider.disabled = false
#-------------------------------------------------------------------------------
func You_Escape_to_SavePoint():
	battle_background_root.hide()
	tp_bar.hide()
	dialogue_menu.hide()
	lock_on.hide()
	#-------------------------------------------------------------------------------
	#Set_Inventory_When_Exit_Battle()
	Delete_All_Fighters_UI()
	#Set_Fighter_After_Battle(ally_party)
	#Set_Fighter_After_Battle(enemy_party)
	await Set_All_Fighters_Last_Position()
	#-------------------------------------------------------------------------------
	Set_Ally_Party_Position(player_starting_position)
	Camera_Set_Target_Position()
	#-------------------------------------------------------------------------------
	await Fade_In_Override()
	await Seconds(0.1)
	singleton.Play_BGM_Stage1()
	#-------------------------------------------------------------------------------
	myGAME_STATE = GAME_STATE.IN_WORLD
	player_interactable_by_action_collider.disabled = false
#-------------------------------------------------------------------------------
func Escape_Effect():
	myGAME_STATE = GAME_STATE.IN_MENU
	#-------------------------------------------------------------------------------
	singleton.Stop_BGM()
	singleton.Play_SFX_Escape_Battle()
	await Fade_Out_Override()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func Set_Ally_Party_Position(_position:Vector2):
	player_characterbody2d.global_position = _position
	ally_party[0].position = Vector2.ZERO
	#-------------------------------------------------------------------------------
	for _i in range(1,ally_party.size()):
		ally_party[_i].global_position = _position
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#region BATTLE SKILL MENU
#-------------------------------------------------------------------------------
func Battle_Menu_Skill_Button_Submit(_user:Fighter_Node):
	Battle_Skill_Menu_Set(_user)
	battle_menu.hide()
	dialogue_menu.hide()
	skill_menu.show()
#-------------------------------------------------------------------------------
func Battle_Skill_Menu_Set(_user:Fighter_Node):
	main_canvas_layer.nothing_cancel = func(): Battle_Menu_Skill_Button_Cancel()
	#-------------------------------------------------------------------------------
	var _fighter_serializable: Fighter_Serializable = _user.fighter_serializable_in_battle
	var _skill_serializable_array: Array[Action_Serializable] = Get_Skill(_fighter_serializable)
	#-------------------------------------------------------------------------------
	if(_skill_serializable_array.size() > 0):
		#-------------------------------------------------------------------------------
		for _i in _skill_serializable_array.size():
			var _hold: int = _skill_serializable_array[_i].hold
			var _cooldown: int = _skill_serializable_array[_i].cooldown
			#-------------------------------------------------------------------------------
			var _button: Button = Create_Skill_Button(_skill_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _w: Callable = func():singleton.ScrollContainer_Up(skill_menu_information_root)
			#-------------------------------------------------------------------------------
			var _s: Callable = func():singleton.ScrollContainer_Down(skill_menu_information_root)
			#-------------------------------------------------------------------------------
			var _selected: Callable = func(): Pause_Skill_Menu_Skill_Button_Selected(_skill_serializable_array[_i])
			var _submit: Callable = func(): BattleMenu_Skill_Button_Submit(_button, _user, _skill_serializable_array[_i], _hold, _cooldown)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WS(_button, _selected, _submit, _w, _s)
			#-------------------------------------------------------------------------------
			skill_menu_button_content.add_child(_button)
			skill_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		Disable_Item_Button_0(skill_menu_button_0)
		skill_menu_information_root.show()
		singleton.Button_Array_Set_Vertical_Navigation(skill_menu_button_array)
		singleton.Move_to_Button_by_Submit(skill_menu_button_array[0])
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button(skill_menu_button_0, _selected, _submit)
		#-------------------------------------------------------------------------------
		Enable_Item_Button_0(skill_menu_button_0)
		skill_menu_information_root.hide()
		singleton.Button_Remove_Navigation(skill_menu_button_0)
		singleton.Move_to_Button_by_Submit(skill_menu_button_0)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Battle_Menu_Skill_Button_Cancel():
	battle_menu.show()
	dialogue_menu.show()
	skill_menu.hide()
	main_canvas_layer.nothing_cancel = func():BattleMenu_Cancel()
	singleton.Destroy_Button_Array(skill_menu_button_array)
	singleton.Move_to_Button_by_Cancel(battle_menu_button_skill)
#-------------------------------------------------------------------------------
func BattleMenu_Skill_Button_Submit(_button:Button, _user:Fighter_Node, _skill_serializable:Action_Serializable, _hold:int, _cooldown:int):
	var _can: bool = Can_Use_This_Action(_skill_serializable, _hold, _cooldown)
	#-------------------------------------------------------------------------------
	if(_can):
		BattleMenu_Skill_Target_Set(_button, _user, _skill_serializable)
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Can_Use_This_Action(_action_serializable:Action_Serializable, _hold:int, _cooldown:int) -> bool:
	var _max_hold: int = _action_serializable.action_resource.max_hold
	#-------------------------------------------------------------------------------
	if(_hold>0 or _max_hold <=0):
		var _max_cooldown: int = _action_serializable.action_resource.max_cooldown
		#-------------------------------------------------------------------------------
		if(_cooldown<=0 or _max_cooldown <= 0):
			var _tp: int = Get_Future_TP()
			var _tp_cost: int = Get_Action_TP_Cost(_action_serializable)
			#-------------------------------------------------------------------------------
			if(_tp >= _tp_cost):
				return true
			#-------------------------------------------------------------------------------
			else:
				return false
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			return false
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		return false
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Skill_Target_Submit(_user:Fighter_Node, _skill_serializable:Action_Serializable, _target:Fighter_Node):
	singleton.Destroy_Button_Array(skill_menu_button_array)
	await After_Target_Select_Actions(_user, _skill_serializable, _target)
#-------------------------------------------------------------------------------
func After_Target_Select_Actions(_user:Fighter_Node, _action_serializable:Action_Serializable, _target:Fighter_Node):
	_user.action_serializable = _action_serializable
	_user.target = _target
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	current_fighter_turn +=1
	var _alive_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	var _max: int = _alive_party.size()-1
	#-------------------------------------------------------------------------------
	if(current_fighter_turn > _max):
		Set_TP_Bar(tp)
		Hide_All_Targets()
		next_signal.emit()
	#-------------------------------------------------------------------------------
	else:
		BattleMenu_Set(_alive_party[current_fighter_turn])
		Open_Battle_Menu(_alive_party[current_fighter_turn])
		singleton.Move_to_Button_by_Submit(battle_menu_button_skill)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Battle_State():
	myBATTLE_STATE = Get_Battle_State()
#-------------------------------------------------------------------------------
func Get_Battle_State() -> BATTLE_STATE:
	var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	var _alive_enemy_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(enemy_party)
	#-------------------------------------------------------------------------------
	if(_alive_ally_party.size() > 0):
		#-------------------------------------------------------------------------------
		if(_alive_enemy_party.size() > 0):
			return BATTLE_STATE.STILL_FIGHTING
		#-------------------------------------------------------------------------------
		else:
			return BATTLE_STATE.YOU_WIN
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		return BATTLE_STATE.YOU_LOSE
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Skill_Target_Cancel(_button:Button):
	var _tp: int = Get_Future_TP()
	Set_TP_Bar(_tp)
	dialogue_menu.hide()
	skill_menu.show()
	Hide_All_Targets()
	main_canvas_layer.nothing_cancel = func():Battle_Menu_Skill_Button_Cancel()
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func Do_Ally_Actions():
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE != BATTLE_STATE.STILL_FIGHTING):
		return
	#-------------------------------------------------------------------------------
	main_canvas_layer.nothing_cancel = func():pass
	lock_on.hide()
	#-------------------------------------------------------------------------------
	var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	#-------------------------------------------------------------------------------
	for _i in _alive_ally_party.size():
		#-------------------------------------------------------------------------------
		if(myBATTLE_STATE == BATTLE_STATE.STILL_FIGHTING):
			await Do_Ally_Action(_alive_ally_party[_i])
			await Seconds(pop_up_timer-0.3)
		#-------------------------------------------------------------------------------
		Set_Battle_State()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Ally_Action(_user:Fighter_Node):
	var _action_resource: Action_Resource = _user.action_serializable.action_resource
	#-------------------------------------------------------------------------------
	match(_action_resource.myTARGET):
		Action_Resource.TARGET.ENEMY_1:
			await Do_Repeat_Action_1(_user, _user.target)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_1:
			await Do_Repeat_Action_1(_user, _user.target)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.USER:
			await Do_Repeat_Action_1(_user, _user.target)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_DOWN_1:
			await Do_Repeat_Action_1(_user, _user.target)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ENEMY_ALL:
			var _target_array: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(_user.opponent_party)
			await Do_Repeat_Action_All(_user, _target_array)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ENEMY_RANDOM:
			var _target_array: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(_user.opponent_party)
			await Do_Repeat_Action_Random(_user, _target_array)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_ALL:
			var _target_array: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(_user.user_party)
			await Do_Repeat_Action_All(_user, _target_array)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_RANDOM:
			var _target_array: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(_user.user_party)
			await Do_Repeat_Action_Random(_user, _target_array)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_DOWN_ALL:
			var _target_array: Array[Fighter_Node] = Get_Dead_Fighter_Party_in_Battle(_user.user_party)
			await Do_Repeat_Action_All(_user, _target_array)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Repeat_Action_1(_user:Fighter_Node, _target:Fighter_Node):
	var _action_serializable: Action_Serializable = _user.action_serializable
	var _tp_cost: int = Get_Tp_Cost_of_Action(_user, _action_serializable)
	#-------------------------------------------------------------------------------
	if(tp >= _tp_cost):
		Show_Ally_Action(_user)
		Set_TP_Bar_and_Action_Cost(_action_serializable, _tp_cost)
		await Seconds(0.3)
		#-------------------------------------------------------------------------------
		for _i in _action_serializable.action_resource.repeat:
			Do_Classic_RPG_Action(_user, _target)
			await Seconds(0.15)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		await Fail_Action_for_Lack_of_TP(_user)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_TP_Bar_and_Action_Cost(_action_serializable:Action_Serializable, _tp_cost:int):
	tp -= _tp_cost
	Set_TP_Bar(tp)
	#-------------------------------------------------------------------------------
	_action_serializable.hold -= 1
	_action_serializable.cooldown = _action_serializable.action_resource.max_cooldown + 1
#-------------------------------------------------------------------------------
func Get_Tp_Cost_of_Action(_user:Fighter_Node, _action_serializable:Action_Serializable) -> int:
	var _tp_cost: int = int(float(_action_serializable.action_resource.tp_cost) * float(Get_TP_Cost_Rate(_user.fighter_serializable_in_battle)/100.0))
	return _tp_cost
#-------------------------------------------------------------------------------
func Do_Repeat_Action_All(_user:Fighter_Node, _target_array:Array[Fighter_Node]):
	var _action_serializable: Action_Serializable = _user.action_serializable
	var _tp_cost: int = Get_Tp_Cost_of_Action(_user, _action_serializable)
	#-------------------------------------------------------------------------------
	if(tp >= _tp_cost):
		Show_Ally_Action(_user)
		Set_TP_Bar_and_Action_Cost(_action_serializable, _tp_cost)
		await Seconds(0.3)
		#-------------------------------------------------------------------------------
		for _j in _target_array.size():
			#-------------------------------------------------------------------------------
			for _i in _action_serializable.action_resource.repeat:
				var _target: Fighter_Node = _target_array[_j]
				Do_Classic_RPG_Action(_user, _target)
				await Seconds(0.15)
			#-------------------------------------------------------------------------------
			#await Seconds(0.15)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		await Fail_Action_for_Lack_of_TP(_user)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Do_Repeat_Action_Random(_user:Fighter_Node, _target_array:Array[Fighter_Node]):
	var _action_serializable: Action_Serializable = _user.action_serializable
	var _tp_cost: int = Get_Tp_Cost_of_Action(_user, _action_serializable)
	#-------------------------------------------------------------------------------
	if(tp >= _tp_cost):
		Show_Ally_Action(_user)
		Set_TP_Bar_and_Action_Cost(_action_serializable, _tp_cost)
		await Seconds(0.3)
		#-------------------------------------------------------------------------------
		for _i in _action_serializable.action_resource.repeat:
			var _target: Fighter_Node = _target_array.pick_random()
			Do_Classic_RPG_Action(_user, _target)
			await Seconds(0.15)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		await Fail_Action_for_Lack_of_TP(_user)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Fail_Action_for_Lack_of_TP(_user:Fighter_Node):
	Show_Ally_Action(_user)
	await Seconds(0.3)
	dialogue_menu_value.text += " Pero no tenía suficiente PT."
	await Seconds(0.3)
#-------------------------------------------------------------------------------
func Do_Classic_RPG_Action(_user:Fighter_Node, _target:Fighter_Node):
	var _action_serializable: Action_Serializable = _user.action_serializable
	#-------------------------------------------------------------------------------
	if(_action_serializable == null):
		return
	#-------------------------------------------------------------------------------
	var _action_resource: Action_Resource = _action_serializable.action_resource
	Set_Classic_RPG_Damage_Calculation_by_Action(_user, _target, _action_resource)
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Classic_RPG_Damage_Calculation_by_Action(_user:Fighter_Node, _target:Fighter_Node, _action_resource: Action_Resource):
	Set_Classic_RPG_Damage_Calculation_1(_user, _target, _action_resource.value, _action_resource.presition, _action_resource.myEFFECT, _action_resource.myATRIBUTE, _action_resource.myELEMENT, _action_resource.status_dictionary)
#-------------------------------------------------------------------------------
func Set_Classic_RPG_Damage_Calculation_1(_user:Fighter_Node, _target:Fighter_Node, _value:int, _presition:int, _effect:Action_Resource.EFFECT, _atribute:Action_Resource.ATRIBUTE, _element:Action_Resource.ELEMENT, _status_dictionary: Dictionary[StringName, int]):
	var _user_serializable: Fighter_Serializable = _user.fighter_serializable_in_battle
	var _target_serializable: Fighter_Serializable = _target.fighter_serializable_in_battle
	#-------------------------------------------------------------------------------
	var _user_presition_rate: int = Get_Presition_Rate(_user_serializable, _atribute)
	var _target_evasion_rate: int = Get_Evasion_Rate(_target_serializable, _atribute)
	var _atribute_presition_calculation: int = _presition + _user_presition_rate - _target_evasion_rate
	#-------------------------------------------------------------------------------
	if(Get_Rate_100(_atribute_presition_calculation)):
		var _user_element: Vector4i = Get_Fighter_Elemental_Stats(_user_serializable, _element)
		var _target_element: Vector4i = Get_Fighter_Elemental_Stats(_target_serializable, _element)
		#-------------------------------------------------------------------------------
		var _elemental_presition_calculation: int = 100 + _user_element.z - _target_element.w
		#-------------------------------------------------------------------------------
		if(Get_Rate_100(_elemental_presition_calculation)):
			Set_Classic_RPG_Damage_Calculation_0(_user, _target, _user_element, _target_element, _value, _presition, _effect, _atribute, _element, _status_dictionary)
		#-------------------------------------------------------------------------------
		else:
			Set_Classic_RPG_Damage_Calculation_0(_target, _user, _target_element, _user_element, _value, _presition, _effect, _atribute, _element, _status_dictionary)
			singleton.Play_SFX_Reflect()
			Flying_PopUp(_target, "Reflect")
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		Flying_PopUp(_target, "Miss")
		singleton.Play_SFX_Miss()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Classic_RPG_Damage_Calculation_0(_user:Fighter_Node, _target:Fighter_Node, _user_element:Vector4i, _target_element:Vector4i, _value:int, _presition:int, _effect:Action_Resource.EFFECT, _atribute:Action_Resource.ATRIBUTE, _element:Action_Resource.ELEMENT, _status_dictionary: Dictionary[StringName, int]):
	var _user_serializable: Fighter_Serializable = _user.fighter_serializable_in_battle
	var _target_serializable: Fighter_Serializable = _target.fighter_serializable_in_battle
	#-------------------------------------------------------------------------------
	if(_value != 0):
		#-------------------------------------------------------------------------------
		match(_effect):
			Action_Resource.EFFECT.DAMAGE:
				var _elemental_value = Get_Classic_RPG_Damage_Calculation(_user_serializable, _target_serializable, _value, _atribute, _element)
				var _final_value: int  = Get_RPG_Scaling(_elemental_value, _user_element.x, _target_element.y)
				#-------------------------------------------------------------------------------
				Change_Fighter_HP(_target, -_final_value)
				singleton.Play_SFX_Damage()
			#-------------------------------------------------------------------------------
			Action_Resource.EFFECT.HEAL:
				var _pharmacology: int = Get_Recovery_Effect(_user_serializable)
				var _recoverty_effect: int = Get_Recovery_Effect(_target_serializable)
				var _final_value: int = Get_RPG_Scaling(_value, _pharmacology, _recoverty_effect)
				#-------------------------------------------------------------------------------
				Change_Fighter_HP(_target, _final_value)
				singleton.Play_SFX_Heal()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	Set_Classic_RPG_Calculated_Status_Effect_0(_user, _target, _status_dictionary)
#-------------------------------------------------------------------------------
func Get_RPG_Scaling(_value:int, _power:int, _absorb:int) -> int:
	var _final_value: int = int( float(_value) * float(_power)/100 * float(_absorb)/100 )
	return _final_value
#-------------------------------------------------------------------------------
func Add_Status(_user_serializable:Fighter_Serializable, _status_resource:Status_Resource):
	var _status_serializable_array: Array[Status_Serializable] = _user_serializable.status_serializable_array
	#-------------------------------------------------------------------------------
	for _i in _status_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_status_serializable_array[_i].status_resource == _status_resource):
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var status_serializable: Status_Serializable = Create_Status_Serializable(_status_resource, _status_resource.max_turns+1)
	_status_serializable_array.append(status_serializable)
	return
#-------------------------------------------------------------------------------
func Set_Classic_RPG_Calculated_Status_Effect_0(_user:Fighter_Node, _target:Fighter_Node, _status_dictionary: Dictionary[StringName, int]):
	var _user_serializable: Fighter_Serializable = _user.fighter_serializable_in_battle
	var _target_serializable: Fighter_Serializable = _target.fighter_serializable_in_battle
	#-------------------------------------------------------------------------------
	for _i in _status_dictionary.size():
		var _key: StringName = _status_dictionary.keys()[_i]
		var _value: int = _status_dictionary.values()[_i]
		#-------------------------------------------------------------------------------
		var status_resource_path: String = Get_Status_Resource_Path(_key)
		var _status_resource: Status_Resource = load(status_resource_path) as Status_Resource
		#-------------------------------------------------------------------------------
		if(!Has_Status(_target_serializable, _status_resource) and Get_Rate_100(_value)):
			Add_Status(_target_serializable, _status_resource)
			var _name: String = Get_Tr_Status_Effect_Name_0(_key)
			Flying_PopUp(_target, "+"+_name)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Has_Status(_user_serializable:Fighter_Serializable, _status_resource:Status_Resource) -> bool:
	var _status_serializable_array: Array[Status_Serializable] = _user_serializable.status_serializable_array
	#-------------------------------------------------------------------------------
	for _i in _status_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(_status_serializable_array[_i].status_resource == _status_resource):
			return true
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return false
#-------------------------------------------------------------------------------
func Get_Status_Resource_Path(_string_name:StringName) -> String:
	var _path: String = "res://Resources/Status/"+_string_name+".tres"
	return _path
#-------------------------------------------------------------------------------
func Get_Classic_RPG_Damage_Calculation(_user_serializable:Fighter_Serializable, _target_serializable:Fighter_Serializable, _value:int, _atribute:Action_Resource.ATRIBUTE, _element:Action_Resource.ELEMENT) -> int:
	var _user_attack: int = Get_Attack(_user_serializable, _atribute)
	var _target_defense: int = Get_Defense(_target_serializable, _atribute)
	#-------------------------------------------------------------------------------
	var _damage: float = (damage_scaling + float(_user_attack)) / damage_scaling
	var _armor: float = armor_scaling / (armor_scaling + float(_target_defense))
	var _final_value: int = int(float(_value) * _damage * _armor)
	#-------------------------------------------------------------------------------
	return _final_value
#-------------------------------------------------------------------------------
func Get_Rate_100(_value:int) -> bool:
	var _rate: int = randi_range(0, 100)
	#-------------------------------------------------------------------------------
	if(_value < _rate):
		return false
	#-------------------------------------------------------------------------------
	else:
		return true
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Attack(_user_serializable:Fighter_Serializable, _atribute:Action_Resource.ATRIBUTE)->int:
	var _user_attack: int
	#-------------------------------------------------------------------------------
	match(_atribute):
		Action_Resource.ATRIBUTE.PHYSICAL:
			_user_attack = Get_Physical_Attack(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ATRIBUTE.MAGICAL:
			_user_attack = Get_Magical_Attack(_user_serializable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _user_attack
#-------------------------------------------------------------------------------
func Get_Defense(_user_serializable:Fighter_Serializable, _atribute:Action_Resource.ATRIBUTE)->int:
	var _user_defense: int
	#-------------------------------------------------------------------------------
	match(_atribute):
		Action_Resource.ATRIBUTE.PHYSICAL:
			_user_defense = Get_Physical_Defense(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ATRIBUTE.MAGICAL:
			_user_defense = Get_Magical_Defense(_user_serializable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _user_defense
#-------------------------------------------------------------------------------
func Get_Presition_Rate(_user_serializable:Fighter_Serializable, _atribute:Action_Resource.ATRIBUTE)->int:
	var _user_presition_rate: int
	#-------------------------------------------------------------------------------
	match(_atribute):
		Action_Resource.ATRIBUTE.PHYSICAL:
			_user_presition_rate = Get_Physical_Presition_Rate(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ATRIBUTE.MAGICAL:
			_user_presition_rate = Get_Magical_Presition_Rate(_user_serializable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _user_presition_rate
#-------------------------------------------------------------------------------
func Get_Evasion_Rate(_user_serializable:Fighter_Serializable, _atribute:Action_Resource.ATRIBUTE)->int:
	var _user_evasion_rate: int
	#-------------------------------------------------------------------------------
	match(_atribute):
		Action_Resource.ATRIBUTE.PHYSICAL:
			_user_evasion_rate = Get_Physical_Evasion_Rate(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ATRIBUTE.MAGICAL:
			_user_evasion_rate = Get_Magical_Evasion_Rate(_user_serializable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _user_evasion_rate
#-------------------------------------------------------------------------------
func Get_Fighter_Elemental_Stats(_user_serializable:Fighter_Serializable, _element:Action_Resource.ELEMENT)->Vector4i:
	var _user_element: Vector4i
	#-------------------------------------------------------------------------------
	match(_element):
		Action_Resource.ELEMENT.NORMAL:
			_user_element = Get_Fighter_Elemental_Stats_Normal(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ELEMENT.WATER:
			_user_element = Get_Fighter_Elemental_Stats_Water(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ELEMENT.FIRE:
			_user_element = Get_Fighter_Elemental_Stats_Fire(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ELEMENT.EARTH:
			_user_element = Get_Fighter_Elemental_Stats_Earth(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ELEMENT.WIND:
			_user_element = Get_Fighter_Elemental_Stats_Wind(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ELEMENT.ICE:
			_user_element = Get_Fighter_Elemental_Stats_Ice(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ELEMENT.THUNDER:
			_user_element = Get_Fighter_Elemental_Stats_Thunder(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ELEMENT.LIGHT:
			_user_element = Get_Fighter_Elemental_Stats_Light(_user_serializable)
		#-------------------------------------------------------------------------------
		Action_Resource.ELEMENT.DARK:
			_user_element = Get_Fighter_Elemental_Stats_Dark(_user_serializable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _user_element
#-------------------------------------------------------------------------------
func Change_Fighter_HP(_target:Fighter_Node, _value:int):
	_target.fighter_serializable_in_battle.hp += _value
	var _max_hp: int = Get_Max_HP(_target.fighter_serializable_in_battle)
	var _hp: int = _target.fighter_serializable_in_battle.hp
	_target.fighter_ui.hp_label.text = Get_Fighter_Hp_Text(_hp, _max_hp)
	_target.fighter_ui.hp_bar.value = _hp
	_target.fighter_ui.hp_bar.max_value = _max_hp
	Flying_PopUp_HP(_target, _value)
#-------------------------------------------------------------------------------
func Show_Ally_Action(_fighter_node:Fighter_Node):
	var _user_name: String = Get_Tr_Character_Name(_fighter_node.character_node.character_resource)
	var _s: String = "* "+Text_Color_Yellow(_user_name)+" utiliza "
	#-------------------------------------------------------------------------------
	if(_fighter_node.action_serializable == null):
		_s+= Text_Color_Orange("Nada")
	#-------------------------------------------------------------------------------
	else:
		var _action_resource:Action_Resource = _fighter_node.action_serializable.action_resource
		var _action_name: String = Get_Tr_Action_Name(_action_resource)
		_s+= Text_Color_Orange(_action_name)
	#-------------------------------------------------------------------------------
	match(_fighter_node.action_serializable.action_resource.myTARGET):
		Action_Resource.TARGET.ENEMY_1:
			var _target_name: String = Get_Target_Name(_fighter_node.target)
			_s += " contra "+Text_Color_Yellow(_target_name)+"."
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_1:
			var _target_name: String = Get_Target_Name(_fighter_node.target)
			_s += " con "+Text_Color_Yellow(_target_name)+"."
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_DOWN_1:
			var _target_name: String = Get_Target_Name(_fighter_node.target)
			_s += " con "+Text_Color_Yellow(_target_name)+"."
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_ALL:
			_s += " con "+Text_Color_Yellow("Todos sus Aliados")+"."
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_RANDOM:
			_s += " con "+Text_Color_Yellow("1 Aliado al Azar")+"."
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ENEMY_ALL:
			_s += " contra "+Text_Color_Yellow("Todos sus Enemigos")+"."
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ENEMY_RANDOM:
			_s += " contra "+Text_Color_Yellow("1 Enemigo al Azar")+"."
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.USER:
			_s += " con "+Text_Color_Yellow("Sigo mismo")+"."
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_DOWN_ALL:
			_s += " con "+Text_Color_Yellow("Todos los Aliados Caidos")+"."
		#-------------------------------------------------------------------------------
	dialogue_menu_value.text = _s
	dialogue_menu_value.visible_characters = -1
#-------------------------------------------------------------------------------
func Text_Color_Yellow(_s:String) -> String:
	return "[color="+hex_color_yellow+"]"+_s+"[/color]"
#-------------------------------------------------------------------------------
func Text_Color_Orange(_s:String) -> String:
	return "[color="+hex_color_orange+"]"+_s+"[/color]"
#-------------------------------------------------------------------------------
func Get_Target_Name(_target:Fighter_Node) -> String:
	var _s: String
	#-------------------------------------------------------------------------------
	if(_target == null):
		_s = "Nadie."
	#-------------------------------------------------------------------------------
	else:
		var _target_name:String = Get_Tr_Character_Name(_target.character_node.character_resource)
		_s = _target_name
	#-------------------------------------------------------------------------------
	return _s
#-------------------------------------------------------------------------------
func Do_Enemy_Actions():
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE != BATTLE_STATE.STILL_FIGHTING):
		return
	#-------------------------------------------------------------------------------
	dialogue_menu.hide()
	Battle_Background_Dark_Fade_In()
	await Set_All_Fighters_Position_2()
	await Battle_Enemy_Dialogue_in_Bubbles()
	#-------------------------------------------------------------------------------
	Set_and_Show_Battle_Box()
	await Start_Timer_Tween(4)
	#-------------------------------------------------------------------------------
	Set_and_Hide_Battle_Box()
	Decrease_Item_Cooldown_by_1()
	await Decrease_All_Status_Effect_Turn_by_1()
	Decrease_Skill_Cooldown_by_1(ally_party)
	Decrease_Skill_Cooldown_by_1(enemy_party)
	#-------------------------------------------------------------------------------
	Battle_Background_Dark_Fade_Out()
	await Set_All_Fighters_Position_1()
	#-------------------------------------------------------------------------------
	After_Enemy_Actions()
#-------------------------------------------------------------------------------
func Decrease_Item_Cooldown_by_1():
	var _item_serializable_array: Array[Action_Serializable] = item_consumable_inventory_in_battle
	#-------------------------------------------------------------------------------
	for _i in range(_item_serializable_array.size()-1, -1, -1):
		_item_serializable_array[_i].cooldown -= 1
		#-------------------------------------------------------------------------------
		if(_item_serializable_array[_i].cooldown < 0):
			_item_serializable_array[_i].cooldown = 0
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Decrease_Skill_Cooldown_by_1(fighter_node_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	for _i in fighter_node_array.size():
		var _skill_serializable_array: Array[Action_Serializable] = Get_Skill(fighter_node_array[_i].fighter_serializable_in_battle)
		#-------------------------------------------------------------------------------
		for _j in _skill_serializable_array.size():
			_skill_serializable_array[_j].cooldown -= 1
			#-------------------------------------------------------------------------------
			if(_skill_serializable_array[_j].cooldown < 0):
				_skill_serializable_array[_j].cooldown = 0
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Decrease_All_Status_Effect_Turn_by_1():
	was_status_effect_add_or_removed = false
	Decrease_Status_Effect_Turn_by_1(ally_party)
	Decrease_Status_Effect_Turn_by_1(enemy_party)
	#-------------------------------------------------------------------------------
	if(was_status_effect_add_or_removed):
		await Seconds(pop_up_timer)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Decrease_Status_Effect_Turn_by_1(_fighter_node_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	for _i in _fighter_node_array.size():
		var _status_serializable_array: Array[Status_Serializable] = _fighter_node_array[_i].fighter_serializable_in_battle.status_serializable_array
		#-------------------------------------------------------------------------------
		for _j in range(_status_serializable_array.size()-1,-1,-1):
			#-------------------------------------------------------------------------------
			if(!_status_serializable_array[_j].status_resource.is_infinite):
				_status_serializable_array[_j].turns -= 1
				#-------------------------------------------------------------------------------
				if(_status_serializable_array[_j].turns <= 0):
					var _name: String = Get_Tr_Status_Effect_Name_1(_status_serializable_array[_j].status_resource)
					Flying_PopUp(_fighter_node_array[_i], "-"+_name)
					_status_serializable_array.remove_at(_j)
					was_status_effect_add_or_removed = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Battle_Enemy_Dialogue_in_Bubbles():
	Show_Enemy_Dialogue()
	await Seconds(2.0)
	Hide_Enemy_Dialogue()
#-------------------------------------------------------------------------------
func Battle_Background_Dark_Fade_In():
	await Battle_Background_Dark_Fade_Common(Color(0.0, 0.0, 0.0, 0.804))
#-------------------------------------------------------------------------------
func Battle_Background_Dark_Fade_Out():
	await Battle_Background_Dark_Fade_Common(Color(0.0, 0.0, 0.0, 0.0))
#-------------------------------------------------------------------------------
func Battle_Background_Dark_Fade_Common(_color:Color):
	var _tween: Tween = create_tween()
	_tween.tween_property(battle_background_dark_panel, "self_modulate",_color, 0.3)
	await _tween.finished
#-------------------------------------------------------------------------------
func After_Enemy_Actions():
	Set_All_Fighters_Actions_to_Null()
	#-------------------------------------------------------------------------------
	Set_Battle_State()
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE == BATTLE_STATE.STILL_FIGHTING):
		var _alive_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
		current_fighter_turn = 0
		BattleMenu_Set(_alive_party[current_fighter_turn])
		lock_on.show()
		Open_Battle_Menu(_alive_party[current_fighter_turn])
		singleton.Move_to_Button_by_Submit(battle_menu_button_skill)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Show_Enemy_Dialogue():
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].fighter_ui.dialogue_root.show()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_and_Show_Battle_Box():
	battle_box.global_position = camera.global_position - battle_box.size * battle_box.scale*0.5
	hitbox_root.position = battle_box.size * 0.5
	Set_Battle_Box_Limits()
	myGAME_STATE = GAME_STATE.IN_BATTLE
	battle_box.show()
#-------------------------------------------------------------------------------
func Set_and_Hide_Battle_Box():
	battle_box.hide()
	myGAME_STATE = GAME_STATE.IN_MENU
#-------------------------------------------------------------------------------
func Hide_Enemy_Dialogue():
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].fighter_ui.dialogue_root.hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Open_Battle_Menu(_user:Fighter_Node):
	Set_Lock_On_Position(_user)
	battle_menu.show()
	dialogue_menu.show()
	Hide_All_Targets()
	main_canvas_layer.nothing_cancel = func():BattleMenu_Cancel()
#-------------------------------------------------------------------------------
func Hide_All_Targets():
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		var _button_root: Control = ally_party[_i].fighter_ui.button_root
		var _button: Button = ally_party[_i].fighter_ui.button
		_button.toggle_mode = false
		_button.button_pressed = false
		_button_root.hide()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		var _button_root: Control = enemy_party[_i].fighter_ui.button_root
		var _button: Button = enemy_party[_i].fighter_ui.button
		_button.toggle_mode = false
		_button.button_pressed = false
		_button_root.hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Show_All_Targets():
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		var _button_root: Control = ally_party[_i].fighter_ui.button_root
		_button_root.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		var _button_root: Control = enemy_party[_i].fighter_ui.button_root
		_button_root.show()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_All_Fighters_Actions_to_Null():
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		ally_party[_i].action_serializable = null
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		enemy_party[_i].action_serializable = null
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Skill_Target_Set(_button:Button, _user:Fighter_Node, _action_serializable:Action_Serializable):
	#-------------------------------------------------------------------------------
	match(_action_serializable.action_resource.myTARGET):
		Action_Resource.TARGET.ENEMY_1:
			var _alive_enemy_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(enemy_party)
			BattleMenu_Skill_Target_Set_1(_button, _user, _action_serializable, _alive_enemy_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ENEMY_RANDOM:
			var _alive_enemy_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(enemy_party)
			BattleMenu_Skill_Target_Set_All(_button, _user, _action_serializable, _alive_enemy_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ENEMY_ALL:
			var _alive_enemy_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(enemy_party)
			BattleMenu_Skill_Target_Set_All(_button, _user, _action_serializable, _alive_enemy_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_1:
			var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Skill_Target_Set_1(_button, _user, _action_serializable, _alive_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_RANDOM:
			var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Skill_Target_Set_All(_button, _user, _action_serializable, _alive_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_ALL:
			var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Skill_Target_Set_All(_button, _user, _action_serializable, _alive_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.USER:
			var _alive_ally_party:Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle([_user])
			BattleMenu_Skill_Target_Set_1(_button, _user, _action_serializable, _alive_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_DOWN_1:
			var _dead_ally_party: Array = Get_Dead_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Skill_Target_Set_1(_button, _user, _action_serializable, _dead_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_DOWN_ALL:
			var _dead_ally_party: Array = Get_Dead_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Skill_Target_Set_All(_button, _user, _action_serializable, _dead_ally_party)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Skill_Target_Set_1(_button:Button, _user:Fighter_Node, _action_serializable:Action_Serializable, _fighter_node_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	if(_fighter_node_array.size()>0):
		main_canvas_layer.nothing_cancel = func():BattleMenu_Skill_Target_Cancel(_button)
		#-------------------------------------------------------------------------------
		for _i in _fighter_node_array.size():
			var _selected:Callable = func():singleton.Common_Selected()
			var _submit: Callable = func():BattleMenu_Skill_Target_Submit(_user, _action_serializable, _fighter_node_array[_i])
			#-------------------------------------------------------------------------------
			Set_Target_Button_1(_fighter_node_array[_i], _selected, _submit)
		#-------------------------------------------------------------------------------
		BattleMenu_Skill_Target_Set_Common(_action_serializable, _fighter_node_array)
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Skill_Target_Set_All(_button:Button, _user:Fighter_Node, _action_serializable:Action_Serializable, _fighter_node_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	if(_fighter_node_array.size()>0):
		main_canvas_layer.nothing_cancel = func():BattleMenu_Skill_Target_Cancel(_button)
		#-------------------------------------------------------------------------------
		for _i in _fighter_node_array.size():
			var _selected: Callable = func():pass
			var _submit: Callable = func():BattleMenu_Skill_Target_Submit(_user, _action_serializable, _fighter_node_array[_i])
			#-------------------------------------------------------------------------------
			Set_Target_Button_All(_fighter_node_array[_i], _selected, _submit)
		#-------------------------------------------------------------------------------
		BattleMenu_Skill_Target_Set_Common(_action_serializable, _fighter_node_array)
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Skill_Target_Set_Common(_action_serializable:Action_Serializable, _fighter_node_array:Array[Fighter_Node]):
	var _tp: int = Get_Future_TP()
	_tp -= Get_Action_TP_Cost(_action_serializable)
	Set_TP_Bar(_tp)
	#-------------------------------------------------------------------------------
	item_menu.hide()
	skill_menu.hide()
	dialogue_menu.show()
	Set_Target_Button_Navigation_1(_fighter_node_array)
	singleton.Move_to_Button_by_Submit(_fighter_node_array[0].fighter_ui.button)
#-------------------------------------------------------------------------------
func BattleMenu_Item_Target_Set(_button:Button, _user:Fighter_Node, _action_serializable:Action_Serializable):
	#-------------------------------------------------------------------------------
	match(_action_serializable.action_resource.myTARGET):
		Action_Resource.TARGET.ENEMY_1:
			var _alive_enemy_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(enemy_party)
			BattleMenu_Item_Target_Set_1(_button, _user, _action_serializable, _alive_enemy_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ENEMY_RANDOM:
			var _alive_enemy_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(enemy_party)
			BattleMenu_Item_Target_Set_All(_button, _user, _action_serializable, _alive_enemy_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ENEMY_ALL:
			var _alive_enemy_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(enemy_party)
			BattleMenu_Item_Target_Set_All(_button, _user, _action_serializable, _alive_enemy_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_1:
			var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Item_Target_Set_1(_button, _user, _action_serializable, _alive_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_RANDOM:
			var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Item_Target_Set_All(_button, _user, _action_serializable, _alive_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_ALL:
			var _alive_ally_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Item_Target_Set_All(_button, _user, _action_serializable, _alive_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.USER:
			var _alive_ally_party:Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle([ally_party[current_fighter_turn]])
			BattleMenu_Item_Target_Set_1(_button, _user, _action_serializable, _alive_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_DOWN_1:
			var _dead_ally_party: Array = Get_Dead_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Item_Target_Set_1(_button, _user, _action_serializable, _dead_ally_party)
		#-------------------------------------------------------------------------------
		Action_Resource.TARGET.ALLY_DOWN_ALL:
			var _dead_ally_party: Array = Get_Dead_Fighter_Party_in_Battle(ally_party)
			BattleMenu_Item_Target_Set_All(_button, _user, _action_serializable, _dead_ally_party)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Item_Target_Set_1(_button:Button, _user:Fighter_Node, _action_serializable:Action_Serializable, _fighter_node_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	if(_fighter_node_array.size()>0):
		main_canvas_layer.nothing_cancel = func():BattleMenu_Item_Target_Cancel(_button)
		#-------------------------------------------------------------------------------
		for _i in _fighter_node_array.size():
			var _selected:Callable = func():singleton.Common_Selected()
			var _submit:Callable = func():BattleMenu_Item_Target_Submit(_user, _action_serializable, _fighter_node_array[_i])
			#-------------------------------------------------------------------------------
			Set_Target_Button_1(_fighter_node_array[_i], _selected, _submit)
		#-------------------------------------------------------------------------------
		BattleMenu_Item_Target_Set_Common(_action_serializable, _fighter_node_array)
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func BattleMenu_Item_Target_Set_All(_button:Button, _user:Fighter_Node, _action_serializable:Action_Serializable, _fighter_node_array:Array[Fighter_Node]):
	#-------------------------------------------------------------------------------
	if(_fighter_node_array.size()>0):
		main_canvas_layer.nothing_cancel = func():BattleMenu_Item_Target_Cancel(_button)
		#-------------------------------------------------------------------------------
		for _i in _fighter_node_array.size():
			var _selected:Callable = func():pass
			var _submit:Callable = func():BattleMenu_Item_Target_Submit(_user, _action_serializable, _fighter_node_array[_i])
			#-------------------------------------------------------------------------------
			Set_Target_Button_All(_fighter_node_array[_i], _selected, _submit)
		#-------------------------------------------------------------------------------
		BattleMenu_Item_Target_Set_Common(_action_serializable, _fighter_node_array)
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Target_Button_1(_fighter_node:Fighter_Node, _selected:Callable, _submit:Callable):
	var _button_root: Control = _fighter_node.fighter_ui.button_root
	var _button: Button = _fighter_node.fighter_ui.button
	#-------------------------------------------------------------------------------
	singleton.Set_Button(_button, _selected, _submit)
	_button.toggle_mode = false
	_button.button_pressed = false
	_button_root.show()
#-------------------------------------------------------------------------------
func Set_Target_Button_All(_fighter_node:Fighter_Node, _selected:Callable, _submit:Callable):
	var _button_root: Control = _fighter_node.fighter_ui.button_root
	var _button: Button = _fighter_node.fighter_ui.button
	#-------------------------------------------------------------------------------
	singleton.Set_Button(_button, _selected, _submit)
	_button.toggle_mode = true
	_button.button_pressed = true
	_button_root.show()
#-------------------------------------------------------------------------------
func BattleMenu_Item_Target_Set_Common(_action_serializable:Action_Serializable, _fighter_node_array:Array[Fighter_Node]):
	var _tp: int = Get_Future_TP()
	_tp -= Get_Action_TP_Cost(_action_serializable)
	Set_TP_Bar(_tp)
	#-------------------------------------------------------------------------------
	item_menu.hide()
	skill_menu.hide()
	dialogue_menu.show()
	Set_Target_Button_Navigation_1(_fighter_node_array)
	singleton.Move_to_Button_by_Submit(_fighter_node_array[0].fighter_ui.button)
#-------------------------------------------------------------------------------
func Get_Alive_Fighter_Party_in_Battle(_fighter_node_array:Array[Fighter_Node]) -> Array[Fighter_Node]:
	var _alive_ally_party: Array[Fighter_Node]
	#-------------------------------------------------------------------------------
	for _i in _fighter_node_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_node_array[_i].fighter_serializable_in_battle.hp > 0):
			_alive_ally_party.append(_fighter_node_array[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _alive_ally_party
#-------------------------------------------------------------------------------
func Get_Dead_Fighter_Party_in_Battle(_fighter_node_array:Array[Fighter_Node]) -> Array[Fighter_Node]:
	var _dead_fighter_node_array: Array[Fighter_Node]
	#-------------------------------------------------------------------------------
	for _i in _fighter_node_array.size():
		#-------------------------------------------------------------------------------
		if(_fighter_node_array[_i].fighter_serializable_in_battle.hp <= 0):
			_dead_fighter_node_array.append(_fighter_node_array[_i])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _dead_fighter_node_array
#-------------------------------------------------------------------------------
func Battle_Menu_Item_Button_Submit(_user:Fighter_Node):
	Battle_Item_Menu_Set(_user)
	battle_menu.hide()
	dialogue_menu.hide()
	item_menu.show()
#-------------------------------------------------------------------------------
func Battle_Item_Menu_Set(_user:Fighter_Node):
	main_canvas_layer.nothing_cancel = func():Battle_Item_Menu_Consumable_Button_Cancel()
	var _submit_0: Callable = func():singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(item_menu_all_button_0, button_all_selected_0, _submit_0)
	singleton.Set_Button(item_menu_consumable_button_0, button_consumable_selected_0, _submit_0)
	singleton.Set_Button(item_menu_equip_button_0, button_equip_selected_0, _submit_0)
	singleton.Set_Button(item_menu_key_button_0, button_key_selected_0, _submit_0)
	#-------------------------------------------------------------------------------
	var _consumable_serializable_array: Array[Action_Serializable] = item_consumable_inventory_in_battle
	var _equip_serializable_array: Array[Equip_Serializable] = item_equip_inventory_in_battle
	var _key_serializable_array: Array[Key_Serializable] = Get_Key_Item_Inventory_in_Battle()
	#-------------------------------------------------------------------------------
	Sort_Action_by_ID(_consumable_serializable_array)
	Sort_Equip_by_ID(_equip_serializable_array)
	Sort_Key_by_ID(_key_serializable_array)
	#-------------------------------------------------------------------------------
	if(_consumable_serializable_array.size() >0):
		#-------------------------------------------------------------------------------
		for _i in _consumable_serializable_array.size():
			var _hold: int = Get_Future_Hold(_consumable_serializable_array[_i])
			var _cooldown: int = Get_Future_Cooldown(_consumable_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _consumable_button: Button = Create_ConsumableItem_Button(_consumable_serializable_array[_i], _hold, _cooldown)
			var _all_button: Button = Create_ConsumableItem_Button(_consumable_serializable_array[_i], _hold, _cooldown)
			#-------------------------------------------------------------------------------
			var _consumable_select_1: Callable = func():button_consumable_select_1(_consumable_serializable_array[_i])
			var _consumable_submit_1: Callable = func():Battle_Item_Menu_Consumable_Button_Sumbit(_consumable_button, _user, _consumable_serializable_array[_i], _hold, _cooldown)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_consumable_button, _consumable_select_1, _consumable_submit_1, button_consumable_w, button_consumable_s, button_consumable_a, button_consumable_d)
			item_menu_consumable_button_content.add_child(_consumable_button)
			item_menu_consumable_button_array.append(_consumable_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():button_all_consumable_select_1(_consumable_serializable_array[_i])
			var _all_submit_1: Callable = func():Battle_Item_Menu_Consumable_Button_Sumbit(_all_button, _user, _consumable_serializable_array[_i], _hold, _cooldown)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_consumable_w, button_consumable_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_consumable_a, button_consumable_d)
		item_menu_consumable_button_content.add_child(_button)
		item_menu_consumable_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	if(_equip_serializable_array.size()>0):
		#-------------------------------------------------------------------------------
		for _i in _equip_serializable_array.size():
			var _equip_button: Button = Create_EquipItem_Button(_equip_serializable_array[_i])
			var _all_button: Button = Create_EquipItem_Button(_equip_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _equip_select_1: Callable = func():button_equip_select_1(_equip_serializable_array[_i])
			var _equip_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_equip_button, _equip_select_1, _equip_submit_1, button_equip_w, button_equip_s, button_equip_a, button_equip_d)
			item_menu_equip_button_content.add_child(_equip_button)
			item_menu_equip_button_array.append(_equip_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():button_all_equip_select_1(_equip_serializable_array[_i])
			var _all_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_equip_w, button_equip_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_equip_a, button_equip_d)
		item_menu_equip_button_content.add_child(_button)
		item_menu_equip_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	if(_key_serializable_array.size()>0):
		#-------------------------------------------------------------------------------
		for _i in _key_serializable_array.size():
			var _key_button: Button = Create_KeyItem_Button(_key_serializable_array[_i])
			var _all_button: Button = Create_KeyItem_Button(_key_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _key_select_1: Callable = func():button_key_select_1(_key_serializable_array[_i])
			var _key_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_key_button, _key_select_1, _key_submit_1, button_key_w, button_key_s, button_key_a, button_key_d)
			item_menu_key_button_content.add_child(_key_button)
			item_menu_key_button_array.append(_key_button)
			#-------------------------------------------------------------------------------
			var _all_select_1: Callable = func():button_all_key_select_1(_key_serializable_array[_i])
			var _all_submit_1: Callable = func():singleton.Common_Canceled()
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, button_key_w, button_key_s, button_all_a, button_all_d)
			item_menu_all_button_content.add_child(_all_button)
			item_menu_all_button_array.append(_all_button)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_key_a, button_key_d)
		item_menu_key_button_content.add_child(_button)
		item_menu_key_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	var _all_size:int = _consumable_serializable_array.size() + _equip_serializable_array.size() + _key_serializable_array.size()
	#-------------------------------------------------------------------------------
	if(_all_size <= 0):
		var _button: Button = Create_Empty_Button()
		#-------------------------------------------------------------------------------
		var _select_1: Callable = func():button_empty_select_1()
		var _submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_AD_Left_Right(_button, _select_1, _submit_1, button_all_a, button_all_d)
		item_menu_all_button_content.add_child(_button)
		item_menu_all_button_array.append(_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_all_button_array)
	#-------------------------------------------------------------------------------
	Show_All_Item_Button_0()
	Move_To_Item_Information_1(item_menu_consumable_information_root, item_menu_consumable_button_array.size())
	Move_To_Item_Button_List(item_menu_consumable_button_root, item_menu_consumable_button_0, item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Battle_Item_Menu_Consumable_Button_Sumbit(_button:Button, _user:Fighter_Node, _item_serializable:Action_Serializable, _hold:int, _cooldown:int):
	var _can: bool = Can_Use_This_Action(_item_serializable, _hold, _cooldown)
	#-------------------------------------------------------------------------------
	if(_can):
		BattleMenu_Item_Target_Set(_button, _user, _item_serializable)
	#-------------------------------------------------------------------------------
	else:
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Action_TP_Cost(_action_serializable:Action_Serializable) -> int:
	var _tp_cost: int = _action_serializable.action_resource.tp_cost
	return _tp_cost
#-------------------------------------------------------------------------------
func Battle_Item_Menu_Consumable_Button_Cancel():
	singleton.Destroy_Button_Array(item_menu_all_button_array)
	singleton.Destroy_Button_Array(item_menu_consumable_button_array)
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	singleton.Destroy_Button_Array(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	battle_menu.show()
	dialogue_menu.show()
	item_menu.hide()
	singleton.Move_to_Button_by_Cancel(battle_menu_button_item)
	main_canvas_layer.nothing_cancel = func():BattleMenu_Cancel()
#-------------------------------------------------------------------------------
func BattleMenu_Item_Target_Submit(_user:Fighter_Node, _item_serializable:Action_Serializable, _target:Fighter_Node):
	singleton.Destroy_Button_Array(item_menu_all_button_array)
	singleton.Destroy_Button_Array(item_menu_consumable_button_array)
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	singleton.Destroy_Button_Array(item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	await After_Target_Select_Actions(_user, _item_serializable, _target)
#-------------------------------------------------------------------------------
func BattleMenu_Item_Target_Cancel(_button:Button):
	var _tp: int = Get_Future_TP()
	Set_TP_Bar(_tp)
	item_menu.show()
	dialogue_menu.hide()
	Hide_All_Targets()
	main_canvas_layer.nothing_cancel = func():Battle_Item_Menu_Consumable_Button_Cancel()
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
#region BATTLE STATUS MENU
#-------------------------------------------------------------------------------
func Battle_Menu_Status_Button_Submit(_user:Fighter_Node):
	battle_menu.hide()
	var _cancel:Callable = func():Battle_Menu_Status_Target_Button_Cancel()
	var _selected:Callable = func():singleton.Common_Selected()
	main_canvas_layer.nothing_cancel = _cancel
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		var _button_root: Control = ally_party[_i].fighter_ui.button_root
		var _button: Button = ally_party[_i].fighter_ui.button
		var _submit:Callable = func():Battle_Menu_Status_Target_Button_Submit(ally_party[_i].fighter_serializable_in_battle, _button)
		singleton.Set_Button(_button, _selected, _submit)
		_button_root.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		var _button_root: Control = enemy_party[_i].fighter_ui.button_root
		var _button: Button = enemy_party[_i].fighter_ui.button
		var _submit:Callable = func():Battle_Menu_Status_Target_Button_Submit(enemy_party[_i].fighter_serializable_in_battle, _button)
		singleton.Set_Button(_button, _selected, _submit)
		_button_root.show()
	#-------------------------------------------------------------------------------
	Set_Target_Button_Navigation_2()
	singleton.Move_to_Button_by_Submit(_user.fighter_ui.button)
#-------------------------------------------------------------------------------
func Set_Target_Button_Navigation_2():
	var _button_array_1: Array[Button]
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		_button_array_1.append(ally_party[_i].fighter_ui.button)
	#-------------------------------------------------------------------------------
	var _button_array_2: Array[Button]
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		_button_array_2.append(enemy_party[_i].fighter_ui.button)
	#-------------------------------------------------------------------------------
	singleton.Twin_Button_Array_Set_Navigation(_button_array_1, _button_array_2)
#-------------------------------------------------------------------------------
func Set_Target_Button_Navigation_1(fighter_node_array:Array[Fighter_Node]):
	var _button_array_1: Array[Button]
	#-------------------------------------------------------------------------------
	for _i in fighter_node_array.size():
		_button_array_1.append(fighter_node_array[_i].fighter_ui.button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(_button_array_1)
#-------------------------------------------------------------------------------
func Battle_Menu_Status_Target_Button_Submit(_fighter_serializable:Fighter_Serializable, _button:Button):
	Hide_All_Targets()
	dialogue_menu.hide()
	status_menu.show()
	var _cancel:Callable = func():Battle_Menu_Status_Menu_Button_Cancel(_button)
	main_canvas_layer.nothing_cancel = _cancel
	Pause_Status_Menu_Set(_fighter_serializable, _cancel)
	status_menu_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Battle_Menu_Status_Target_Button_Cancel():
	battle_menu.show()
	Hide_All_Targets()
	main_canvas_layer.nothing_cancel = func():BattleMenu_Cancel()
	singleton.Move_to_Button_by_Cancel(battle_menu_button_status)
#-------------------------------------------------------------------------------
func Battle_Menu_Status_Menu_Button_Cancel(_button:Button):
	singleton.Destroy_Button_Array(status_menu_button_array)
	status_menu.hide()
	dialogue_menu.show()
	Show_All_Targets()
	main_canvas_layer.nothing_cancel = func():Battle_Menu_Status_Target_Button_Cancel()
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region BATTLE STATISTICS MENU
#-------------------------------------------------------------------------------
func Battle_Menu_Statistics_Button_Submit(_user:Fighter_Node):
	battle_menu.hide()
	var _cancel:Callable = func():Battle_Menu_Statistics_Target_Button_Cancel()
	var _selected:Callable = func():singleton.Common_Selected()
	main_canvas_layer.nothing_cancel = _cancel
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		var _button_root: Control = ally_party[_i].fighter_ui.button_root
		var _button: Button = ally_party[_i].fighter_ui.button
		var _submit:Callable = func():Battle_Menu_Statistics_Target_Button_Submit(ally_party[_i], ally_party[_i].fighter_serializable_in_battle, _button)
		singleton.Set_Button(_button, _selected, _submit)
		_button_root.show()
	#-------------------------------------------------------------------------------
	for _i in enemy_party.size():
		var _button_root: Control = enemy_party[_i].fighter_ui.button_root
		var _button: Button = enemy_party[_i].fighter_ui.button
		var _submit:Callable = func():Battle_Menu_Statistics_Target_Button_Submit(enemy_party[_i], enemy_party[_i].fighter_serializable_in_battle, _button)
		singleton.Set_Button(_button, _selected, _submit)
		_button_root.show()
	#-------------------------------------------------------------------------------
	Set_Target_Button_Navigation_2()
	singleton.Move_to_Button_by_Submit(_user.fighter_ui.button)
#-------------------------------------------------------------------------------
func Battle_Menu_Statistics_Target_Button_Submit(_fighter_node:Fighter_Node, _fighter_serializable:Fighter_Serializable, _button:Button):
	Hide_All_Targets()
	dialogue_menu.hide()
	statistics_menu.show()
	var _cancel:Callable = func():Battle_Menu_Statistics_Menu_Button_Cancel(_button)
	main_canvas_layer.nothing_cancel = _cancel
	Pause_Statistics_Menu_Set(_fighter_node, _fighter_serializable, _cancel)
	statistics_menu_information_root.get_v_scroll_bar().value = 0
	singleton.Move_to_Button_by_Submit(statistics_menu_button_0)
#-------------------------------------------------------------------------------
func Battle_Menu_Statistics_Target_Button_Cancel():
	battle_menu.show()
	Hide_All_Targets()
	main_canvas_layer.nothing_cancel = func():BattleMenu_Cancel()
	singleton.Move_to_Button_by_Cancel(battle_menu_button_statistics)
#-------------------------------------------------------------------------------
func Battle_Menu_Statistics_Menu_Button_Cancel(_button:Button):
	statistics_menu.hide()
	dialogue_menu.show()
	Show_All_Targets()
	main_canvas_layer.nothing_cancel = func():Battle_Menu_Statistics_Target_Button_Cancel()
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MISC FUNCTIONS
#-------------------------------------------------------------------------------
func Seconds(_timer:float):
	await get_tree().create_timer(_timer, true, true).timeout
#-------------------------------------------------------------------------------
func Set_Fighter_0():
	ally_party[0].show()
	ally_party[0].reparent(player_characterbody2d)
	ally_party[0].position = Vector2.ZERO
	#-------------------------------------------------------------------------------
	for _i in range(1, ally_party.size()):
		ally_party[_i].show()
		ally_party[_i].reparent(world_2d)
		#ally_party[_i].global_position = player_characterbody2d.global_position
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Ally_Fighter_Resource_Array() -> Array[Fighter_Resource]:
	var _fighter_resource_array: Array[Fighter_Resource]
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		_fighter_resource_array.append(ally_party[_i].fighter_serializable.fighter_resource)
	#-------------------------------------------------------------------------------
	return _fighter_resource_array
#-------------------------------------------------------------------------------
func Get_Fighter_Node_Index(_fighter_resource:Fighter_Resource) -> int:
	#-------------------------------------------------------------------------------
	for _i in ally_party.size():
		#-------------------------------------------------------------------------------
		if(ally_party[_i].fighter_serializable.fighter_resource == _fighter_resource):
			return _i
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return -1
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Fade_Out_Override():
	var _tween: Tween = create_tween()
	var _color_black: Color = Color.BLACK
	_tween.tween_property(black_screen_override, "self_modulate",_color_black, 0.2)
	await _tween.finished
#-------------------------------------------------------------------------------
func Fade_In_Override():
	var _tween: Tween = create_tween()
	var _color_transparte: Color = Color.TRANSPARENT
	_tween.tween_property(black_screen_override, "self_modulate",_color_transparte, 0.2)
	await _tween.finished
#-------------------------------------------------------------------------------
func Get_Position_in_Canvas_Layer(_global_position:Vector2) -> Vector2:
	var _new_position: Vector2 = _global_position - camera.global_position
	_new_position *= camera.zoom
	_new_position += Vector2(width, height)/2
	#-------------------------------------------------------------------------------
	return _new_position
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func Set_Lock_On_Position(_fighter_node:Fighter_Node):
	lock_on.global_position = _fighter_node.character_node.global_position
	lock_on.global_position.y -= 20
#-------------------------------------------------------------------------------
func Re_Open_Battle_Menu():
	#-------------------------------------------------------------------------------
	if(myBATTLE_STATE != BATTLE_STATE.STILL_FIGHTING):
		return
	#-------------------------------------------------------------------------------
	battle_menu.show()
	singleton.Move_to_Button_by_Submit(battle_menu_button_skill)
	await next_signal
#-------------------------------------------------------------------------------
#region FIGHTERS/INVENTORY MANAGEMENT WHEN ENTER/EXIT BATTLE
#-------------------------------------------------------------------------------
func Get_Key_Item_Inventory() -> Array[Key_Serializable]:
	var _key_serializable_array: Array[Key_Serializable]
	#-------------------------------------------------------------------------------
	_key_serializable_array.append_array(item_key_inventory)
	#-------------------------------------------------------------------------------
	if(money_inventory.stored > 0):
		_key_serializable_array.append(money_inventory)
	#-------------------------------------------------------------------------------
	return _key_serializable_array
#-------------------------------------------------------------------------------
func Get_Key_Item_Inventory_in_Battle() -> Array[Key_Serializable]:
	var _key_serializable_array: Array[Key_Serializable]
	#-------------------------------------------------------------------------------
	_key_serializable_array.append_array(item_key_inventory_in_battle)
	#-------------------------------------------------------------------------------
	if(money_inventory_in_battle.stored > 0):
		_key_serializable_array.append(money_inventory_in_battle)
	#-------------------------------------------------------------------------------
	return _key_serializable_array
#-------------------------------------------------------------------------------
func Get_Status_Serializable_Array(_fighter_serializable:Fighter_Serializable) -> Array[Status_Serializable]:
	var _status_serializable_array: Array[Status_Serializable]
	#-------------------------------------------------------------------------------
	_status_serializable_array.append_array(_fighter_serializable.status_serializable_array)
	#-------------------------------------------------------------------------------
	if(_fighter_serializable.hp <= 0):
		var _death_serializable: Status_Serializable = Create_Status_Serializable(death_status_resource, 0)
		_status_serializable_array.append(_death_serializable)
	#-------------------------------------------------------------------------------
	return _status_serializable_array
#-------------------------------------------------------------------------------
func Set_Inventory_When_Enter_Battle():
	item_consumable_inventory_in_battle.clear()
	#-------------------------------------------------------------------------------
	for _i in item_consumable_inventory.size():
		var _item_serializable_new: Action_Serializable = Duplicate_Consumable_Serializable(item_consumable_inventory[_i])
		item_consumable_inventory_in_battle.append(_item_serializable_new)
	#-------------------------------------------------------------------------------
	item_equip_inventory_in_battle.clear()
	#-------------------------------------------------------------------------------
	for _i in item_equip_inventory.size():
		var _equip_serializable_new: Equip_Serializable = Duplicate_Equip_Serializable(item_equip_inventory[_i])
		item_equip_inventory_in_battle.append(_equip_serializable_new)
	#-------------------------------------------------------------------------------
	item_key_inventory_in_battle.clear()
	#-------------------------------------------------------------------------------
	for _i in item_key_inventory.size():
		var _key_serializable_new: Key_Serializable = Duplicate_Key_Serializable(item_key_inventory[_i])
		item_key_inventory_in_battle.append(_key_serializable_new)
	#-------------------------------------------------------------------------------
	money_inventory_in_battle = Duplicate_Key_Serializable(money_inventory)
#-------------------------------------------------------------------------------
func Set_Inventory_When_Exit_Battle():
	item_consumable_inventory.clear()
	#-------------------------------------------------------------------------------
	for _i in item_consumable_inventory_in_battle.size():
		var _item_serializable_new: Action_Serializable = Duplicate_Consumable_Serializable(item_consumable_inventory_in_battle[_i])
		item_consumable_inventory.append(_item_serializable_new)
	#-------------------------------------------------------------------------------
	item_equip_inventory.clear()
	#-------------------------------------------------------------------------------
	for _i in item_equip_inventory_in_battle.size():
		var _equip_serializable_new: Equip_Serializable = Duplicate_Equip_Serializable(item_equip_inventory_in_battle[_i])
		item_equip_inventory.append(_equip_serializable_new)
	#-------------------------------------------------------------------------------
	item_key_inventory.clear()
	#-------------------------------------------------------------------------------
	for _i in item_key_inventory_in_battle.size():
		var _key_serializable_new: Key_Serializable = Duplicate_Key_Serializable(item_key_inventory_in_battle[_i])
		item_key_inventory_in_battle.append(_key_serializable_new)
	#-------------------------------------------------------------------------------
	money_inventory = Duplicate_Key_Serializable(money_inventory_in_battle)
#-------------------------------------------------------------------------------

func Remove_Zero_Consumable_Item_in_Hold_and_Stored():
	var _item_serializable_array: Array[Action_Serializable] = item_consumable_inventory_in_battle
	#-------------------------------------------------------------------------------
	for _i in range(_item_serializable_array.size()-1,-1,-1):
		#-------------------------------------------------------------------------------
		if(_item_serializable_array[_i].hold <= 0 and _item_serializable_array[_i].stored <= 0):
			_item_serializable_array.remove_at(_i)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CONSTRUCTOR FUNCTIONS
#-------------------------------------------------------------------------------
func Duplicate_Fighter_Serializable(_fighter_serializable:Fighter_Serializable) -> Fighter_Serializable:
	var _fighter_serialziable_new: Fighter_Serializable = Fighter_Serializable.new()
	#-------------------------------------------------------------------------------
	_fighter_serialziable_new.fighter_resource = _fighter_serializable.fighter_resource
	_fighter_serialziable_new.hp = _fighter_serializable.hp
	_fighter_serialziable_new.level = _fighter_serializable.level
	_fighter_serialziable_new.experience = _fighter_serializable.experience
	#-------------------------------------------------------------------------------
	_fighter_serialziable_new.equip_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		var _equip_serializable_new: Equip_Serializable = Duplicate_Equip_Serializable(_fighter_serializable.equip_serializable_array[_i])
		_fighter_serialziable_new.equip_serializable_array.append(_equip_serializable_new)
	#-------------------------------------------------------------------------------
	_fighter_serialziable_new.status_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		var _status_serializable_new: Status_Serializable = Duplicate_Status_Serializable(_fighter_serializable.status_serializable_array[_i])
		_fighter_serialziable_new.status_serializable_array.append(_status_serializable_new)
	#-------------------------------------------------------------------------------
	return _fighter_serialziable_new
#-------------------------------------------------------------------------------
func Create_Consumable_Serializable(_item_resource:Action_Resource) -> Action_Serializable:
	var _item_serializable_new: Action_Serializable = Action_Serializable.new()
	#-------------------------------------------------------------------------------
	_item_serializable_new.action_resource = _item_resource
	_item_serializable_new.hold = 0
	_item_serializable_new.stored = 0
	#-------------------------------------------------------------------------------
	return _item_serializable_new
#-------------------------------------------------------------------------------
func Duplicate_Consumable_Serializable(_item_serializable_old:Action_Serializable) -> Action_Serializable:
	var _item_serializable_new: Action_Serializable = Action_Serializable.new()
	#-------------------------------------------------------------------------------
	_item_serializable_new.action_resource = _item_serializable_old.action_resource
	_item_serializable_new.hold = _item_serializable_old.hold
	_item_serializable_new.stored = _item_serializable_old.stored
	#-------------------------------------------------------------------------------
	return _item_serializable_new
#-------------------------------------------------------------------------------
func Create_Equip_Serializable(_equip_resource: Equip_Resource, _stored:int) -> Equip_Serializable:
	var _equip_serializable_new: Equip_Serializable = Equip_Serializable.new()
	#-------------------------------------------------------------------------------
	_equip_serializable_new.equip_resource = _equip_resource
	_equip_serializable_new.myEQUIP_TYPE = _equip_resource.myEQUIP_TYPE
	_equip_serializable_new.stored = _stored
	#-------------------------------------------------------------------------------
	_equip_serializable_new.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in _equip_resource.skill_resource_array.size():
		var _skill_serializable: Action_Serializable = Create_Skill_Serializable(_equip_resource.skill_resource_array[_i])
		_equip_serializable_new.skill_serializable_array.append(_skill_serializable)
	#-------------------------------------------------------------------------------
	return _equip_serializable_new
#-------------------------------------------------------------------------------
func Duplicate_Equip_Serializable(_equip_serializable_old: Equip_Serializable) -> Equip_Serializable:
	var _equip_serializable_new: Equip_Serializable = Equip_Serializable.new()
	#-------------------------------------------------------------------------------
	_equip_serializable_new.equip_resource = _equip_serializable_old.equip_resource
	_equip_serializable_new.myEQUIP_TYPE = _equip_serializable_old.myEQUIP_TYPE
	_equip_serializable_new.stored = _equip_serializable_old.stored
	#-------------------------------------------------------------------------------
	return _equip_serializable_new
#-------------------------------------------------------------------------------
func Create_Key_Serializable(_key_resource:Key_Resource, _stored:int) -> Key_Serializable:
	var _key_serializable_new: Key_Serializable = Key_Serializable.new()
	#-------------------------------------------------------------------------------
	_key_serializable_new.key_resource = _key_resource
	_key_serializable_new.stored = _stored
	#-------------------------------------------------------------------------------
	return _key_serializable_new
#-------------------------------------------------------------------------------
func Duplicate_Key_Serializable(_key_serializable_old:Key_Serializable) -> Key_Serializable:
	var _key_serializable_new: Key_Serializable = Key_Serializable.new()
	#-------------------------------------------------------------------------------
	_key_serializable_new.key_resource = _key_serializable_old.key_resource
	_key_serializable_new.stored = _key_serializable_old.stored
	#-------------------------------------------------------------------------------
	return _key_serializable_new
#-------------------------------------------------------------------------------
func Duplicate_Status_Serializable(_status_serializable_old:Status_Serializable) -> Status_Serializable:
	var _status_serializable_new: Status_Serializable = Status_Serializable.new()
	#-------------------------------------------------------------------------------
	_status_serializable_new.status_resource = _status_serializable_old.status_resource
	_status_serializable_new.turns = _status_serializable_old.turns
	#-------------------------------------------------------------------------------
	return _status_serializable_new
#-------------------------------------------------------------------------------
func Create_Status_Serializable(_status_resource:Status_Resource, _turns:int) -> Status_Serializable:
	var _status_serializable_new: Status_Serializable = Status_Serializable.new()
	#-------------------------------------------------------------------------------
	_status_serializable_new.status_resource = _status_resource
	_status_serializable_new.turns = _turns
	#-------------------------------------------------------------------------------
	_status_serializable_new.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in _status_resource.skill_resource_array.size():
		var _skill_serializable: Action_Serializable = Create_Skill_Serializable(_status_resource.skill_resource_array[_i])
		_status_serializable_new.skill_serializable_array.append(_skill_serializable)
	#-------------------------------------------------------------------------------
	return _status_serializable_new
#-------------------------------------------------------------------------------
func Create_Skill_Serializable(_skill_resource:Action_Resource) -> Action_Serializable:
	var _skill_serializable_new: Action_Serializable = Action_Serializable.new()
	#-------------------------------------------------------------------------------
	_skill_serializable_new.action_resource = _skill_resource
	_skill_serializable_new.hold = _skill_resource.max_hold
	_skill_serializable_new.stored = _skill_resource.max_stored
	_skill_serializable_new.cooldown = 0
	#-------------------------------------------------------------------------------
	return _skill_serializable_new
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TIMER PROTOTYPES
#-------------------------------------------------------------------------------
func Start_Timer_Tween(_timer:int):
	max_timer_value = _timer
	timer_value = _timer
	#-------------------------------------------------------------------------------
	timer_root.show()
	Set_Timer(timer_value, max_timer_value)
	#-------------------------------------------------------------------------------
	Create_Timer_Tween()
	#-------------------------------------------------------------------------------
	await next_signal
#-------------------------------------------------------------------------------
func Create_Timer_Tween():
	timer_tween = create_tween()
	timer_tween.set_loops()
	timer_tween.tween_interval(1.0)
	#-------------------------------------------------------------------------------
	timer_tween.tween_callback(func():
		timer_value -= 1
		#-------------------------------------------------------------------------------
		if(timer_value < 0):
			Stop_Timer_Tween()
		#-------------------------------------------------------------------------------
		else:
			Set_Timer(timer_value, max_timer_value)
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Stop_Timer_Tween():
	timer_root.hide()
	timer_tween.kill()
	#Acá pongo que mato todas las balas y sus tweens.
	next_signal.emit()
#-------------------------------------------------------------------------------
func Set_Timer(_timer:int, _max_timer:int):
	timer_label.text = str(_timer)+"s"+" / "+str(_max_timer)+"s"
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func Hitbox_Movement():
	var _run_flag: bool = Input.is_action_pressed("Input_Run")
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#-------------------------------------------------------------------------------
	if(abs(input_dir.x) < dead_zone):
		input_dir.x = 0
	#-------------------------------------------------------------------------------
	if(abs(input_dir.y) < dead_zone):
		input_dir.y = 0
	#-------------------------------------------------------------------------------
	if(input_dir != Vector2.ZERO):
		input_dir_normal = input_dir.normalized()
		var myPosition: Vector2 = hitbox_root.position
		#-------------------------------------------------------------------------------
		if(_run_flag):
			myPosition += input_dir_normal * 3 * deltaTimeScale
		#-------------------------------------------------------------------------------
		else:
			myPosition += input_dir_normal * 9 * deltaTimeScale
		#-------------------------------------------------------------------------------
		myPosition.y = clampf(myPosition.y, battle_box_limit_up, battle_box_limit_down)
		myPosition.x = clampf(myPosition.x, battle_box_limit_left, battle_box_limit_right)
		hitbox_root.position = myPosition
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Battle_Box_Limits():
	var _offset: float = 16
	battle_box_limit_up = _offset
	battle_box_limit_down = battle_box.size.y - _offset
	battle_box_limit_left = _offset
	battle_box_limit_right = battle_box.size.x - _offset
#-------------------------------------------------------------------------------
func Set_TP_Bar(_tp:int):
	tp_bar_slider.value = _tp
	var _max_tp: int = Get_Max_Tp()
	tp_bar_slider.max_value = _max_tp
	tp_bar_value.text = str(_tp)
	tp_bar_max_value.text = str(_max_tp)
#-------------------------------------------------------------------------------
func Get_Max_Tp() -> int:
	return 100
#-------------------------------------------------------------------------------
func Get_Future_TP() -> int:
	var _tp: int = tp
	var _max_tp: int = Get_Max_Tp()
	_tp = clampi(_tp, 0, _max_tp)
	#-------------------------------------------------------------------------------
	var _alive_party: Array[Fighter_Node] = Get_Alive_Fighter_Party_in_Battle(ally_party)
	#-------------------------------------------------------------------------------
	for _i in current_fighter_turn:
		_tp -= Get_Action_TP_Cost(_alive_party[_i].action_serializable)
	#-------------------------------------------------------------------------------
	return _tp
#-------------------------------------------------------------------------------
func Get_Future_Hold(_action_serializable:Action_Serializable) -> int:
	var _hold: int = _action_serializable.hold
	#-------------------------------------------------------------------------------
	for _j in current_fighter_turn:
		#-------------------------------------------------------------------------------
		if(_action_serializable.action_resource == ally_party[_j].action_serializable.action_resource):
			_hold -= 1
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _hold
#-------------------------------------------------------------------------------
func Get_Future_Cooldown(_action_serializable:Action_Serializable) -> int:
	var _cooldown: int = _action_serializable.cooldown
	#-------------------------------------------------------------------------------
	for _j in current_fighter_turn:
		#-------------------------------------------------------------------------------
		if(_action_serializable.action_resource == ally_party[_j].action_serializable.action_resource):
			_cooldown = _action_serializable.action_resource.max_cooldown
			return _cooldown
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _cooldown
#-------------------------------------------------------------------------------
func Get_Tr_Action_Name(_action_resource:Action_Resource) -> String:
	return tr("name_"+singleton.get_resource_filename(_action_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Skill_Name(_skill_resource:Action_Resource) -> String:
	return tr("name_"+singleton.get_resource_filename(_skill_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Skill_Description(_skill_resource:Action_Resource) -> String:
	return tr("description_"+singleton.get_resource_filename(_skill_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Consumable_Item_Name(_item_resource:Action_Resource) -> String:
	return tr("name_"+singleton.get_resource_filename(_item_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Consumable_Item_Description(_item_resource:Action_Resource) -> String:
	return tr("description_"+singleton.get_resource_filename(_item_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Equip_Item_Name(_equip_resource:Equip_Resource) -> String:
	return tr("name_"+singleton.get_resource_filename(_equip_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Equip_Null_Name() -> String:
	return tr("equip_null")
#-------------------------------------------------------------------------------
func Get_Tr_Equip_Item_Description(_equip_resource:Equip_Resource) -> String:
	return tr("description_"+singleton.get_resource_filename(_equip_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Key_Item_Name(_key_resource:Key_Resource) -> String:
	return tr("name_"+singleton.get_resource_filename(_key_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Key_Item_Description(_key_resource:Key_Resource) -> String:
	return tr("description_"+singleton.get_resource_filename(_key_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Status_Effect_Name_1(_status_resource:Status_Resource) -> String:
	return Get_Tr_Status_Effect_Name_0(singleton.get_resource_filename(_status_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Status_Effect_Name_0(_key:StringName) -> String:
	return tr("name_"+_key)
#-------------------------------------------------------------------------------
func Get_Tr_Status_Effect_Description(_status_resource:Status_Resource) -> String:
	return tr("description_"+singleton.get_resource_filename(_status_resource))
#-------------------------------------------------------------------------------
func Get_Tr_Character_Name(_character:Character_Resource) -> String:
	return tr("name_"+singleton.get_resource_filename(_character))
#-------------------------------------------------------------------------------
func Get_Tr_Character_Title(_character:Character_Resource) -> String:
	return tr("title_"+singleton.get_resource_filename(_character))
#-------------------------------------------------------------------------------
func Get_Tr_Character_Description(_character:Character_Resource) -> String:
	return tr("description_"+singleton.get_resource_filename(_character))
#-------------------------------------------------------------------------------
func Get_Tr_Element(_element_type:Action_Resource.ELEMENT) -> String:
	var _element_key: StringName = Action_Resource.ELEMENT.keys()[_element_type]
	return tr("element_"+_element_key)
#-------------------------------------------------------------------------------
func Get_Tr_Action_Effect(_effect:Action_Resource.EFFECT) -> String:
	var _effect_key: StringName = Action_Resource.EFFECT.keys()[_effect]
	return tr("action_type_"+_effect_key)
#-------------------------------------------------------------------------------
func Get_Tr_Tp() -> String:
	return tr("tp_text")
#-------------------------------------------------------------------------------
func Get_Tr_CD() -> String:
	return tr("cd_text")
#-------------------------------------------------------------------------------
func Get_Tr_Equip_Type(myEQUIP_TYPE:Equip_Resource.EQUIP_TYPE) -> String:
	var _key: String = Equip_Resource.EQUIP_TYPE.keys()[myEQUIP_TYPE]
	var _s: String = tr("equip_type_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_Tr_Fighter_Class_Type(_myFIGHTER_CLASS:Fighter_Resource.FIGHTER_CLASS) -> String:
	var _key: StringName = Fighter_Resource.FIGHTER_CLASS.keys()[_myFIGHTER_CLASS]
	var _s: String = tr("fighter_type_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_Tr_Action_Atribute_Name(_myATRIBUTE:Action_Resource.ATRIBUTE) -> String:
	var _key: String = Action_Resource.ATRIBUTE.keys()[_myATRIBUTE]
	var _s: String = tr("atribute_type_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_Tr_Action_Target_Name(_myTARGET:Action_Resource.TARGET) -> String:
	var _key: String = Action_Resource.TARGET.keys()[_myTARGET]
	var _s: String = tr("target_type_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_Tr_TP_Cost_Text(_tp:int) -> String:
	return "("+str(_tp)+"-"+Get_Tr_Tp()+")"
#-------------------------------------------------------------------------------
func Get_Tr_CD_Text(_cd:int) -> String:
	return "("+str(_cd)+"-"+Get_Tr_CD()+")"
#-------------------------------------------------------------------------------
func Get_Fighter_Hp_Text(_hp:int, _max_hp:int) -> String:
	var _s: String = str(_hp)+" / "+str(_max_hp)+" "+Get_Tr_Tp()
	return _s
#-------------------------------------------------------------------------------
func Flying_PopUp_HP(_user:Fighter_Node, _value:int):
	var _s:String = Get_Number_with_Sign(_value) + " HP"
	await Flying_PopUp(_user, _s)
#-------------------------------------------------------------------------------
func Flying_PopUp(_user:Fighter_Node, _s:String):
	var _is_enemy:bool
	#-------------------------------------------------------------------------------
	if(ally_party.has(_user)):
		_is_enemy = false
	#-------------------------------------------------------------------------------
	else:
		_is_enemy = true
	#-------------------------------------------------------------------------------
	var _popup: Pop_Up_Node = Spawn_Label_in_User(_user, _is_enemy)
	await Flying_PopUp_Actions(_popup, _s, _is_enemy)
#-------------------------------------------------------------------------------
func Spawn_Label_in_User(_user:Fighter_Node, _is_enemy:bool) -> Pop_Up_Node:
	#-------------------------------------------------------------------------------
	for _i in _user.pop_up_array.size():
		#-------------------------------------------------------------------------------
		if(_user.pop_up_array[_i] == null):
			var _popup: Pop_Up_Node = Spawn_Label_in_User_2(_user, _is_enemy, _i)
			_user.pop_up_array[_i] = _popup
			return _popup
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _popup_2: Pop_Up_Node = Spawn_Label_in_User_2(_user, _is_enemy, _user.pop_up_array.size())
	_user.pop_up_array.append(_popup_2)
	return _popup_2
#-------------------------------------------------------------------------------
func Spawn_Label_in_User_2(_user:Fighter_Node, _is_enemy:bool, _index:int) -> Pop_Up_Node:
	var _popup: Pop_Up_Node
	#-------------------------------------------------------------------------------
	if(_is_enemy):
		_popup = enemy_pop_up_prefab.instantiate() as Pop_Up_Node
	#-------------------------------------------------------------------------------
	else:
		_popup = ally_pop_up_prefab.instantiate() as Pop_Up_Node
	#-------------------------------------------------------------------------------
	var _global_position: Vector2 = _user.character_node.global_position
	_popup.label.add_theme_font_size_override("font_size", 24)
	_global_position.y -= 6.0 * camera.zoom.y * float(_index)
	_popup.scale = Vector2.ONE/ camera.zoom
	_user.add_child(_popup)
	_popup.global_position = _global_position
	return _popup
#-------------------------------------------------------------------------------
func Flying_PopUp_Actions(_popup:Pop_Up_Node, _s:String, _is_enemy:bool):
	#-------------------------------------------------------------------------------
	_popup.scale = Vector2.ONE /camera.zoom
	_popup.label.text = _s
	_popup.z_index = 10
	#-------------------------------------------------------------------------------
	var _x_pos: float
	#-------------------------------------------------------------------------------
	if(_is_enemy):
		_x_pos = -35
	#-------------------------------------------------------------------------------
	else:
		_x_pos = 35
	#-------------------------------------------------------------------------------
	var _tween: Tween = create_tween()
	_tween.tween_property(_popup, "position", _popup.position + Vector2(_x_pos, -15), 0.12)
	_tween.tween_property(_popup, "position", _popup.position + Vector2(_x_pos, 0), 0.12)
	_tween.tween_property(_popup, "position", _popup.position + Vector2(_x_pos, -5), 0.12)
	_tween.tween_property(_popup, "position", _popup.position + Vector2(_x_pos, 0), 0.12)
	_tween.tween_interval(0.7)
	#-------------------------------------------------------------------------------
	_tween.tween_callback(func():
		_popup.queue_free()
	)
	#-------------------------------------------------------------------------------
	await _tween.finished
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
