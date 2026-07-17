extends Node
class_name Game_System
#-------------------------------------------------------------------------------
enum GAME_STATE{IN_WORLD, IN_MENU, IN_BATTLE}
enum BATTLE_STATE{STILL_FIGHTING, YOU_WIN, YOU_LOSE, YOU_ESCAPE, YOU_RETRY}
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
var key_dictionary: Dictionary[String, int]
#-------------------------------------------------------------------------------
@export var world_2d: Node2D
@export var battle_box: Control
@export var battle_ui: Control
@export var black_screen_override: Panel
#-------------------------------------------------------------------------------
@export_category("Prefabs & Resources")
@export var attack_resource: Action_Resource
@export var guard_resource: Action_Resource
@export var fighter_button_prefab: PackedScene
@export var fighter_ally_ui_prefab: PackedScene
@export var fighter_enemy_ui_prefab: PackedScene
#-------------------------------------------------------------------------------
@export_category("Serializables")
@export var money_serializable: Key_Serializable
#-------------------------------------------------------------------------------
@export_category("Inventory")
@export var item_consumable_serializable_array: Array[Action_Serializable]
@export var item_equip_serializable_array: Array[Equip_Serializable]
@export var item_key_serializable_array: Array[Key_Serializable]
#-------------------------------------------------------------------------------
var myGAME_STATE: GAME_STATE = GAME_STATE.IN_WORLD
var myBATTLE_STATE: BATTLE_STATE = BATTLE_STATE.STILL_FIGHTING
#-------------------------------------------------------------------------------
@export_category("Player")
@export var ally_node_array: Array[Fighter_Node]
var ally_button_array: Array[Fighter_Button]
@export var enemy_node_array: Array[Fighter_Node]
@export var player_characterbody2d: CharacterBody2D
@export var player_interactable_by_action_area2d: Area2D
@export var player_interactable_by_action_collider: CollisionShape2D
var isSlowMotion: bool = false
var deltaTimeScale: float = 1.0
var input_dir: Vector2
var input_dir_normal: Vector2
var dead_zone: float = 0.001
const state_machine_layer_1: String = "base"
#-------------------------------------------------------------------------------
const damage_scaling: int = 100
const armor_scaling: int = 100
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
@export var tp_bar_name: Label
#-------------------------------------------------------------------------------
@export_category("Battle Menu")
@export var battle_background: Control
@export var battle_menu: Control
@export var battle_menu_skills_button: Button
@export var battle_menu_items_button: Button
@export var battle_menu_statistics_button: Button
@export var battle_menu_status_button: Button
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
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MONOVEHAVIOUR
#-------------------------------------------------------------------------------
func _enter_tree() -> void:
	singleton.game_system = self
#-------------------------------------------------------------------------------
func _ready() -> void:
	Pause_Off()
	#-------------------------------------------------------------------------------
	black_screen_override.show()
	battle_box.hide()
	black_screen_override.self_modulate = Color.TRANSPARENT
	Set_Camera_Parameters()
	Set_Room(current_room)
	camera.global_position = Camera_Set_Target_Position()
	#-------------------------------------------------------------------------------
	battle_background.hide()
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
	Animation_StateMachine(ally_node_array[0].character_node.animation_tree, state_machine_layer_1, "Idle")
#-------------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	#-------------------------------------------------------------------------------
	match(myGAME_STATE):
		GAME_STATE.IN_WORLD:
			Camera_Follow()
			#-------------------------------------------------------------------------------
			if(is_in_dialogue):
				return
			#-------------------------------------------------------------------------------
			if(!get_tree().paused):
				if(Input.is_action_just_pressed("Input_Pause")):
					PauseMenu_Open()
					return
				#-------------------------------------------------------------------------------
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
			pass
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
	if(ally_node_array[0].character_node.is_moving):
		#-------------------------------------------------------------------------------
		if(input_dir == Vector2.ZERO):
			Animation_StateMachine(ally_node_array[0].character_node.animation_tree, state_machine_layer_1, "Idle")
			ally_node_array[0].character_node.is_moving = false
			input_dir_normal = Vector2.ZERO
			return
		#-------------------------------------------------------------------------------
		else:
			input_dir_normal = input_dir.normalized()
			#-------------------------------------------------------------------------------
			if(ally_node_array[0].character_node.is_running):
				var _new_velocity: Vector2 = input_dir_normal * 200.0 * deltaTimeScale
				player_characterbody2d.velocity = _new_velocity
				#-------------------------------------------------------------------------------
				if(!_run_flag):
					Animation_StateMachine(ally_node_array[0].character_node.animation_tree, state_machine_layer_1, "Walk")
					ally_node_array[0].character_node.is_running = false
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				var _new_velocity: Vector2 = input_dir_normal * 70.0 * deltaTimeScale
				player_characterbody2d.velocity = _new_velocity
				#-------------------------------------------------------------------------------
				if(_run_flag):
					Animation_StateMachine(ally_node_array[0].character_node.animation_tree, state_machine_layer_1, "Run")
					ally_node_array[0].character_node.is_running = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			if(ally_node_array[0].character_node.is_facing_left):
				if(input_dir_normal.x > 0):
					Face_Left(ally_node_array[0].character_node, false)
					return
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				if(input_dir_normal.x < 0):
					Face_Left(ally_node_array[0].character_node, true)
					return
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		Set_Fighter_Position_History(ally_node_array[0])
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		if(input_dir != Vector2.ZERO):
			#-------------------------------------------------------------------------------
			if(_run_flag):
				Animation_StateMachine(ally_node_array[0].character_node.animation_tree, state_machine_layer_1, "Run")
				ally_node_array[0].character_node.is_running = true
			#-------------------------------------------------------------------------------
			else:
				Animation_StateMachine(ally_node_array[0].character_node.animation_tree, state_machine_layer_1, "Walk")
				ally_node_array[0].character_node.is_running = false
			#-------------------------------------------------------------------------------
			ally_node_array[0].character_node.is_moving = true
			#-------------------------------------------------------------------------------
			if(input_dir.x > 0):
				Face_Left(ally_node_array[0].character_node, false)
			#-------------------------------------------------------------------------------
			elif(input_dir.x < 0):
				Face_Left(ally_node_array[0].character_node, true)
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
	for _i in range(1, ally_node_array.size()):
		var _distance: float = 20
		#-------------------------------------------------------------------------------
		if(ally_node_array[_i].global_position.distance_to(ally_node_array[_i-1].global_position) > _distance):
			var _x: float = ally_node_array[_i].global_position.x - ally_node_array[_i-1].global_position.x
			var _y: float = ally_node_array[_i].global_position.y - ally_node_array[_i-1].global_position.y
			var _dir: float = atan2(_y, _x)
			var _x2: float = _distance * cos(_dir)
			var _y2: float = _distance * sin(_dir)
			var _new_position: Vector2 = ally_node_array[_i-1].global_position + Vector2(_x2, _y2)
			#-------------------------------------------------------------------------------
			if(ally_node_array[_i].character_node.is_moving):
				ally_node_array[_i].global_position = lerp(ally_node_array[_i].global_position, _new_position, 0.1*deltaTimeScale)
				#-------------------------------------------------------------------------------
				if(ally_node_array[_i].global_position.distance_to(_new_position) < 5):
					Animation_StateMachine(ally_node_array[_i].character_node.animation_tree, state_machine_layer_1, "Idle")
					ally_node_array[_i].character_node.is_moving = false
				#-------------------------------------------------------------------------------
				else:
					if(ally_node_array[_i].character_node.is_running):
						#-------------------------------------------------------------------------------
						if(!_run_flag):
							Animation_StateMachine(ally_node_array[_i].character_node.animation_tree, state_machine_layer_1, "Walk")
							ally_node_array[_i].character_node.is_running = false
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
					else:
						#-------------------------------------------------------------------------------
						if(_run_flag):
							Animation_StateMachine(ally_node_array[_i].character_node.animation_tree, state_machine_layer_1, "Run")
							ally_node_array[_i].character_node.is_running = true
						#-------------------------------------------------------------------------------
					#-------------------------------------------------------------------------------
					Set_Fighter_Position_History(ally_node_array[_i])
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				#-------------------------------------------------------------------------------
				if(ally_node_array[_i].global_position.distance_to(_new_position) > 10):
					#-------------------------------------------------------------------------------
					if(_run_flag):
						Animation_StateMachine(ally_node_array[_i].character_node.animation_tree, state_machine_layer_1, "Run")
						ally_node_array[_i].character_node.is_running = true
					#-------------------------------------------------------------------------------
					else:
						Animation_StateMachine(ally_node_array[_i].character_node.animation_tree, state_machine_layer_1, "Walk")
						ally_node_array[_i].character_node.is_running = false
					#-------------------------------------------------------------------------------
					ally_node_array[_i].character_node.is_moving = true
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		if(ally_node_array[_i].character_node.is_facing_left):
			#-------------------------------------------------------------------------------
			if(ally_node_array[_i].global_position < ally_node_array[_i-1].global_position):
				Face_Left(ally_node_array[_i].character_node, false)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		else:
			#-------------------------------------------------------------------------------
			if(ally_node_array[_i].global_position > ally_node_array[_i-1].global_position):
				Face_Left(ally_node_array[_i].character_node, true)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func Set_Camera_Parameters():
	viewport_size = Vector2(width, height)
	viewport_center = viewport_size/2.0
	camera_size = viewport_size / camera.zoom
	camera_center = viewport_center / camera.zoom
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Camera_Follow():
	var _new_position: Vector2 = Camera_Set_Target_Position()
	camera.global_position = lerp(camera.global_position, _new_position, 0.2)
#-------------------------------------------------------------------------------
func Camera_Set_Target_Position() -> Vector2:
	var _new_position: Vector2 = ally_node_array[0].global_position + Vector2(0, -camera_offset_y)
	#-------------------------------------------------------------------------------
	_new_position.x = clampf(_new_position.x, current_room.limit_left, current_room.limit_right)
	_new_position.y = clampf(_new_position.y, current_room.limit_top, current_room.limit_botton)
	#-------------------------------------------------------------------------------
	return _new_position
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
#region GO-TO-TITLE MENU
#-------------------------------------------------------------------------------
func Set_Go_to_Title_Menu():
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit_yes: Callable = func():Set_Go_to_Title_Menu_Yes_Button_Submit()
	var _submit_no: Callable = func():Set_Go_to_Title_Menu_No_Button_Submit()
	var _cancel: Callable = func():Set_Go_to_Title_Menu_Button_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(go_to_title_menu_button_yes, _selected, _submit_yes, _cancel)
	singleton.Set_Button(go_to_title_menu_button_no, _selected, _submit_no, _cancel)
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
	Pause_Off()
	get_tree().change_scene_to_file("res://Nodes/Scenes/title_scene.tscn")
#-------------------------------------------------------------------------------
func Set_Go_to_Title_Menu_No_Button_Submit():
	go_to_title_menu.hide()
	singleton.Move_to_Button_by_Submit(pause_menu_button_quit)
#-------------------------------------------------------------------------------
func Set_Go_to_Title_Menu_Button_Cancel():
	go_to_title_menu.hide()
	singleton.Move_to_Button_by_Cancel(pause_menu_button_quit)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE MENU
#-------------------------------------------------------------------------------
func Pause_On():
	get_tree().set_deferred("paused", true)
