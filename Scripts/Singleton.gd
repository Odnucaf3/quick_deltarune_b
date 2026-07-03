extends Node
class_name Singleton
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
var game_system: Game_System
const cancelInput: String = "ui_cancel"
@export_category("Audio and SFXs")
@export var audioStreamPlayer_selected: AudioStreamPlayer
@export var audioStreamPlayer_submit: AudioStreamPlayer
@export var audioStreamPlayer_cancel: AudioStreamPlayer
@export var audioStreamPlayer_equip: AudioStreamPlayer
@export var audioStreamPlayer_unequip: AudioStreamPlayer
@export var fps_label: Label
@export var option_menu: Option_Menu
#-------------------------------------------------------------------------------
const v_scroll_value: int = 90
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
#-------------------------------------------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	Show_fps()
#-------------------------------------------------------------------------------
#region BUTTON FUNCTIONS (WITH MOUSE CONTROL)
#-------------------------------------------------------------------------------
func Set_Button(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable) -> void:
	Disconnect_Button(_b)
	_b.focus_entered.connect(_selected)
	_b.mouse_entered.connect(func():Mouse_Grab_Button(_b))
	_b.mouse_exited.connect(func():Mouse_Keep_Focus_When_Ext())
	_b.pressed.connect(func():Mouse_Grab_Button_and_Submit(_b, _submited))
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Button_WS(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable, _w:Callable, _s:Callable) -> void:
	Disconnect_Button(_b)
	_b.focus_entered.connect(_selected)
	_b.mouse_entered.connect(func():Mouse_Grab_Button(_b))
	_b.mouse_exited.connect(func():Mouse_Keep_Focus_When_Ext())
	_b.pressed.connect(func():Mouse_Grab_Button_and_Submit(_b, _submited))
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_W")):
				_w.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_S")):
				_s.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Button_WS_Up_Down(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable, _w:Callable, _s:Callable) -> void:
	Disconnect_Button(_b)
	_b.focus_entered.connect(_selected)
	_b.mouse_entered.connect(func():Mouse_Grab_Button(_b))
	_b.mouse_exited.connect(func():Mouse_Keep_Focus_When_Ext())
	_b.pressed.connect(func():Mouse_Grab_Button_and_Submit(_b, _submited))
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("ui_up")):
				_w.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("ui_down")):
				_s.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_W")):
				_w.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_S")):
				_s.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Button_AD_Left_Right(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable, _a:Callable, _d:Callable) -> void:
	Disconnect_Button(_b)
	_b.focus_entered.connect(_selected)
	_b.mouse_entered.connect(func():Mouse_Grab_Button(_b))
	_b.mouse_exited.connect(func():Mouse_Keep_Focus_When_Ext())
	_b.pressed.connect(func():Mouse_Grab_Button_and_Submit(_b, _submited))
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("ui_left")):
				_a.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("ui_right")):
				_d.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("Input_A")):
				_a.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("Input_D")):
				_d.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Button_WSAD(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable, _w:Callable, _s:Callable, _a:Callable, _d:Callable) -> void:
	Disconnect_Button(_b)
	_b.focus_entered.connect(_selected)
	_b.mouse_entered.connect(func():Mouse_Grab_Button(_b))
	_b.mouse_exited.connect(func():Mouse_Keep_Focus_When_Ext())
	_b.pressed.connect(func():Mouse_Grab_Button_and_Submit(_b, _submited))
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_W")):
				_w.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_S")):
				_s.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("Input_A")):
				_a.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("Input_D")):
				_d.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Button_WSAD_Left_Right(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable, _w:Callable, _s:Callable, _a:Callable, _d:Callable) -> void:
	Disconnect_Button(_b)
	_b.focus_entered.connect(_selected)
	_b.mouse_entered.connect(func():Mouse_Grab_Button(_b))
	_b.mouse_exited.connect(func():Mouse_Keep_Focus_When_Ext())
	_b.pressed.connect(func():Mouse_Grab_Button_and_Submit(_b, _submited))
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("ui_left")):
				_a.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("ui_right")):
				_d.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_W")):
				_w.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_S")):
				_s.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("Input_A")):
				_a.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("Input_D")):
				_d.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Set_Button_WSAD_Up_Down_Left_Right(_b:Button, _selected:Callable, _submited:Callable, _canceled:Callable, _w:Callable, _s:Callable, _a:Callable, _d:Callable) -> void:
	Disconnect_Button(_b)
	_b.focus_entered.connect(_selected)
	_b.mouse_entered.connect(func():Mouse_Grab_Button(_b))
	_b.mouse_exited.connect(func():Mouse_Keep_Focus_When_Ext())
	_b.pressed.connect(func():Mouse_Grab_Button_and_Submit(_b, _submited))
	#-------------------------------------------------------------------------------
	_b.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("ui_up")):
				_w.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("ui_down")):
				_s.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("ui_left")):
				_a.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("ui_right")):
				_d.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_W")):
				_w.call()
			#-------------------------------------------------------------------------------
			elif(Input.is_action_pressed("Input_S")):
				_s.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("Input_A")):
				_a.call()
			#-------------------------------------------------------------------------------
			elif(_event.is_action_pressed("Input_D")):
				_d.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_Button(_b:Button) -> void:
	Disconnect_All(_b.focus_entered)
	Disconnect_All(_b.mouse_entered)
	Disconnect_All(_b.pressed)
	Disconnect_All(_b.gui_input)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MOUSE CONTROL FUNCTIONS