#-------------------------------------------------------------------------------
func Pause_Off():
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
	#-------------------------------------------------------------------------------
	var _button_array: Array[Button]
	#-------------------------------------------------------------------------------
	for _i in ally_node_array.size():
		var _party_button: Fighter_Button = Create_Fighter_Button(ally_node_array[_i])
		_party_button.custom_minimum_size.y = 170.0
		pause_menu_fighter_button_content.add_child(_party_button)
		ally_button_array.append(_party_button)
		_button_array.append(_party_button as Button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(_button_array)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(pause_menu_button_skill)
	singleton.Common_Submited()
	#-------------------------------------------------------------------------------
	Pause_On()
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
	Pause_Off()
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
	_fighter_button.hp_label.text = Get_Fighter_Hp_Text(_max_hp, _max_hp)
	_fighter_button.hp_bar.max_value = _max_hp
	_fighter_button.hp_bar.value = _max_hp
#-------------------------------------------------------------------------------
func Pause_Menu_Set():
	var _selected: Callable = func(): singleton.Common_Selected()
	#-------------------------------------------------------------------------------
	var _skill_submit: Callable = func(): Pause_Menu_Skill_Button_Submit()
	var _item_submit: Callable = func(): Pause_Menu_Item_Button_Submit()
	var _equip_submit: Callable = func(): Pause_Menu_Equip_Button_Submit()
	var _statistics_submit: Callable = func(): Pause_Menu_Statistics_Button_Submit()
	var _status_submit: Callable = func(): Pause_Menu_Status_Button_Submit()
	var _options_submit: Callable = func(): PauseMenu_OptionButton_Submit()
	var _quit_submit: Callable = func(): PauseMenu_QuitButton_Submit()
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func(): PauseMenu_AnyButton_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(pause_menu_button_skill, _selected, _skill_submit, _cancel)
	singleton.Set_Button(pause_menu_button_item, _selected, _item_submit, _cancel)
	singleton.Set_Button(pause_menu_button_equip, _selected, _equip_submit, _cancel)
	singleton.Set_Button(pause_menu_button_statistics, _selected, _statistics_submit, _cancel)
	singleton.Set_Button(pause_menu_button_status, _selected, _status_submit, _cancel)
	singleton.Set_Button(pause_menu_button_options, _selected, _options_submit, _cancel)
	singleton.Set_Button(pause_menu_button_quit, _selected, _quit_submit, _cancel)
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
	#-------------------------------------------------------------------------------
	pause_menu_button_mouse_blocker.show()
	pause_menu_fighter_button_mouse_blocker.hide()
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): Pause_Menu_Skill_Fighter_Button_Submit(_i)
		var _cancel: Callable = func(): Pause_Menu_Skill_Fighter_Button_Cancel()
		#-------------------------------------------------------------------------------
		singleton.Set_Button(ally_button_array[_i], _selected, _submit, _cancel)
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
	Enable_Item_Button_0(pause_menu_button_skill)
	singleton.Move_to_Button_by_Cancel(pause_menu_button_skill)
#-------------------------------------------------------------------------------
func Pause_Menu_Item_Button_Submit():
	Pause_Item_Menu_Set()
	pause_menu.hide()
	item_menu.show()
#-------------------------------------------------------------------------------
func Pause_Menu_Equip_Button_Submit():
	#-------------------------------------------------------------------------------
	pause_menu_button_mouse_blocker.show()
	pause_menu_fighter_button_mouse_blocker.hide()
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): Pause_Menu_Equip_Fighter_Button_Submit(_i)
		var _cancel: Callable = func(): Pause_Menu_Equip_Fighter_Button_Cancel()
		#-------------------------------------------------------------------------------
		singleton.Set_Button(ally_button_array[_i], _selected, _submit, _cancel)
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
	Enable_Item_Button_0(pause_menu_button_equip)
	singleton.Move_to_Button_by_Cancel(pause_menu_button_equip)
#-------------------------------------------------------------------------------
func Pause_Menu_Statistics_Button_Submit():
	#-------------------------------------------------------------------------------
	pause_menu_button_mouse_blocker.show()
	pause_menu_fighter_button_mouse_blocker.hide()
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): Pause_Menu_Statistics_Fighter_Button_Submit(_i)
		var _cancel: Callable = func(): Pause_Menu_Statistics_Fighter_Button_Cancel()
		#-------------------------------------------------------------------------------
		singleton.Set_Button(ally_button_array[_i], _selected, _submit, _cancel)
	#-------------------------------------------------------------------------------
	Disable_Item_Button_0(pause_menu_button_statistics)
	singleton.Move_to_Button_by_Submit(ally_button_array[0])
#-------------------------------------------------------------------------------
func Pause_Menu_Statistics_Fighter_Button_Submit(_fighter_index:int):
	pause_menu.hide()
	statistics_menu.show()
	singleton.Move_to_Button_by_Submit(statistics_menu_button_0)
	Pause_Statistics_Menu_Set(_fighter_index)
	statistics_menu_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Pause_Menu_Statistics_Fighter_Button_Cancel():
	pause_menu_button_mouse_blocker.hide()
	pause_menu_fighter_button_mouse_blocker.show()
	#-------------------------------------------------------------------------------
	Enable_Item_Button_0(pause_menu_button_statistics)
	singleton.Move_to_Button_by_Cancel(pause_menu_button_statistics)
#-------------------------------------------------------------------------------
func Pause_Menu_Status_Button_Submit():
	#-------------------------------------------------------------------------------
	pause_menu_button_mouse_blocker.show()
	pause_menu_fighter_button_mouse_blocker.hide()
	#-------------------------------------------------------------------------------
	for _i in ally_button_array.size():
		var _selected: Callable = func(): singleton.Common_Selected()
		var _submit: Callable = func(): Pause_Menu_Status_Fighter_Button_Submit(_i)
		var _cancel: Callable = func(): Pause_Menu_Status_Fighter_Button_Cancel()
		#-------------------------------------------------------------------------------
		singleton.Set_Button(ally_button_array[_i], _selected, _submit, _cancel)
	#-------------------------------------------------------------------------------
	Disable_Item_Button_0(pause_menu_button_status)
	singleton.Move_to_Button_by_Submit(ally_button_array[0])
#-------------------------------------------------------------------------------
func Pause_Menu_Status_Fighter_Button_Submit(_fighter_index:int):
	pause_menu.hide()
	status_menu.show()
	Pause_Status_Menu_Set(_fighter_index)
	status_menu_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Pause_Menu_Status_Fighter_Button_Cancel():
	pause_menu_button_mouse_blocker.hide()
	pause_menu_fighter_button_mouse_blocker.show()
	#-------------------------------------------------------------------------------
	Enable_Item_Button_0(pause_menu_button_status)
	singleton.Move_to_Button_by_Cancel(pause_menu_button_status)
#-------------------------------------------------------------------------------
func PauseMenu_QuitButton_Submit():
	go_to_title_menu.show()
	Set_Go_to_Title_Menu()
	singleton.Move_to_Button_by_Submit(go_to_title_menu_button_no)
#-------------------------------------------------------------------------------
func PauseMenu_AnyButton_Cancel():
	singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	await get_tree().physics_frame
	PauseMenu_Close()
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-SKILL MENU
#-------------------------------------------------------------------------------
func Pause_Skill_Menu_Set(_fighter_index:int):
	var _fighter_serializable: Fighter_Serializable = ally_node_array[_fighter_index].fighter_serializable
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
			var _cancel: Callable = func(): Pause_Skill_Menu_Main_Button_Cancel(_fighter_index)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WS(_button, _selected, _submit, _cancel, _w, _s)
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
		var _submit: Callable = func(): pass
		var _cancel: Callable = func(): Pause_Skill_Menu_Main_Button_Cancel(_fighter_index)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(skill_menu_button_0, _selected, _submit, _cancel)
		#-------------------------------------------------------------------------------
		Enable_Item_Button_0(skill_menu_button_0)
		skill_menu_information_root.hide()
		singleton.Button_Remove_Navigation(skill_menu_button_0)
		singleton.Move_to_Button_by_Submit(skill_menu_button_0)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Pause_Skill_Menu_Skill_Button_Selected(_action_serializable:Action_Serializable):
	Set_Skill_Information(_action_serializable)
	singleton.Common_Selected()
#-------------------------------------------------------------------------------
func Create_Skill_Button(_skill_serializable:Action_Serializable):
	#-------------------------------------------------------------------------------
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	var _name: String = tr("name_"+singleton.get_resource_filename(_skill_serializable.action_resource))
	_button.text = "  "+_name+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
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
		_label2.text = Get_CD_Text(_skill_serializable.cooldown)+"  "
	#-------------------------------------------------------------------------------
	_button.add_child(_label2)
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
func Pause_Skill_Menu_Main_Button_Cancel(_fighter_index:int):
	pause_menu.show()
	skill_menu.hide()
	singleton.Destroy_Button_Array(skill_menu_button_array)
	singleton.Move_to_Button_by_Cancel(ally_button_array[_fighter_index])
#-------------------------------------------------------------------------------
func Set_Skill_Information(_action_serializable:Action_Serializable):
	var _hold_text: String = Get_Hold_Text_A(_action_serializable)
	var _tp_cost_text: String = Get_TpCost_Text_A(_action_serializable.action_resource)
	var _cooldown_text: String = Get_CoolDown_Text(_action_serializable)
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
	skill_menu_information_description_value.text = tr("description_"+singleton.get_resource_filename(_action_serializable.action_resource))
	skill_menu_information_description_value.text += Blablabla()
	skill_menu_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Get_Skill_Effect_Text(_action_resource:Action_Resource) -> String:
	var _s: String = ""
	#-------------------------------------------------------------------------------
	match(_action_resource.myEFFECT):
		Action_Resource.EFFECT.DAMAGE:
			_s += str(_action_resource.value)+" ("
			_s += tr("action_type_DAMAGE") + " / "
			_s += Get_Action_Atribute_Name(_action_resource.myATRIBUTE) + " / "
			_s += Get_Action_Element_Name(_action_resource.myELEMENT)+")"
		#-------------------------------------------------------------------------------
		Action_Resource.EFFECT.HEAL:
			_s += str(_action_resource.value)+"% ("
			_s += tr("action_type_HEAL") + ")"
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _s
#-------------------------------------------------------------------------------
func Get_Target_Text(_action_resource:Action_Resource) -> String:
	var _s: String = ""
	#-------------------------------------------------------------------------------
	_s += Get_Action_Target_Name(_action_resource.myTARGET) + " "
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
			_label_name.text += "* "+tr("name_"+_action_resource.status_dictionary.keys()[_i])+"\n"
			_label_rate.text += str(_action_resource.status_dictionary.values()[_i])+"%"+"\n"
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
		_tp_cost_text = Get_TP_Cost_Text(_tp_cost)
	#-------------------------------------------------------------------------------
	return _tp_cost_text
#-------------------------------------------------------------------------------
func Get_TpCost_Text_B(_action_resource:Action_Resource) -> String:
	var _tp_cost_text: String = ""
	var _tp_cost: int = _action_resource.tp_cost
	#-------------------------------------------------------------------------------
	if(_tp_cost > 0):
		_tp_cost_text = Get_TP_Cost_Text(_tp_cost)
	#-------------------------------------------------------------------------------
	return _tp_cost_text
#-------------------------------------------------------------------------------
func Get_CoolDown_Text(_action_serializable:Action_Serializable) -> String:
	var _cooldown_text: String
	var _cooldown: int = _action_serializable.action_resource.max_cooldown
	#-------------------------------------------------------------------------------
	if(_cooldown>0):
		_cooldown_text = Get_CD_Text(_cooldown)
	#-------------------------------------------------------------------------------
	else:
		_cooldown_text = "-"
	#-------------------------------------------------------------------------------
	return _cooldown_text
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-ITEM MENU
#-------------------------------------------------------------------------------
func Pause_Item_Menu_Set():
	#-------------------------------------------------------------------------------
	var _all_a: Callable = func():
		Move_To_Item_Information_1(item_menu_key_information_root, item_menu_key_button_array.size())
		Move_To_Item_Button_List(item_menu_key_button_root, item_menu_key_button_0, item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	var _consumable_a: Callable = func():
		Move_To_Item_Button_List(item_menu_all_button_root, item_menu_all_button_0, item_menu_all_button_array)
	#-------------------------------------------------------------------------------
	var _equip_a: Callable = func():
		Move_To_Item_Information_1(item_menu_consumable_information_root, item_menu_consumable_button_array.size())
		Move_To_Item_Button_List(item_menu_consumable_button_root, item_menu_consumable_button_0, item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	var _key_a: Callable = func():
		Move_To_Item_Information_1(item_menu_equip_information_root, item_menu_equip_button_array.size())
		Move_To_Item_Button_List(item_menu_equip_button_root, item_menu_equip_button_0, item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	var _all_d: Callable = func():
		Move_To_Item_Information_1(item_menu_consumable_information_root, item_menu_consumable_button_array.size())
		Move_To_Item_Button_List(item_menu_consumable_button_root, item_menu_consumable_button_0, item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	var _consumable_d: Callable = func():
		Move_To_Item_Information_1(item_menu_equip_information_root, item_menu_equip_button_array.size())
		Move_To_Item_Button_List(item_menu_equip_button_root, item_menu_equip_button_0, item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	var _equip_d: Callable = func():
		Move_To_Item_Information_1(item_menu_key_information_root, item_menu_key_button_array.size())
		Move_To_Item_Button_List(item_menu_key_button_root, item_menu_key_button_0, item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	var _key_d: Callable = func():
		Move_To_Item_Button_List(item_menu_all_button_root, item_menu_all_button_0, item_menu_all_button_array)
	#-------------------------------------------------------------------------------
	var _all_selected_0: Callable = func():
		Enable_All_Item_Button_0()
		Hide_All_Item_Menues()
		item_menu_all_button_root.show()
		#-------------------------------------------------------------------------------
		if(item_menu_all_button_array.size() > 0):
			Disable_Item_Button_0(item_menu_all_button_0)
			singleton.Move_to_Button(item_menu_all_button_array[0])
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _consumable_selected_0: Callable = func():
		Enable_All_Item_Button_0()
		Hide_All_Item_Menues()
		Hide_All_Item_Information_Root()
		item_menu_consumable_button_root.show()
		#-------------------------------------------------------------------------------
		if(item_menu_consumable_button_array.size() > 0):
			item_menu_consumable_information_root.show()
			Disable_Item_Button_0(item_menu_consumable_button_0)
			singleton.Move_to_Button(item_menu_consumable_button_array[0])
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_selected_0: Callable = func():
		Enable_All_Item_Button_0()
		Hide_All_Item_Menues()
		Hide_All_Item_Information_Root()
		item_menu_equip_button_root.show()
		#-------------------------------------------------------------------------------
		if(item_menu_equip_button_array.size() > 0):
			item_menu_equip_information_root.show()
			Disable_Item_Button_0(item_menu_equip_button_0)
			singleton.Move_to_Button(item_menu_equip_button_array[0])
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _key_selected_0: Callable = func():
		Enable_All_Item_Button_0()
		Hide_All_Item_Menues()
		Hide_All_Item_Information_Root()
		item_menu_key_button_root.show()
		#-------------------------------------------------------------------------------
		if(item_menu_key_button_array.size() > 0):
			item_menu_key_information_root.show()
			Disable_Item_Button_0(item_menu_key_button_0)
			singleton.Move_to_Button(item_menu_key_button_array[0])
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _submit_0: Callable = func():singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():Pause_Item_Menu_Main_Button_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_AD_Left_Right(item_menu_all_button_0, _all_selected_0, _submit_0, _cancel, _all_a, _all_d)
	singleton.Set_Button_AD_Left_Right(item_menu_consumable_button_0, _consumable_selected_0, _submit_0, _cancel, _consumable_a, _consumable_d)
	singleton.Set_Button_AD_Left_Right(item_menu_equip_button_0, _equip_selected_0, _submit_0, _cancel, _equip_a, _equip_d)
	singleton.Set_Button_AD_Left_Right(item_menu_key_button_0, _key_selected_0, _submit_0, _cancel, _key_a, _key_d)
	#-------------------------------------------------------------------------------
	var _consumable_serializable_array: Array[Action_Serializable] = item_consumable_serializable_array
	var _equip_serializable_array: Array[Equip_Serializable] = item_equip_serializable_array
	var _key_serializable_array: Array[Key_Serializable] = item_key_serializable_array
	Sort_Action_by_ID(_consumable_serializable_array)
	Sort_Equip_by_ID(_equip_serializable_array)
	Sort_Key_by_ID(_key_serializable_array)
	#-------------------------------------------------------------------------------
	for _i in _consumable_serializable_array.size():
		var _hold: int = _consumable_serializable_array[_i].hold
		var _cooldown: int = 0
		#-------------------------------------------------------------------------------
		var _consumable_button: Button = Create_ConsumableItem_Button(_consumable_serializable_array[_i], _hold, _cooldown)
		#-------------------------------------------------------------------------------
		var _consumable_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_consumable_information_root)
		#-------------------------------------------------------------------------------
		var _consumable_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_consumable_information_root)
		#-------------------------------------------------------------------------------
		var _consumable_select_1: Callable = func():
			Set_Item_Consumable_Information(_consumable_serializable_array[_i])
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
		var _consumable_submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_consumable_button, _consumable_select_1, _consumable_submit_1, _cancel, _consumable_w, _consumable_s, _consumable_a, _consumable_d)
		item_menu_consumable_button_content.add_child(_consumable_button)
		item_menu_consumable_button_array.append(_consumable_button)
		#-------------------------------------------------------------------------------
		var _all_button: Button = Create_ConsumableItem_Button(_consumable_serializable_array[_i], _hold, _cooldown)
		#-------------------------------------------------------------------------------
		var _all_select_1: Callable = func():
			Set_Item_Consumable_Information(_consumable_serializable_array[_i])
			singleton.Common_Selected()
			Move_To_Item_Information_0(item_menu_consumable_information_root)
		#-------------------------------------------------------------------------------
		var _all_submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, _cancel, _consumable_w, _consumable_s, _all_a, _all_d)
		item_menu_all_button_content.add_child(_all_button)
		item_menu_all_button_array.append(_all_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	for _i in _equip_serializable_array.size():
		var _equip_button: Button = Create_EquipItem_Button(_equip_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _equip_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_equip_information_root)
		#-------------------------------------------------------------------------------
		var _equip_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_equip_information_root)
		#-------------------------------------------------------------------------------
		var _equip_select_1: Callable = func():
			Set_Item_Equip_Information(_equip_serializable_array[_i])
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
		var _equip_submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_equip_button, _equip_select_1, _equip_submit_1, _cancel, _equip_w, _equip_s, _equip_a, _equip_d)
		item_menu_equip_button_content.add_child(_equip_button)
		item_menu_equip_button_array.append(_equip_button)
		#-------------------------------------------------------------------------------
		var _all_button: Button = Create_EquipItem_Button(_equip_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _all_select_1: Callable = func():
			Set_Item_Equip_Information(_equip_serializable_array[_i])
			singleton.Common_Selected()
			Move_To_Item_Information_0(item_menu_equip_information_root)
		#-------------------------------------------------------------------------------
		var _all_submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, _cancel, _equip_w, _equip_s, _all_a, _all_d)
		item_menu_all_button_content.add_child(_all_button)
		item_menu_all_button_array.append(_all_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	for _i in _key_serializable_array.size():
		var _key_button: Button = Create_KeyItem_Button(_key_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _key_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_key_information_root)
		#-------------------------------------------------------------------------------
		var _key_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_key_information_root)
		#-------------------------------------------------------------------------------
		var _key_select_1: Callable = func():
			Set_Item_Key_Information(_key_serializable_array[_i])
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
		var _key_submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_key_button, _key_select_1, _key_submit_1, _cancel, _key_w, _key_s, _key_a, _key_d)
		item_menu_key_button_content.add_child(_key_button)
		item_menu_key_button_array.append(_key_button)
		#-------------------------------------------------------------------------------
		var _all_button: Button = Create_KeyItem_Button(_key_serializable_array[_i])
		#-------------------------------------------------------------------------------
		var _all_select_1: Callable = func():
			Set_Item_Key_Information(_key_serializable_array[_i])
			singleton.Common_Selected()
			Move_To_Item_Information_0(item_menu_key_information_root)
		#-------------------------------------------------------------------------------
		var _all_submit_1: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_all_button, _all_select_1, _all_submit_1, _cancel, _key_w, _key_s, _all_a, _all_d)
		item_menu_all_button_content.add_child(_all_button)
		item_menu_all_button_array.append(_all_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_key_button_array)
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
	if(_button_array.size() > 0):
		singleton.Move_to_Button(_button_array[0])
		Disable_Item_Button_0(_button_0)
	#-------------------------------------------------------------------------------
	else:
		singleton.Move_to_Button(_button_0)
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
	item_menu_consumable_information_description_value.text = tr("description_"+singleton.get_resource_filename(_action_serializable.action_resource))
	item_menu_consumable_information_description_value.text += Blablabla()
	item_menu_consumable_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Set_Item_Equip_Information(_equip_serializable:Equip_Serializable):
	var _equip_resource: Equip_Resource = _equip_serializable.equip_resource
	#-------------------------------------------------------------------------------
	item_menu_equip_information_level_value.text = Get_Level_Required(_equip_resource.level_required)
	item_menu_equip_information_stored_value.text = "["+str(_equip_serializable.stored)+"]"
	item_menu_equip_information_class_value.text = Get_Fighter_Class_Type(_equip_resource.myFIGHTER_CLASS)
	item_menu_equip_information_type_value.text = Get_Equip_Type(_equip_resource.myEQUIP_TYPE)
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
	item_menu_equip_information_description_value.text = tr("description_"+singleton.get_resource_filename(_equip_serializable.equip_resource))
	item_menu_equip_information_description_value.text += Blablabla()
	item_menu_equip_information_root.get_v_scroll_bar().value = 0
#-------------------------------------------------------------------------------
func Get_Equip_Stored_in_Inventory(_equip_serializable_array:Array[Equip_Serializable], _equip_resource:Equip_Resource) -> int:
	#-------------------------------------------------------------------------------
	for _i in _equip_serializable_array.size():
		if(_equip_serializable_array[_i].equip_resource == _equip_resource):
			return _equip_serializable_array[_i].stored
	#-------------------------------------------------------------------------------
	return 0
#-------------------------------------------------------------------------------
func Set_User_Equip_Information(_equip_serializable:Equip_Serializable):
	#-------------------------------------------------------------------------------
	if(_equip_serializable.equip_resource != null):
		var _equip_resource: Equip_Resource = _equip_serializable.equip_resource
		#-------------------------------------------------------------------------------
		equip_menu_information_level_value.text = Get_Level_Required(_equip_resource.level_required)
		var _stored: int = Get_Equip_Stored_in_Inventory(item_equip_serializable_array, _equip_resource)
		equip_menu_information_stored_value.text = "["+str(_stored)+"]"
		equip_menu_information_class_value.text = Get_Fighter_Class_Type(_equip_resource.myFIGHTER_CLASS)
		equip_menu_information_type_value.text = Get_Equip_Type(_equip_resource.myEQUIP_TYPE)
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
		equip_menu_information_description_value.text = tr("description_"+singleton.get_resource_filename(_equip_serializable.equip_resource))
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
		var _turns: int = clampi(_status_serializable.turns, 0, _status_resource.max_turns)
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
		status_menu_information_description_value.text = tr("description_"+singleton.get_resource_filename(_status_resource))
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
	var _element_name: String = Get_Action_Element_Name(_element_type)
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
		var _name: StringName = tr("name_"+_key)+" ("+tr("resistance_text")+")"
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
		_value_label.text += tr("name_"+singleton.get_resource_filename(_skill_resource_array[_i]))+"\n"
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
	item_menu_key_information_stored_value.text = "["+str(_key_serializable.stored)+"]"
	item_menu_key_information_description_value.text = tr("description_"+singleton.get_resource_filename(_key_serializable.key_resource))
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
	singleton.Move_to_Button_by_Cancel(pause_menu_button_item)