#-------------------------------------------------------------------------------
func Mouse_Grab_Button(_control:Control):
	#-------------------------------------------------------------------------------
	if(_control.focus_mode == Control.FocusMode.FOCUS_ALL or _control.focus_mode == Control.FocusMode.FOCUS_CLICK):
		_control.grab_focus()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Mouse_Grab_Button_and_Submit(_c:Control, _submit:Callable):
	#-------------------------------------------------------------------------------
	if(_c.focus_mode == Control.FocusMode.FOCUS_ALL or _c.focus_mode == Control.FocusMode.FOCUS_CLICK):
		_c.grab_focus()
		_submit.call()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Mouse_Keep_Focus_When_Ext():
	var _control: Control = get_viewport().gui_get_focus_owner()
	#-------------------------------------------------------------------------------
	if(_control == null):
		return
	#-------------------------------------------------------------------------------
	if(_control.focus_mode == Control.FocusMode.FOCUS_ALL or _control.focus_mode == Control.FocusMode.FOCUS_CLICK):
		_control.grab_focus()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
func Set_OptionButtons(_ob:OptionButton, _selected:Callable, _submited:Callable, _canceled:Callable) -> void:
	Disconnect_OptionButtons(_ob)
	#-------------------------------------------------------------------------------
	_ob.focus_entered.connect(_selected)
	_ob.item_selected.connect(_submited)
	#-------------------------------------------------------------------------------
	_ob.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_OptionButtons(_ob:OptionButton):
	Disconnect_All(_ob.focus_entered)
	Disconnect_All(_ob.item_selected)
	Disconnect_All(_ob.gui_input)
#-------------------------------------------------------------------------------
func Set_CheckButton(_cb:CheckButton, _selected:Callable, _submited:Callable, _canceled:Callable) -> void:
	Disconnect_CheckButton(_cb)
	#-------------------------------------------------------------------------------
	_cb.focus_entered.connect(_selected)
	_cb.toggled.connect(_submited)
	#-------------------------------------------------------------------------------
	_cb.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_CheckButton(_cb:CheckButton):
	Disconnect_All(_cb.focus_entered)
	Disconnect_All(_cb.toggled)
	Disconnect_All(_cb.gui_input)
#-------------------------------------------------------------------------------
func Set_Slider(_sl:Slider,  _selected:Callable,  _submited:Callable,  _canceled:Callable) -> void:
	Disconnect_Slider(_sl)
	#-------------------------------------------------------------------------------
	_sl.focus_entered.connect(_selected)
	_sl.value_changed.connect(_submited)
	#-------------------------------------------------------------------------------
	_sl.gui_input.connect(
		#-------------------------------------------------------------------------------
		func(_event:InputEvent):
			#-------------------------------------------------------------------------------
			if(_event.is_action_pressed(cancelInput)):
				_canceled.call()
			#-------------------------------------------------------------------------------
		#-------------------------------------------------------------------------------
	)
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Disconnect_Slider(_sl:Slider):
	Disconnect_All(_sl.focus_entered)
	Disconnect_All(_sl.value_changed)
	Disconnect_All(_sl.gui_input)
#-------------------------------------------------------------------------------
func Disconnect_All(_signal:Signal):
	var _dictionaryArray : Array = _signal.get_connections()
	#-------------------------------------------------------------------------------
	for _dictionary in _dictionaryArray:
		_signal.disconnect(_dictionary["callable"])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Common_Selected() -> void:
	audioStreamPlayer_selected.play()
#-------------------------------------------------------------------------------
func Common_Submited() -> void:
	audioStreamPlayer_submit.play()
	audioStreamPlayer_selected.stop()
#-------------------------------------------------------------------------------
func Common_Canceled() -> void:
	audioStreamPlayer_cancel.play()
	audioStreamPlayer_selected.stop()
#-------------------------------------------------------------------------------
func Move_to_Button(_b:Button) -> void:
	_b.grab_focus()
#-------------------------------------------------------------------------------
func Move_to_Button_by_Submit(_b:Button):
	Move_to_Button(_b)
	Common_Submited()
#-------------------------------------------------------------------------------
func Move_to_Button_by_Equip(_b:Button):
	Move_to_Button(_b)
	audioStreamPlayer_selected.stop()
	audioStreamPlayer_equip.play()
#-------------------------------------------------------------------------------
func Move_to_Button_by_Unequip(_b:Button):
	Move_to_Button(_b)
	audioStreamPlayer_selected.stop()
	audioStreamPlayer_unequip.play()
#-------------------------------------------------------------------------------
func Move_to_Button_by_Cancel(_b:Button):
	Move_to_Button(_b)
	Common_Canceled()
#-------------------------------------------------------------------------------
func ScrollContainer_Down(_scroll_container:ScrollContainer):
	var _old_value: float = _scroll_container.get_v_scroll_bar().value
	_scroll_container.get_v_scroll_bar().value += v_scroll_value
	#-------------------------------------------------------------------------------
	if(_scroll_container.get_v_scroll_bar().value > _old_value):
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func ScrollContainer_Up(_scroll_container:ScrollContainer):
	var _old_value: float = _scroll_container.get_v_scroll_bar().value
	_scroll_container.get_v_scroll_bar().value -= v_scroll_value
	#-------------------------------------------------------------------------------
	if(_scroll_container.get_v_scroll_bar().value < _old_value):
		singleton.Common_Selected()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Button_Array_Set_Vertical_Navigation(_button_array:Array[Button]):
	#-------------------------------------------------------------------------------
	if(_button_array.size() > 0):
		if(_button_array.size() > 1):
			Button_Set_Vertical_Navigation(_button_array[0], _button_array[_button_array.size()-1], _button_array[1])
			#-------------------------------------------------------------------------------
			for _i in range(1, _button_array.size()-1):
				Button_Set_Vertical_Navigation(_button_array[_i], _button_array[_i-1], _button_array[_i+1])
			#-------------------------------------------------------------------------------
			Button_Set_Vertical_Navigation(_button_array[_button_array.size()-1], _button_array[_button_array.size()-2], _button_array[0])
		#-------------------------------------------------------------------------------
		else:
			Button_Set_Vertical_Navigation(_button_array[0], _button_array[0], _button_array[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Button_Set_Vertical_Navigation(_button:Button, _button_top:Button, _button_botton:Button):
	_button.focus_neighbor_top = _button_top.get_path()
	_button.focus_neighbor_bottom = _button_botton.get_path()
	_button.focus_neighbor_left = _button.get_path()
	_button.focus_neighbor_right = _button.get_path()
#-------------------------------------------------------------------------------
func Button_Array_Set_Horizontal_Navigation(_button_array:Array[Button]):
	#-------------------------------------------------------------------------------
	if(_button_array.size() > 0):
		if(_button_array.size() > 1):
			Button_Set_Horizontal_Navigation(_button_array[0], _button_array[_button_array.size()-1], _button_array[1])
			#-------------------------------------------------------------------------------
			for _i in range(1, _button_array.size()-1):
				Button_Set_Horizontal_Navigation(_button_array[_i], _button_array[_i-1], _button_array[_i+1])
			#-------------------------------------------------------------------------------
			Button_Set_Horizontal_Navigation(_button_array[_button_array.size()-1], _button_array[_button_array.size()-2], _button_array[0])
		#-------------------------------------------------------------------------------
		else:
			Button_Set_Horizontal_Navigation(_button_array[0], _button_array[0], _button_array[0])
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Button_Set_Horizontal_Navigation(_button:Button, _button_left:Button, _button_right:Button):
	_button.focus_neighbor_top = _button.get_path()
	_button.focus_neighbor_bottom = _button.get_path()
	_button.focus_neighbor_left = _button_left.get_path()
	_button.focus_neighbor_right = _button_right.get_path()
#-------------------------------------------------------------------------------
func Button_Remove_Navigation(_button:Button):
	_button.focus_neighbor_top = _button.get_path()
	_button.focus_neighbor_bottom = _button.get_path()
	_button.focus_neighbor_left = _button.get_path()
	_button.focus_neighbor_right = _button.get_path()
#-------------------------------------------------------------------------------
func Destroy_Childrens(_node:Node):
	var children = _node.get_children()
	#-------------------------------------------------------------------------------
	for _child in children:
		_child.queue_free()
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
func Destroy_Button_Array(_array_button:Array[Button]):
	#-------------------------------------------------------------------------------
	for _i in range(_array_button.size()-1, -1, -1):
		_array_button[_i].queue_free()
	#-------------------------------------------------------------------------------
	_array_button.clear()
#-------------------------------------------------------------------------------
func get_resource_filename(_resource: Resource) -> String:
	return _resource.resource_path.get_file().trim_suffix('.tres')
#-------------------------------------------------------------------------------
func get_instance_filename(_node: Node) -> String:
	return _node.scene_file_path.get_file().trim_suffix('.tscn')
#-------------------------------------------------------------------------------
func format_number_with_dots(_number: int) -> String:
	var _num_str: String = str(abs(_number))
	var _result: String = ""
	var _count: int = 0
	#-------------------------------------------------------------------------------
	for _i in range(_num_str.length() - 1, -1, -1):
		_result = _num_str[_i] + _result
		_count += 1
		#-------------------------------------------------------------------------------
		if(_count % 3 == 0 and _i != 0):
			_result = "." + _result
		#-------------------------------------------------------------------------------
	#-------------------------------------------------------------------------------
	if(_number < 0):
		_result = "-" + _result
	#-------------------------------------------------------------------------------
	return _result
#-------------------------------------------------------------------------------
func Show_fps():
	fps_label.text = str(Engine.get_frames_per_second()) + " fps."
#-------------------------------------------------------------------------------