#-------------------------------------------------------------------------------
func Create_ConsumableItem_Button(_action_serializable: Action_Serializable, _hold:int, _cooldown:int) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = "  "+tr("name_"+singleton.get_resource_filename(_action_serializable.action_resource))+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: RichTextLabel = RichTextLabel.new()
	_label2.bbcode_enabled = true
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label2.mouse_filter = Control.MOUSE_FILTER_PASS
	_label2.text = ""
	#-------------------------------------------------------------------------------
	if(_cooldown <= 0 or _action_serializable.action_resource.max_cooldown <= 0):
		#-------------------------------------------------------------------------------
		if(_action_serializable.action_resource.tp_cost > 0):
			_label2.text += "[font_size=16]"+Get_TP_Cost_Text(_action_serializable.action_resource.tp_cost)+"  "+"[/font_size]"
		#-------------------------------------------------------------------------------
		var _max_hold: int = _action_serializable.action_resource.max_hold
		#-------------------------------------------------------------------------------
		if(_max_hold > 0):
			var _s: String = "[font_size=16]"+"[lb]"+str(_hold)+"/"+str(_max_hold)+"[rb]"+"  "+"[/font_size]"
			#-------------------------------------------------------------------------------
			if(_hold < _action_serializable.hold):
				_label2.text += "[color="+hex_color_yellow+"]"+_s+"[/color]"
			#-------------------------------------------------------------------------------
			else:
				_label2.text += _s
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _s: String = Get_CD_Text(_cooldown)+"  "
		#-------------------------------------------------------------------------------
		if(_cooldown > _action_serializable.cooldown):
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
	_button.text = "  "+tr("name_"+singleton.get_resource_filename(_equip_serializable.equip_resource))+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
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
	_button.text = "  "+tr("name_"+singleton.get_resource_filename(_key_serializable.key_resource))+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
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
	var _fighter_serializable: Fighter_Serializable = ally_node_array[_fighter_index].fighter_serializable
	var _equip_serializable_array: Array[Equip_Serializable] = _fighter_serializable.equip_serializable_array
	#-------------------------------------------------------------------------------
	if(_equip_serializable_array.size() >0):
		equip_menu_button_type.text = ""
		#-------------------------------------------------------------------------------
		for _i in _equip_serializable_array.size():
			var _button: Button = Create_EquipSlot_Button(_equip_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _w: Callable = func():
				#-------------------------------------------------------------------------------
				if(_equip_serializable_array[_i].equip_resource != null):
					singleton.ScrollContainer_Up(equip_menu_information_root)
				#-------------------------------------------------------------------------------
			var _s: Callable = func():
				#-------------------------------------------------------------------------------
				if(_equip_serializable_array[_i].equip_resource != null):
					singleton.ScrollContainer_Down(equip_menu_information_root)
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			var _selected_1: Callable = func():
				Set_User_Equip_Information(_equip_serializable_array[_i])
				singleton.Common_Selected()
			#-------------------------------------------------------------------------------
			var _submit_1: Callable = func():Pause_Equip_Menu_Equip_Slot_Submit(_fighter_index, _i)
			var _cancel_1: Callable = func():Pause_Equip_Menu_Main_Button_Cancel(_fighter_index)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WS(_button, _selected_1, _submit_1, _cancel_1, _w, _s)
			equip_menu_button_content.add_child(_button)
			equip_menu_button_array.append(_button)
			#-------------------------------------------------------------------------------
			equip_menu_button_type.text += "* "+Get_Equip_Type(_equip_serializable_array[_i].myEQUIP_TYPE)+":  "+"\n"
		#-------------------------------------------------------------------------------
		singleton.Button_Array_Set_Vertical_Navigation(equip_menu_button_array)
		Remove_Last_Letter(equip_menu_button_type)
		Disable_Item_Button_0(equip_menu_button_0)
		singleton.Move_to_Button_by_Submit(equip_menu_button_array[0])
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		var _selected: Callable = func():singleton.Common_Selected()
		var _submit: Callable = func():pass
		var _cancel: Callable = func():Pause_Equip_Menu_Main_Button_Cancel(_fighter_index)
		#-------------------------------------------------------------------------------
		singleton.Set_Button(equip_menu_button_0, _selected, _submit, _cancel)
		Enable_Item_Button_0(equip_menu_button_0)
		singleton.Move_to_Button_by_Submit(equip_menu_button_0)
	#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
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
	var _cancel_0: Callable = func():Pause_Equip_Menu_Equip_Slot_Equi_Item_Cancel(_equip_index)
	#-------------------------------------------------------------------------------
	singleton.Set_Button(_empty_button, _selected_0, _submit_0, _cancel_0)
	item_menu_equip_button_content.add_child(_empty_button)
	item_menu_equip_button_array.append(_empty_button)
	#-------------------------------------------------------------------------------
	var _current_Fighter: Fighter_Serializable = ally_node_array[_fighter_index].fighter_serializable
	var _current_equip_slot: Equip_Serializable = _current_Fighter.equip_serializable_array[_equip_index]
	#-------------------------------------------------------------------------------
	for _i in item_equip_serializable_array.size():
		if(Is_Weapon_Avalible_to_be_Equipable(item_equip_serializable_array[_i].equip_resource, _current_equip_slot, _current_Fighter.fighter_resource.myFIGHTER_CLASS)):
			var _button: Button = Create_EquipItem_Button(item_equip_serializable_array[_i])
			#-------------------------------------------------------------------------------
			var _w_1: Callable = func():singleton.ScrollContainer_Up(item_menu_equip_information_root)
			var _s_1: Callable = func():singleton.ScrollContainer_Down(item_menu_equip_information_root)
			#-------------------------------------------------------------------------------
			var _selected_1: Callable = func():
				Set_Item_Equip_Information(item_equip_serializable_array[_i])
				item_menu_equip_information_root.show()
				singleton.Common_Selected()
			#-------------------------------------------------------------------------------
			var _submit_1: Callable = func(): Pause_Equip_Menu_Equip_Slot_Equip_Item_Submit(_fighter_index, _equip_index, item_equip_serializable_array[_i])
			var _cancel_1: Callable = func(): Pause_Equip_Menu_Equip_Slot_Equi_Item_Cancel(_equip_index)
			#-------------------------------------------------------------------------------
			singleton.Set_Button_WS(_button, _selected_1, _submit_1, _cancel_1, _w_1, _s_1)
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
	var _equip_slot: Equip_Serializable = ally_node_array[_fighter_index].fighter_serializable.equip_serializable_array[_equip_index]
	#-------------------------------------------------------------------------------
	if(_equip_slot.equip_resource != null):
		Add_Equip_Item_To_Inventory(_equip_slot.equip_resource, 1)
	#-------------------------------------------------------------------------------
	Remove_Equip_Item_From_Inventory(_equip_serializable.equip_resource, 1)
	Equip_Item_to_Fighter(_fighter_index, _equip_index, _equip_serializable)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button_by_Equip(equip_menu_button_array[_equip_index])
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Equip_Slot_Equip_Empty_Submit(_fighter_index:int, _equip_index:int):
	item_menu.hide()
	equip_menu.show()
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	var _current_equip_slot: Equip_Serializable = ally_node_array[_fighter_index].fighter_serializable.equip_serializable_array[_equip_index]
	#-------------------------------------------------------------------------------
	if(_current_equip_slot.equip_resource != null):
		Add_Equip_Item_To_Inventory(_current_equip_slot.equip_resource, 1)
	#-------------------------------------------------------------------------------
	Unequip_Item_to_Fighter(_fighter_index, _equip_index)
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button_by_Unequip(equip_menu_button_array[_equip_index])
#-------------------------------------------------------------------------------
func Equip_Item_to_Fighter(_fighter_index:int, _equip_index:int, _equip_serializable:Equip_Serializable):
	var _equip_slot: Equip_Serializable = ally_node_array[_fighter_index].fighter_serializable.equip_serializable_array[_equip_index]
	_equip_slot.equip_resource = _equip_serializable.equip_resource
	_equip_slot.stored = 1
	equip_menu_button_array[_equip_index].text = "  "+tr("name_"+singleton.get_resource_filename(_equip_slot.equip_resource))+"  "
#-------------------------------------------------------------------------------
func Unequip_Item_to_Fighter(_fighter_index:int, _equip_index:int):
	var _equip_slot: Equip_Serializable = ally_node_array[_fighter_index].fighter_serializable.equip_serializable_array[_equip_index]
	_equip_slot.equip_resource = null
	_equip_slot.stored = 0
	equip_menu_button_array[_equip_index].text = "  ["+tr("equip_null")+"]  "
#-------------------------------------------------------------------------------
func Remove_Equip_Item_From_Inventory(_equip_resource:Equip_Resource, _remove:int):
	#-------------------------------------------------------------------------------
	for _i in item_equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(item_equip_serializable_array[_i].equip_resource == _equip_resource):
			item_equip_serializable_array[_i].stored -= _remove
			#-------------------------------------------------------------------------------
			if(item_equip_serializable_array[_i].stored <= 0):
				item_equip_serializable_array.remove_at(_i)
			#-------------------------------------------------------------------------------
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Add_Equip_Item_To_Inventory(_equip_resource:Equip_Resource, _add:int):
	#-------------------------------------------------------------------------------
	for _i in item_equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(item_equip_serializable_array[_i].equip_resource == _equip_resource):
			item_equip_serializable_array[_i].stored += _add
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
	_equip_serializable.equip_resource = _equip_resource
	_equip_serializable.myEQUIP_TYPE = _equip_resource.myEQUIP_TYPE
	_equip_serializable.stored = _add
	#-------------------------------------------------------------------------------
	item_equip_serializable_array.append(_equip_serializable)
	return
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Equip_Slot_Equi_Item_Cancel(_equip_index:int):
	item_menu.hide()
	equip_menu.show()
	singleton.Destroy_Button_Array(item_menu_equip_button_array)
	singleton.Move_to_Button_by_Cancel(equip_menu_button_array[_equip_index])
#-------------------------------------------------------------------------------
func Pause_Equip_Menu_Main_Button_Cancel(_fighter_index:int):
	singleton.Destroy_Button_Array(equip_menu_button_array)
	pause_menu.show()
	equip_menu.hide()
	Fighter_Button_Set_HP(ally_button_array[_fighter_index], ally_node_array[_fighter_index].fighter_serializable)
	var _button: Button = ally_button_array[_fighter_index] as Button
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
func Create_EquipEmpty_Button() -> Button:
	var _empty_button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_empty_button.text = "  ["+tr("equip_null")+"]  "
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
		_button.text = "  "+tr("name_"+singleton.get_resource_filename(_equip_serializable.equip_resource))+"  "
		_button.add_theme_font_size_override("font_size", button_array_font_size)
		_button.custom_minimum_size.y = button_array_minimum_size_y
		_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	return _button
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-STATISTICS MENU
#-------------------------------------------------------------------------------
func Pause_Statistics_Menu_Set(_fighter_index:int):
	#-------------------------------------------------------------------------------
	var _w: Callable = func(): singleton.ScrollContainer_Up(statistics_menu_information_root)
	var _s: Callable = func(): singleton.ScrollContainer_Down(statistics_menu_information_root)
	#-------------------------------------------------------------------------------
	var _selected: Callable = func():singleton.Common_Selected()
	var _submit: Callable = func():pass
	var _cancel: Callable = func():Pause_Statistics_Menu_Main_Button_Cancel(_fighter_index)
	#-------------------------------------------------------------------------------
	singleton.Set_Button_WS_Up_Down(statistics_menu_button_0, _selected, _submit, _cancel, _w, _s)
	#-------------------------------------------------------------------------------
	var _fighter_node: Fighter_Node = ally_node_array[_fighter_index]
	var _fighter_serializable: Fighter_Serializable = _fighter_node.fighter_serializable
	#-------------------------------------------------------------------------------
	statistics_menu_information_fighter_face.texture = _fighter_node.character_node.character_resource.face
	#-------------------------------------------------------------------------------
	var _fighter_id: String = singleton.get_resource_filename(_fighter_node.character_node.character_resource)
	statistics_menu_information_fighter_name.text = tr("name_"+_fighter_id)
	statistics_menu_information_fighter_title.text = tr("title_"+_fighter_id)
	#-------------------------------------------------------------------------------
	var _max_hp: int = Get_Max_HP(_fighter_serializable)
	statistics_menu_information_fighter_hp_value.text = Get_Fighter_Hp_Text(_max_hp, _max_hp)
	statistics_menu_information_fighter_hp_slider.max_value = _max_hp
	statistics_menu_information_fighter_hp_slider.value = _max_hp
	#-------------------------------------------------------------------------------
	statistics_menu_information_level_value.text = Get_Fighter_Class_Type(_fighter_serializable.fighter_resource.myFIGHTER_CLASS)+"\n"
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
	Set_Fighter_Description(_fighter_serializable.fighter_resource)
	#-------------------------------------------------------------------------------
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
		var _name: String = Get_Equip_Type(_equip_serializable_array[_i].myEQUIP_TYPE)
		var _value: String
		#-------------------------------------------------------------------------------
		if(_equip_serializable_array[_i].equip_resource != null): 
			_value = tr("name_"+singleton.get_resource_filename(_equip_serializable_array[_i].equip_resource))
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
func Set_Fighter_Skill_List(_fighter_serializable:Fighter_Serializable):
	Set_Skill(_fighter_serializable)
	var _skill_serializable_array: Array[Action_Serializable] = Get_Skill(_fighter_serializable)
	#-------------------------------------------------------------------------------
	statistics_menu_information_skill_name.text = ""
	#-------------------------------------------------------------------------------
	for _i in _skill_serializable_array.size():
		statistics_menu_information_skill_name.text += "* "+tr("name_"+singleton.get_resource_filename(_skill_serializable_array[_i].action_resource))+"\n"
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
			statistics_menu_information_status_name.text = "* "+tr("name_"+_dictionary.keys()[_i])+"\n"
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
	var _element_name: String = Action_Resource.ELEMENT.keys()[_element_type]
	statistics_menu_information_elemental_type_name.text += String_With_Asterisco_and_2_Points(tr("element_"+_element_name))+"\n"
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
func Set_Fighter_Description(_fighter_resource:Fighter_Resource):
	statistics_menu_information_description_value.text = tr("description_"+singleton.get_resource_filename(_fighter_resource))
	statistics_menu_information_description_value.text += Blablabla() 
#-------------------------------------------------------------------------------
func Pause_Statistics_Menu_Main_Button_Cancel(_fighter_index:int):
	pause_menu.show()
	statistics_menu.hide()
	var _button: Button = ally_button_array[_fighter_index] as Button
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region PAUSE-STATUS-EFFECT MENU
#-------------------------------------------------------------------------------
func Pause_Status_Menu_Set(_fighter_index:int):
	var _fighter_serializable: Fighter_Serializable = ally_node_array[_fighter_index].fighter_serializable
	var _status_serializable_array: Array[Status_Serializable] = _fighter_serializable.status_serializable_array
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():Pause_Status_Menu_Status_Button_Cancel(_fighter_index)
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
			singleton.Set_Button_WS(_button, _selected, _submit, _cancel, _w, _s)
			status_menu_button_content.add_child(_button)
			status_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		singleton.Button_Array_Set_Vertical_Navigation(status_menu_button_array)
		Disable_Item_Button_0(status_menu_button_0)
		singleton.Move_to_Button_by_Submit(status_menu_button_array[0])
		status_menu_information_root.show()
	#-------------------------------------------------------------------------------
	else:
		var _selected: Callable = func():
			pass
		#-------------------------------------------------------------------------------
		var _submit: Callable = func():singleton.Common_Canceled()
		#-------------------------------------------------------------------------------
		Enable_Item_Button_0(status_menu_button_0)
		singleton.Set_Button(status_menu_button_0, _selected, _submit, _cancel)
		singleton.Move_to_Button_by_Submit(status_menu_button_0)
		status_menu_information_root.hide()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Create_StatusEffect_Serializable_Button(_status_serializable: Status_Serializable) -> Button:
	var _button: Button = Button.new()
	#-------------------------------------------------------------------------------
	_button.text = "  "+tr("name_"+singleton.get_resource_filename(_status_serializable.status_resource))+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
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
func Pause_Status_Menu_Status_Button_Cancel(_fighter_index:int):
	singleton.Destroy_Button_Array(status_menu_button_array)
	status_menu.hide()
	pause_menu.show()
	var _button:Button = ally_button_array[_fighter_index] as Button
	singleton.Move_to_Button_by_Cancel(_button)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CONSTRUCTOR FUNCTIONS
#-------------------------------------------------------------------------------
func Set_Equip(_fighter_serializable: Fighter_Serializable):
	_fighter_serializable.equip_serializable_array.clear()
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.fighter_resource.equip_type_array.size():
		var _equip_serializable: Equip_Serializable = Equip_Serializable.new()
		Set_Equip_Serializable(_equip_serializable, _fighter_serializable.fighter_resource.equip_type_array[_i])
		_fighter_serializable.equip_serializable_array.append(_equip_serializable)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Equip_Serializable(_equip_serializable: Equip_Serializable, _equip_type:Equip_Resource.EQUIP_TYPE):
	_equip_serializable.myEQUIP_TYPE = _equip_type
#-------------------------------------------------------------------------------
func Set_Skill_Serializable(_skill_serializable: Action_Serializable, _skill_resource:Action_Resource):
	_skill_serializable.action_resource = _skill_resource
	_skill_serializable.hold = _skill_resource.max_hold
	_skill_serializable.stored = _skill_resource.max_stored
	_skill_serializable.cooldown = 0
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region INVENTORY FUNCTIONS
#-------------------------------------------------------------------------------
func Fill_the_ConsumableItems_Stored_from_Hold():
	#-------------------------------------------------------------------------------
	for _i in item_consumable_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(item_consumable_serializable_array[_i].hold > item_consumable_serializable_array[_i].action_resource.max_hold):
			var _extra: int = item_consumable_serializable_array[_i].hold - item_consumable_serializable_array[_i].action_resource.max_hold
			item_consumable_serializable_array[_i].hold = item_consumable_serializable_array[_i].action_resource.max_hold
			item_consumable_serializable_array[_i].stored += _extra
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
func Set_Skill(_fighter_serializable: Fighter_Serializable):
	#-------------------------------------------------------------------------------
	_fighter_serializable.skill_serializable_array.clear()
	#-------------------------------------------------------------------------------
	var _attack_serializable: Action_Serializable = Action_Serializable.new()
	Set_Skill_Serializable(_attack_serializable, attack_resource)
	_fighter_serializable.skill_serializable_array.append(_attack_serializable)
	#-------------------------------------------------------------------------------
	var _guard_serializable: Action_Serializable = Action_Serializable.new()
	Set_Skill_Serializable(_guard_serializable, guard_resource)
	_fighter_serializable.skill_serializable_array.append(_guard_serializable)
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.fighter_resource.skill_resource_array.size():
		var _skill_serializable: Action_Serializable = Action_Serializable.new()
		Set_Skill_Serializable(_skill_serializable, _fighter_serializable.fighter_resource.skill_resource_array[_i])
		_fighter_serializable.skill_serializable_array.append(_skill_serializable)
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.equip_serializable_array.size():
		var _equip_serializable: Equip_Serializable = _fighter_serializable.equip_serializable_array[_i]
		_equip_serializable.skill_serializable_array.clear()
		#-------------------------------------------------------------------------------
		if(_equip_serializable.equip_resource != null):
			#-------------------------------------------------------------------------------
			for _j in _equip_serializable.equip_resource.skill_resource_array.size():
				var _skill_serializable: Action_Serializable = Action_Serializable.new()
				Set_Skill_Serializable(_skill_serializable, _equip_serializable.equip_resource.skill_resource_array[_j])
				_equip_serializable.skill_serializable_array.append(_skill_serializable)
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _fighter_serializable.status_serializable_array.size():
		var _status_serializable: Status_Serializable = _fighter_serializable.status_serializable_array[_i]
		_status_serializable.skill_serializable_array.clear()
		#-------------------------------------------------------------------------------
		for _j in _status_serializable.status_resource.skill_resource_array.size():
			var _skill_serializable: Action_Serializable = Action_Serializable.new()
			Set_Skill_Serializable(_skill_serializable, _status_serializable.status_resource.skill_resource[_j])
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
func Get_Fighter_Elemental_Stats_Normal(_fighter_serializable:Fighter_Serializable):
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
func Get_Fighter_Elemental_Stats_Water(_fighter_serializable:Fighter_Serializable):
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
func Get_Fighter_Elemental_Stats_Fire(_fighter_serializable:Fighter_Serializable):
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
func Get_Fighter_Elemental_Stats_Earth(_fighter_serializable:Fighter_Serializable):
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
func Get_Fighter_Elemental_Stats_Wind(_fighter_serializable:Fighter_Serializable):
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
func Get_Fighter_Elemental_Stats_Ice(_fighter_serializable:Fighter_Serializable):
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
func Get_Fighter_Elemental_Stats_Thunder(_fighter_serializable:Fighter_Serializable):
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
func Get_Fighter_Elemental_Stats_Light(_fighter_serializable:Fighter_Serializable):
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
func Get_Fighter_Elemental_Stats_Dark(_fighter_serializable:Fighter_Serializable):
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
	singleton.Set_Button(singleton.option_menu.back, func():singleton.Common_Selected(), func():OptionMenu_BackButton_Subited(), func():OptionMenu_BackButton_Canceled())
	pause_menu.hide()
	tp_bar.hide()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(singleton.option_menu.back)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Subited() -> void:
	OptionMenu_BackButton_Common()
	singleton.Move_to_Button(pause_menu_button_options)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Canceled() -> void:
	OptionMenu_BackButton_Common()
	singleton.Move_to_Button(pause_menu_button_options)
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func OptionMenu_BackButton_Common() -> void:
	singleton.option_menu.Save_OptionSaveData_Json()
	singleton.option_menu.hide()
	Set_Idiome()
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
	tp_bar_name.text = tr("tp_text")
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
			Fighter_Button_Set_Information_and_Idiome(ally_button_array[_i], ally_node_array[_i].character_node.character_resource, ally_node_array[_i].fighter_serializable)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Fighter_Button_Set_Information_and_Idiome(_fighter_button:Fighter_Button, _character_resource:Character_Resource, _fighter_serializable:Fighter_Serializable):
	var _fighter_id: String = singleton.get_resource_filename(_character_resource)
	_fighter_button.name_label.text = tr("name_"+_fighter_id)
	_fighter_button.title_label.text = tr("title_"+_fighter_id)
	_fighter_button.class_label.text = "["+Get_Fighter_Class_Type(_fighter_serializable.fighter_resource.myFIGHTER_CLASS)+"]"
	_fighter_button.level_label.text = "[Level: "+str(_fighter_serializable.level)+"]"
	#-------------------------------------------------------------------------------
	_fighter_button.status_label.text = String_With_Asterisco_and_2_Points(tr("pause_menu_button_status"))+" "+str(_fighter_serializable.status_serializable_array.size())
#-------------------------------------------------------------------------------
func Get_Equip_Type(myEQUIP_TYPE:Equip_Resource.EQUIP_TYPE) -> String:
	var _key: String = Equip_Resource.EQUIP_TYPE.keys()[myEQUIP_TYPE]
	var _s: String = tr("equip_type_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_Fighter_Class_Type(_myFIGHTER_CLASS:Fighter_Resource.FIGHTER_CLASS) -> String:
	var _key: StringName = Fighter_Resource.FIGHTER_CLASS.keys()[_myFIGHTER_CLASS]
	var _s: String = tr("fighter_type_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_Action_Element_Name(_myELEMENT:Action_Resource.ELEMENT) -> String:
	var _key: String = Action_Resource.ELEMENT.keys()[_myELEMENT]
	var _s: String = tr("element_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_Action_Atribute_Name(_myATRIBUTE:Action_Resource.ATRIBUTE) -> String:
	var _key: String = Action_Resource.ATRIBUTE.keys()[_myATRIBUTE]
	var _s: String = tr("atribute_type_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_Action_Target_Name(_myTARGET:Action_Resource.TARGET) -> String:
	var _key: String = Action_Resource.TARGET.keys()[_myTARGET]
	var _s: String = tr("target_type_"+_key)
	return _s
#-------------------------------------------------------------------------------
func Get_TP_Cost_Text(_tp:int) -> String:
	return "("+str(_tp)+"-"+tr("tp_text")+")"
#-------------------------------------------------------------------------------
func Get_CD_Text(_cd:int) -> String:
	return "("+str(_cd)+"-"+"CD"+")"
#-------------------------------------------------------------------------------
func Get_Fighter_Hp_Text(_hp:int, _max_hp:int) -> String:
	var _s: String = str(_hp)+" / "+str(_max_hp)+" "+tr("hp_text")
	return _s
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TEXT FUNCTIONS
#-------------------------------------------------------------------------------
func Blablabla() -> String:
	var _s:String = ""
	#_s += "\n"
	#_s += "\n"
	#_s += "Bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	#_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	#_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	#_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	#_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	#_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	#_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	#_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
	#_s += "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla."
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
func Animation_StateMachine(_animation_tree:AnimationTree, _state_machine:String, _anim:String):
	var _playback: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/"+_state_machine+"_StateMachine/playback")
	_playback.call_deferred("travel", _anim)
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
	_s += "Joystick: " + str(input_dir)+"\n"
	_s += "Joystick Normal: " + str(input_dir_normal)+"\n"
	_s += "Grab Focus: " + str(get_viewport().gui_get_focus_owner())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Tweens: "+str(tween_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	_s += "Player: " + str(ally_node_array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	#_s += "Enemy: " + str(enemy_party.size())+"\n"
	_s += "-------------------------------------------------------\n"
	#_s += "Enemy Bullets Enabled: " + str(enemyBullets_Enabled_Array.size())+"\n"
	#_s += "Enemy Bullets Disabled: " + str(enemyBullets_Disabled_Array.size())+"\n"
	_s += "-------------------------------------------------------\n"
	debug_label.text = _s
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
	dialogue_menu_audio.stream = ally_node_array[0].character_node.character_resource.voice
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
	#dialogue_menu_name.text = "[lb]"+_name+"[rb]:"
	dialogue_menu_name.text = "[u]"+singleton.get_resource_filename(_character_resource)+":"+"[/u]"
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
func Stop_Moving():
	#-------------------------------------------------------------------------------
	for _i in ally_node_array.size():
		Animation_StateMachine(ally_node_array[_i].character_node.animation_tree, state_machine_layer_1, "Idle")
		ally_node_array[_i].character_node.is_moving = false
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Open_Dialogue_Options(_array_string:Array[String]):
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
			var _cancel: Callable = func():pass
			#-------------------------------------------------------------------------------
			singleton.Set_Button(_button, _selected, _submit, _cancel)
			dialogue_menu_button_content.add_child(_button)
			dialogue_menu_button_array.append(_button)
		#-------------------------------------------------------------------------------
		singleton.Move_to_Button(dialogue_menu_button_array[0])
		singleton.Button_Array_Set_Vertical_Navigation(dialogue_menu_button_array)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Close_Dialogue_Options():
	singleton.Destroy_Button_Array(dialogue_menu_button_array)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func SetMoney_Label():
	var _s: String = "  "+Get_Money_Label(money_serializable.stored)+"  "
	pause_menu_money_label.text = _s
	money_menu_label.text = _s
#-------------------------------------------------------------------------------
func Get_Money_Label(_value:int) -> String:
	return "$"+str(_value)
#-------------------------------------------------------------------------------
#region MARKET MENU
#-------------------------------------------------------------------------------
func Open_Market(_merchant_name:String, _consumableitem_array:Array[Action_Serializable], _equipitem_array:Array[Equip_Serializable], _keyitem_array:Array[Key_Serializable]):
	item_menu.show()
	Pause_On()
	tp_bar.show()
	pause_menu_panel.show()
	#-------------------------------------------------------------------------------
	money_menu.show()
	SetMoney_Label()
	#-------------------------------------------------------------------------------
	var _all_a: Callable = func():
		Move_To_Item_Information_1(item_menu_key_information_root, item_menu_key_button_array.size())
		Move_To_Item_Button_List(item_menu_key_button_root, item_menu_key_button_0, item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	var _consumable_a: Callable = func():
		Move_To_Item_Button_List(item_menu_all_button_root, item_menu_all_button_0, item_menu_all_button_array)
	#-------------------------------------------------------------------------------
	var _equip_a: Callable = func():
		Move_To_Item_Information_1(item_menu_consumable_information_root, item_menu_consumable_button_array.size())
		Move_To_Item_Button_List(item_menu_consumable_button_root, item_menu_consumable_button_0, item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	var _key_a: Callable = func():
		Move_To_Item_Information_1(item_menu_equip_information_root, item_menu_equip_button_array.size())
		Move_To_Item_Button_List(item_menu_equip_button_root, item_menu_equip_button_0, item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	var _all_d: Callable = func():
		Move_To_Item_Information_1(item_menu_consumable_information_root, item_menu_consumable_button_array.size())
		Move_To_Item_Button_List(item_menu_consumable_button_root, item_menu_consumable_button_0, item_menu_consumable_button_array)
	#-------------------------------------------------------------------------------
	var _consumable_d: Callable = func():
		Move_To_Item_Information_1(item_menu_equip_information_root, item_menu_equip_button_array.size())
		Move_To_Item_Button_List(item_menu_equip_button_root, item_menu_equip_button_0, item_menu_equip_button_array)
	#-------------------------------------------------------------------------------
	var _equip_d: Callable = func():
		Move_To_Item_Information_1(item_menu_key_information_root, item_menu_key_button_array.size())
		Move_To_Item_Button_List(item_menu_key_button_root, item_menu_key_button_0, item_menu_key_button_array)
	#-------------------------------------------------------------------------------
	var _key_d: Callable = func():
		Move_To_Item_Button_List(item_menu_all_button_root, item_menu_all_button_0, item_menu_all_button_array)
	#-------------------------------------------------------------------------------
	var _all_selected_0: Callable = func():
		Enable_All_Item_Button_0()
		Hide_All_Item_Menues()
		item_menu_all_button_root.show()
		#-------------------------------------------------------------------------------
		if(item_menu_all_button_array.size() > 0):
			Disable_Item_Button_0(item_menu_all_button_0)
			singleton.Move_to_Button(item_menu_all_button_array[0])
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _consumable_selected_0: Callable = func():
		Enable_All_Item_Button_0()
		Hide_All_Item_Menues()
		Hide_All_Item_Information_Root()
		item_menu_consumable_button_root.show()
		#-------------------------------------------------------------------------------
		if(item_menu_consumable_button_array.size() > 0):
			item_menu_consumable_information_root.show()
			Disable_Item_Button_0(item_menu_consumable_button_0)
			singleton.Move_to_Button(item_menu_consumable_button_array[0])
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _equip_selected_0: Callable = func():
		Enable_All_Item_Button_0()
		Hide_All_Item_Menues()
		Hide_All_Item_Information_Root()
		item_menu_equip_button_root.show()
		#-------------------------------------------------------------------------------
		if(item_menu_equip_button_array.size() > 0):
			item_menu_equip_information_root.show()
			Disable_Item_Button_0(item_menu_equip_button_0)
			singleton.Move_to_Button(item_menu_equip_button_array[0])
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _key_selected_0: Callable = func():
		Enable_All_Item_Button_0()
		Hide_All_Item_Menues()
		Hide_All_Item_Information_Root()
		item_menu_key_button_root.show()
		#-------------------------------------------------------------------------------
		if(item_menu_key_button_array.size() > 0):
			item_menu_key_information_root.show()
			Disable_Item_Button_0(item_menu_key_button_0)
			singleton.Move_to_Button(item_menu_key_button_array[0])
		#-------------------------------------------------------------------------------
		else:
			singleton.Common_Selected()
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _submit_0: Callable = func():pass
	var _cancel_0: Callable = func():Close_Market()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_AD_Left_Right(item_menu_all_button_0, _all_selected_0, _submit_0, _cancel_0, _all_a, _all_d)
	singleton.Set_Button_AD_Left_Right(item_menu_consumable_button_0, _consumable_selected_0, _submit_0, _cancel_0, _consumable_a, _consumable_d)
	singleton.Set_Button_AD_Left_Right(item_menu_equip_button_0, _equip_selected_0, _submit_0, _cancel_0, _equip_a, _equip_d)
	singleton.Set_Button_AD_Left_Right(item_menu_key_button_0, _key_selected_0, _submit_0, _cancel_0, _key_a, _key_d)
	#-------------------------------------------------------------------------------
	for _i in _consumableitem_array.size():
		var _hold: int = _consumableitem_array[_i].stored
		var _cooldown: int = _consumableitem_array[_i].cooldown
		#-------------------------------------------------------------------------------
		var _consumableitem_button: Button = Create_ConsumableItem_InMarket_Button(_consumableitem_array[_i])
		#-------------------------------------------------------------------------------
		var _consumable_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_consumable_information_root)
		#-------------------------------------------------------------------------------
		var _consumable_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_consumable_information_root)
		#-------------------------------------------------------------------------------
		var _consumable_selected: Callable = func():BuyMenu_Item_Consumable_Selected(_consumableitem_array[_i])
		var _submit_consumable_item: Callable = func():BuyMenu_ItemConsumable_Submit(_consumableitem_button, _merchant_name, _consumableitem_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_consumableitem_button, _consumable_selected, _submit_consumable_item, _cancel_0, _consumable_w, _consumable_s, _consumable_a, _consumable_d)
		item_menu_consumable_button_content.add_child(_consumableitem_button)
		item_menu_consumable_button_array.append(_consumableitem_button)
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_ConsumableItem_InMarket_Button(_consumableitem_array[_i])
		#-------------------------------------------------------------------------------
		var _all_select_1: Callable = func():
				BuyMenu_Item_Consumable_Selected(_consumableitem_array[_i])
				Move_To_Item_Information_0(item_menu_consumable_information_root)
			#-------------------------------------------------------------------------------
		var _submit_all_item: Callable = func():BuyMenu_ItemConsumable_Submit(_allitem_button, _merchant_name, _consumableitem_array[_i])
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_allitem_button, _all_select_1, _submit_all_item, _cancel_0, _consumable_w, _consumable_s, _all_a, _all_d)
		item_menu_all_button_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	for _i in _equipitem_array.size():
		var _equipitem_button: Button = Create_EquipItem_InMarket_Button(_equipitem_array[_i])
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_EquipItem_InMarket_Button(_equipitem_array[_i])
		#-------------------------------------------------------------------------------
		var _equip_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_equip_information_root)
		#-------------------------------------------------------------------------------
		var _equip_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_equip_information_root)
		#-------------------------------------------------------------------------------
		var _equip_selected: Callable = func():BuyMenu_EquipItem_Selected(_equipitem_array[_i])
		var _submit_equip_item: Callable = func():BuyMenu_EquipItem_Submit(_equipitem_button, _merchant_name, _equipitem_array[_i], _equipitem_button, _allitem_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_equipitem_button, _equip_selected, _submit_equip_item, _cancel_0, _equip_w, _equip_s, _equip_a, _equip_d)
		item_menu_equip_button_content.add_child(_equipitem_button)
		item_menu_equip_button_array.append(_equipitem_button)
		#-------------------------------------------------------------------------------
		var _all_select_1: Callable = func():
			BuyMenu_EquipItem_Selected(_equipitem_array[_i])
			Move_To_Item_Information_0(item_menu_equip_information_root)
		#-------------------------------------------------------------------------------
		var _all_submit: Callable = func():BuyMenu_EquipItem_Submit(_allitem_button, _merchant_name, _equipitem_array[_i], _equipitem_button, _allitem_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_allitem_button, _all_select_1, _all_submit, _cancel_0, _equip_w, _equip_s, _all_a, _all_d)
		item_menu_all_button_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	for _i in _keyitem_array.size():
		var _keyitem_button: Button = Create_KeyItem_InMarket_Button(_keyitem_array[_i])
		#-------------------------------------------------------------------------------
		var _allitem_button: Button = Create_KeyItem_InMarket_Button(_keyitem_array[_i])
		#-------------------------------------------------------------------------------
		var _key_w: Callable = func(): singleton.ScrollContainer_Up(item_menu_key_information_root)
		#-------------------------------------------------------------------------------
		var _key_s: Callable = func(): singleton.ScrollContainer_Down(item_menu_key_information_root)
		#-------------------------------------------------------------------------------
		var _key_selected_1: Callable = func():BuyMenu_KeyItem_Selected(_keyitem_array[_i])
		var _submit_keyitem: Callable = func():BuyMenu_KeyItem_Submit(_keyitem_button, _merchant_name, _keyitem_array[_i], _keyitem_button, _allitem_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_keyitem_button, _key_selected_1, _submit_keyitem, _cancel_0, _key_w, _key_s, _key_a, _key_d)
		item_menu_key_button_content.add_child(_keyitem_button)
		item_menu_key_button_array.append(_keyitem_button)
		#-------------------------------------------------------------------------------
		var _all_select_1: Callable = func():
			BuyMenu_KeyItem_Selected(_keyitem_array[_i])
			Move_To_Item_Information_0(item_menu_key_information_root)
		#-------------------------------------------------------------------------------
		var _submit_allitem: Callable = func():BuyMenu_KeyItem_Submit(_allitem_button, _merchant_name, _keyitem_array[_i], _keyitem_button, _allitem_button)
		#-------------------------------------------------------------------------------
		singleton.Set_Button_WSAD_Left_Right(_allitem_button, _all_select_1, _submit_allitem, _cancel_0, _key_w, _key_s, _all_a, _all_d)
		item_menu_all_button_content.add_child(_allitem_button)
		item_menu_all_button_array.append(_allitem_button)
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_all_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_consumable_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_equip_button_array)
	singleton.Button_Array_Set_Vertical_Navigation(item_menu_key_button_array)
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
	next_signal.emit()
	#-------------------------------------------------------------------------------
	await get_tree().physics_frame
	Pause_Off()
#-------------------------------------------------------------------------------
func BuyMenu_Item_Consumable_Selected(_item_serializable: Action_Serializable):
	#-------------------------------------------------------------------------------
	for _i in item_consumable_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(item_consumable_serializable_array[_i].action_resource == _item_serializable.action_resource):
			Set_Item_Consumable_Information(item_consumable_serializable_array[_i])
			singleton.Common_Selected()
			return
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _item_serializable_new: Action_Serializable = Duplicate_Consumable_Serializable(_item_serializable)
	_item_serializable_new.hold = 0
	_item_serializable_new.stored = 0
	Set_Item_Consumable_Information(_item_serializable_new)
	singleton.Common_Selected()
	return
#-------------------------------------------------------------------------------
func Duplicate_Consumable_Serializable(_old_item_serializable:Action_Serializable) -> Action_Serializable:
	var _new_item_serializable:Action_Serializable = Action_Serializable.new()
	_new_item_serializable.action_resource = _old_item_serializable.action_resource
	return _new_item_serializable
#-------------------------------------------------------------------------------
func BuyMenu_ItemConsumable_Submit(_button:Button, _merchant_name: String, _item_serializable: Action_Serializable):
	var _price: int = _item_serializable.action_resource.price
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _final_price: int = _price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_final_price <= money_serializable.stored):
			_item_serializable.hold -= how_many_would_you_buy
			money_serializable.stored -= _final_price
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
	var _up: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_price, 10, false, 99)
	#-------------------------------------------------------------------------------
	var _down: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_price, 10, false, 99)
	#-------------------------------------------------------------------------------
	var _left: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_price, 1, false, 99)
	#-------------------------------------------------------------------------------
	var _right: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_price, 1, false, 99)
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = tr("name_"+singleton.get_resource_filename(_item_serializable.action_resource))
	how_many_would_you_buy = 1
	Print_How_Many_Do_You_Buy(_price, false, 99)
	var _item_in_inventory: Action_Serializable = Get_ConsumableItem_in_Inventory(_item_serializable.action_resource)
	Print_How_Many_Do_You_Hold_and_Stored(_item_in_inventory)
	Confirm_Buy_Menu_Submit(_submit, _button, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func BuyMenu_EquipItem_Selected(_equip_serializable: Equip_Serializable):
	#-------------------------------------------------------------------------------
	for _i in item_equip_serializable_array.size():
		#----------------------------------------------------------------
		if(item_equip_serializable_array[_i].equip_resource == _equip_serializable.equip_resource):
			Set_Item_Equip_Information(item_equip_serializable_array[_i])
			singleton.Common_Selected()
			return
		#----------------------------------------------------------------
	#----------------------------------------------------------------
	var _equip_serializable_new: Equip_Serializable = Duplicate_Equip_Serializable(_equip_serializable)
	_equip_serializable_new.stored = 0
	Set_Item_Equip_Information(_equip_serializable_new)
	singleton.Common_Selected()
	return
#-------------------------------------------------------------------------------
func Duplicate_Equip_Serializable(_old_equip_serializable: Equip_Serializable) -> Equip_Serializable:
	var _new_equip_serializable: Equip_Serializable = Equip_Serializable.new()
	_new_equip_serializable.equip_resource = _old_equip_serializable.equip_resource
	return _new_equip_serializable
#-------------------------------------------------------------------------------
func BuyMenu_EquipItem_Submit(_button:Button, _merchant_name: String, _equip_serializable: Equip_Serializable, _equipitem_button:Button, _allitem_button:Button):
	var _price: int = _equip_serializable.equip_resource.price
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _final_price: int = _price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_final_price <= money_serializable.stored and how_many_would_you_buy <= _equip_serializable.stored):
			_equip_serializable.stored -= how_many_would_you_buy
			money_serializable.stored -= _final_price
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
	var _up: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_price, 10, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	var _down: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_price, 10, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	var _left: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_price, 1, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	var _right: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_price, 1, true, _equip_serializable.stored)
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = tr("name_"+singleton.get_resource_filename(_equip_serializable.equip_resource))
	how_many_would_you_buy = 1
	Print_How_Many_Do_You_Buy(_price, true, _equip_serializable.stored)
	var _equip_in_inventory: Equip_Serializable = Get_EquipItem_in_Inventory(_equip_serializable.equip_resource)
	Print_How_Many_Do_You_Stored(_equip_in_inventory.stored)
	Confirm_Buy_Menu_Submit(_submit, _button, _up, _down, _left, _right)
#-------------------------------------------------------------------------------
func BuyMenu_KeyItem_Selected(_key_serializable: Key_Serializable):
	#----------------------------------------------------------------
	for _i in item_key_serializable_array.size():
		#----------------------------------------------------------------
		if(item_key_serializable_array[_i].key_resource == _key_serializable.key_resource):
			Set_Item_Key_Information(item_key_serializable_array[_i])
			singleton.Common_Selected()
			return
		#----------------------------------------------------------------
	#----------------------------------------------------------------
	var _keyitem_serializable_new: Key_Serializable = Duplicate_Key_Serializable(_key_serializable)
	_keyitem_serializable_new.stored = 0
	Set_Item_Key_Information(_keyitem_serializable_new)
	singleton.Common_Selected()
	return
#-------------------------------------------------------------------------------
func Duplicate_Key_Serializable(_old_keyitem_serializable:Key_Serializable) -> Key_Serializable:
	var _new_key_serializable: Key_Serializable = Key_Serializable.new()
	_new_key_serializable.key_resource = _old_keyitem_serializable.key_resource
	return _new_key_serializable
#-------------------------------------------------------------------------------
func BuyMenu_KeyItem_Submit(_button:Button, _merchant_name: String, _key_serializable: Key_Serializable, _keyitem_button:Button, _allitem_button:Button):
	var _price: int = _key_serializable.key_resource.price
	#-------------------------------------------------------------------------------
	var _submit: Callable= func():
		var _final_price: int = _price * how_many_would_you_buy
		#-------------------------------------------------------------------------------
		if(_final_price <= money_serializable.stored and how_many_would_you_buy <= _key_serializable.stored):
			_key_serializable.stored -= how_many_would_you_buy
			money_serializable.stored -= _final_price
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
	var _up: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_price, 10, true, _key_serializable.stored)
	#-------------------------------------------------------------------------------
	var _down: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_price, 10, true, _key_serializable.stored)
	#-------------------------------------------------------------------------------
	var _left: Callable = func():
		Decrease_How_Many_Do_Want_to_Buy(_price, 1, true, _key_serializable.stored)
	#-------------------------------------------------------------------------------
	var _right: Callable = func():
		Increase_How_Many_Do_Want_to_Buy(_price, 1, true, _key_serializable.stored)
	#-------------------------------------------------------------------------------
	confirm_buy_menu_item_name.text = tr("name_"+singleton.get_resource_filename(_key_serializable.key_resource))
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
	#var _final_price: int = _price * how_many_would_you_buy
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
	while(money_serializable.stored < _whole_cost):
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
	_button.text = "  "+tr("name_"+singleton.get_resource_filename(_item_serializable.action_resource))+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	#-------------------------------------------------------------------------------
	var _label2: RichTextLabel = RichTextLabel.new()
	_label2.bbcode_enabled = true
	_label2.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
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
	_button.text = "  "+tr("name_"+singleton.get_resource_filename(_equip_serializable.equip_resource))+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
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
	_button.text = "  "+tr("name_"+singleton.get_resource_filename(_key_serializable.key_resource))+"  "
	_button.add_theme_font_size_override("font_size", button_array_font_size)
	_button.custom_minimum_size.y = button_array_minimum_size_y
	_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
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
func Confirm_Buy_Menu_Submit(_submit:Callable, _button:Button, _up:Callable, _down:Callable, _left:Callable, _right:Callable):
	confirm_buy_menu.show()
	_button.disabled = true
	#-------------------------------------------------------------------------------
	var _cancel: Callable = func():
		confirm_buy_menu.hide()
		_button.disabled = false
		singleton.Move_to_Button(_button)
		singleton.Common_Canceled()
	#-------------------------------------------------------------------------------
	singleton.Set_Button_Up_Down_Left_Right(confirm_buy_menu_button, func():pass, _submit, _cancel, _up, _down, _left, _right)
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
	confirm_buy_menu_item_price.text += "  /  "+Get_Money_Label(money_serializable.stored)
#-------------------------------------------------------------------------------
func Print_How_Many_Do_You_Hold_and_Stored(_action_serializable:Action_Serializable):
	confirm_buy_menu_hold_value.text = "["+str(_action_serializable.hold)+"/"+str(_action_serializable.action_resource.max_hold)+"]"
	confirm_buy_menu_stored_value.text = "["+str(_action_serializable.stored)+"]"
#-------------------------------------------------------------------------------
func Print_How_Many_Do_You_Stored(_stored:int):
	confirm_buy_menu_hold_value.text = "-"
	confirm_buy_menu_stored_value.text = "["+str(_stored)+"]"
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
func Add_ConsumableItem_to_Inventory(_item_serializable: Action_Serializable, _hold:int) -> Action_Serializable:
	#-------------------------------------------------------------------------------
	for _i in item_consumable_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(item_consumable_serializable_array[_i].action_resource == _item_serializable.action_resource):
			#-------------------------------------------------------------------------------
			if(_item_serializable.action_resource.max_hold > 0):
				item_consumable_serializable_array[_i].hold += _hold
				#-------------------------------------------------------------------------------
				if(item_consumable_serializable_array[_i].hold > _item_serializable.action_resource.max_hold):
					var _extra: int = item_consumable_serializable_array[_i].hold - _item_serializable.action_resource.max_hold
					item_consumable_serializable_array[_i].hold = _item_serializable.action_resource.max_hold
					item_consumable_serializable_array[_i].stored += _extra
					return item_consumable_serializable_array[_i]
				#-------------------------------------------------------------------------------
				else:
					return item_consumable_serializable_array[_i]
				#-------------------------------------------------------------------------------
			#-------------------------------------------------------------------------------
			else:
				item_consumable_serializable_array[_i].stored += _hold
				return item_consumable_serializable_array[_i]
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
			item_consumable_serializable_array.append(_new_item)
			return _new_item
		#-------------------------------------------------------------------------------
		else:
			item_consumable_serializable_array.append(_new_item)
			return _new_item
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	else:
		_new_item.stored = _hold
		item_consumable_serializable_array.append(_new_item)
		return _new_item
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_ConsumableItem_in_Inventory(_item_resource: Action_Resource) -> Action_Serializable:
	#-------------------------------------------------------------------------------
	for _i in item_consumable_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(item_consumable_serializable_array[_i].action_resource == _item_resource):
			return item_consumable_serializable_array[_i]
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	var _new_item: Action_Serializable = Action_Serializable.new()
	_new_item.action_resource = _item_resource
	_new_item.hold = 0
	_new_item.stored = 0
	_new_item.cooldown = 0
	#-------------------------------------------------------------------------------
	return _new_item
#-------------------------------------------------------------------------------
func Add_EquipItem_to_Inventory(_equip_serializable: Equip_Serializable, _hold:int) -> Equip_Serializable:
	return Add_Equip_Serializable_to_Array(item_equip_serializable_array, _equip_serializable.equip_resource, _hold)
#-------------------------------------------------------------------------------
func Get_EquipItem_in_Inventory(_equip_resource:Equip_Resource) -> Equip_Serializable:
	#-------------------------------------------------------------------------------
	for _i in item_equip_serializable_array.size():
		#-------------------------------------------------------------------------------
		if(item_equip_serializable_array[_i].equip_resource == _equip_resource):
			return item_equip_serializable_array[_i]
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
	if(_key_serializable.key_resource == money_serializable.key_resource):
		money_serializable.stored += _hold
		return money_serializable
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		for _i in item_key_serializable_array.size():
			#-------------------------------------------------------------------------------
			if(item_key_serializable_array[_i].key_resource == _key_serializable.key_resource):
				item_key_serializable_array[_i].stored += _hold
				return item_key_serializable_array[_i]
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		var _new_key_serializable: Key_Serializable = Duplicate_Key_Serializable(_key_serializable)
		_new_key_serializable.key_resource = _key_serializable.key_resource
		_new_key_serializable.stored = _hold
		item_key_serializable_array.append(_new_key_serializable)
		return _new_key_serializable
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_KeyItem_in_Inventory(_key_resource:Key_Resource) -> Key_Serializable:
	#-------------------------------------------------------------------------------
	if(_key_resource == money_serializable.key_resource):
		return money_serializable
	#-------------------------------------------------------------------------------
	else:
		#-------------------------------------------------------------------------------
		for _i in item_key_serializable_array.size():
			#-------------------------------------------------------------------------------
			if(item_key_serializable_array[_i].key_resource == _key_resource):
				return item_key_serializable_array[_i]
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
		var _new_key_serializable: Key_Serializable = Key_Serializable.new()
		_new_key_serializable.key_resource = _key_resource
		_new_key_serializable.stored = 0
		#-------------------------------------------------------------------------------
		return _new_key_serializable
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Enter_Battle():
	myGAME_STATE = GAME_STATE.IN_BATTLE
	await Fade_Out_Override()
	battle_background.show()
	tp_bar.show()
	#-------------------------------------------------------------------------------
	if(true == true):
		Set_All_Fighters_Position_1()
		dialogue_menu.show()
		#battle_box.global_position = camera.global_position - battle_box.size * battle_box.scale*0.5
		#battle_box.show()
		await Seconds(0.1)
		await Fade_In_Override()
		await Seconds(0.1)
		battle_menu.show()
	#-------------------------------------------------------------------------------
	else:
		Set_All_Fighters_Position_2()
		battle_box.global_position = camera.global_position - battle_box.size * battle_box.scale*0.5
		battle_box.show()
		dialogue_menu.hide()
		await Seconds(0.1)
		await Fade_In_Override()
		await Seconds(0.1)
		battle_menu.hide()
	#-------------------------------------------------------------------------------
	singleton.Move_to_Button(battle_menu_skills_button)
#-------------------------------------------------------------------------------
func Set_All_Fighters_Position_1():
	var _camera_center: Vector2 = camera.global_position
	battle_background.global_position = _camera_center - camera_size*0.5
	#-------------------------------------------------------------------------------
	var _x1: float = 0.1
	var _x2: float = 0.35
	var _y1: float = -0.15
	var _y2: float = 0.25
	#-------------------------------------------------------------------------------
	var _ally_dx: float = (_x2-_x1) / (ally_node_array.size()+1)
	var _ally_dy: float = (_y2-_y1) / (ally_node_array.size()+1)
	#-------------------------------------------------------------------------------
	for _i in ally_node_array.size():
		var _x: float = camera_size.x * (-_x1 - (_i+1) * _ally_dx)
		var _y: float = camera_size.y * (_y1 + (_i+1) * _ally_dy)
		ally_node_array[_i].global_position = _camera_center + Vector2(_x, _y)
		Face_Left(ally_node_array[_i].character_node, false)
		#-------------------------------------------------------------------------------
		var _ally_ui: Fighter_UI = fighter_ally_ui_prefab.instantiate() as Fighter_UI
		battle_ui.add_child(_ally_ui)
		_ally_ui.global_position = Get_Position_in_Canvas_Layer(ally_node_array[_i].global_position)
		#-------------------------------------------------------------------------------
		ally_node_array[_i].z_index = 2
		ally_node_array[_i].show()
	#-------------------------------------------------------------------------------
	var _enemy_dx: float = (_x2-_x1) / (enemy_node_array.size()+1)
	var _enemy_dy: float = (_y2-_y1) / (enemy_node_array.size()+1)
	#-------------------------------------------------------------------------------
	for _i in enemy_node_array.size():
		var _x: float = camera_size.x * (_x1 + (_i+1) * _enemy_dx)
		var _y: float = camera_size.y * (_y1 + (_i+1) * _enemy_dy)
		enemy_node_array[_i].global_position = _camera_center + Vector2(_x, _y)
		Face_Left(enemy_node_array[_i].character_node, true)
		#-------------------------------------------------------------------------------
		var _enemy_ui: Fighter_UI = fighter_enemy_ui_prefab.instantiate() as Fighter_UI
		battle_ui.add_child(_enemy_ui)
		_enemy_ui.global_position = Get_Position_in_Canvas_Layer(enemy_node_array[_i].global_position)
		#-------------------------------------------------------------------------------
		enemy_node_array[_i].z_index = 2
		enemy_node_array[_i].show()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_All_Fighters_Position_2():
	var _camera_center: Vector2 = camera.global_position
	battle_background.global_position = _camera_center - camera_size*0.5
	#-------------------------------------------------------------------------------
	var _x1: float = 0.3
	var _x2: float = 0.3
	var _y1: float = -0.28
	var _y2: float = 0.63
	#-------------------------------------------------------------------------------
	var _ally_dx: float = (_x2-_x1) / (ally_node_array.size()+1)
	var _ally_dy: float = (_y2-_y1) / (ally_node_array.size()+1)
	#-------------------------------------------------------------------------------
	for _i in ally_node_array.size():
		var _x: float = camera_size.x * (-_x1 - (_i+1) * _ally_dx)
		var _y: float = camera_size.y * (_y1 + (_i+1) * _ally_dy)
		ally_node_array[_i].global_position = _camera_center + Vector2(_x, _y)
		Face_Left(ally_node_array[_i].character_node, false)
		#-------------------------------------------------------------------------------
		var _ally_ui: Fighter_UI = fighter_ally_ui_prefab.instantiate() as Fighter_UI
		battle_ui.add_child(_ally_ui)
		_ally_ui.global_position = Get_Position_in_Canvas_Layer(ally_node_array[_i].global_position)
		#-------------------------------------------------------------------------------
		ally_node_array[_i].z_index = 2
		ally_node_array[_i].show()
	#-------------------------------------------------------------------------------
	var _enemy_dx: float = (_x2-_x1) / (enemy_node_array.size()+1)
	var _enemy_dy: float = (_y2-_y1) / (enemy_node_array.size()+1)
	#-------------------------------------------------------------------------------
	for _i in enemy_node_array.size():
		var _x: float = camera_size.x * (_x1 + (_i+1) * _enemy_dx)
		var _y: float = camera_size.y * (_y1 + (_i+1) * _enemy_dy)
		enemy_node_array[_i].global_position = _camera_center + Vector2(_x, _y)
		Face_Left(enemy_node_array[_i].character_node, true)
		#-------------------------------------------------------------------------------
		var _enemy_ui: Fighter_UI = fighter_enemy_ui_prefab.instantiate() as Fighter_UI
		battle_ui.add_child(_enemy_ui)
		_enemy_ui.global_position = Get_Position_in_Canvas_Layer(enemy_node_array[_i].global_position)
		#-------------------------------------------------------------------------------
		enemy_node_array[_i].z_index = 2
		enemy_node_array[_i].show()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Seconds(_timer:float):
	await get_tree().create_timer(_timer, true, true).timeout
#-------------------------------------------------------------------------------
func Set_Fighter_0():
	ally_node_array[0].show()
	ally_node_array[0].reparent(player_characterbody2d)
	ally_node_array[0].position = Vector2.ZERO
	#-------------------------------------------------------------------------------
	for _i in range(1, ally_node_array.size()):
		ally_node_array[_i].show()
		ally_node_array[_i].reparent(world_2d)
		#ally_node_array[_i].global_position = player_characterbody2d.global_position
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Get_Ally_Fighter_Resource_Array() -> Array[Fighter_Resource]:
	var _fighter_resource_array: Array[Fighter_Resource]
	for _i in ally_node_array.size():
		_fighter_resource_array.append(ally_node_array[_i].fighter_serializable.fighter_resource)
	return _fighter_resource_array
#-------------------------------------------------------------------------------
func Get_Fighter_Node_Index(_fighter_resource:Fighter_Resource) -> int:
	#-------------------------------------------------------------------------------
	for _i in ally_node_array.size():
		#-------------------------------------------------------------------------------
		if(ally_node_array[_i].fighter_serializable.fighter_resource == _fighter_resource):
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
