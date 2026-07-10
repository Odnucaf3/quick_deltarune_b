extends Node
class_name Title_Scene
#-------------------------------------------------------------------------------
#region VARIABLES
#-------------------------------------------------------------------------------
@export var title_menu: Control
@export var title_menu_label: Label
@export var title_menu_button_start: Button
@export var title_menu_button_options: Button
@export var title_menu_button_credits: Button
@export var title_menu_button_quit: Button
@export var credits_menu: Control
@export var credits_menu_root: ScrollContainer
@export var credits_menu_richtext: RichTextLabel
@export var credits_menu_button_0: Button
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MONOVEHAVIOUR
#-------------------------------------------------------------------------------
func _ready() -> void:
	singleton.option_menu.Start()
	Set_Idiome()
	#-------------------------------------------------------------------------------
	title_menu.show()
	credits_menu.hide()
	#singleton.Play_BGM(singleton.title_bgm)
	#-------------------------------------------------------------------------------
	Set_Title_Menu()
	Set_Credit_Menu()
#-------------------------------------------------------------------------------
func Set_Title_Menu():
	#-------------------------------------------------------------------------------
	var _button_array:Array[Button] = [
		title_menu_button_start,
		title_menu_button_options,
		title_menu_button_credits,
		title_menu_button_quit
	]
	#-------------------------------------------------------------------------------
	singleton.Button_Array_Set_Vertical_Navigation(_button_array)
	singleton.Move_to_Button(title_menu_button_start)
	#-------------------------------------------------------------------------------
	var _submit_start:Callable = func():Title_Menu_Start_Button_Submit()
	var _submit_options:Callable = func():Title_Menu_Option_Button_Submit()
	var _submit_credits:Callable = func():Title_Menu_Credit_Button_Submit()
	var _submit_quit:Callable = func():Title_Menu_Quit_Button_Submit()
	var _selected:Callable = func():singleton.Common_Selected()
	var _cancel:Callable = func():Title_Menu_Any_Button_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(title_menu_button_start, _selected, _submit_start, _cancel)
	singleton.Set_Button(title_menu_button_options, _selected, _submit_options, _cancel)
	singleton.Set_Button(title_menu_button_credits, _selected, _submit_credits, _cancel)
	singleton.Set_Button(title_menu_button_quit, _selected, _submit_quit, _cancel)
#-------------------------------------------------------------------------------
func Set_Credit_Menu():
	credits_menu_richtext.meta_clicked.connect(func(_meta:Variant):_richtextlabel_on_meta_clicked(_meta))
	#-------------------------------------------------------------------------------
	var _selected: Callable = func(): singleton.Common_Selected()
	var _submit: Callable = func(): pass
	var _cancel: Callable = func(): credits_menu_Back_Button_Cancel()
	#-------------------------------------------------------------------------------
	var _w: Callable = func():
		singleton.ScrollContainer_Up(credits_menu_root)
	#-------------------------------------------------------------------------------
	var _s: Callable = func():
		singleton.ScrollContainer_Down(credits_menu_root)
	#-------------------------------------------------------------------------------
	singleton.Button_Remove_Navigation(credits_menu_button_0)
	singleton.Set_Button_WS_Up_Down(credits_menu_button_0, _selected, _submit, _cancel, _w, _s)
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region TITLE MENU
#-------------------------------------------------------------------------------
func Title_Menu_Start_Button_Submit():
	singleton.Common_Submited()
	get_tree().change_scene_to_file("res://Nodes/Scenes/game_system.tscn")
#-------------------------------------------------------------------------------
func Title_Menu_Option_Button_Submit():
	singleton.option_menu.show()
	#-------------------------------------------------------------------------------
	var _selected:Callable = func():singleton.Common_Selected()
	var _submit:Callable = func():Option_Menu_Back_Button_Submit()
	var _cancel:Callable = func():Option_Menu_Back_Button_Cancel()
	#-------------------------------------------------------------------------------
	singleton.Set_Button(singleton.option_menu.back, _selected, _submit, _cancel)
	#-------------------------------------------------------------------------------
	title_menu.hide()
	singleton.Move_to_Button(singleton.option_menu.back)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Title_Menu_Credit_Button_Submit() -> void:
	credits_menu.show()
	title_menu.hide()
	credits_menu_richtext.get_v_scroll_bar().value = 0
	singleton.Move_to_Button(credits_menu_button_0)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Title_Menu_Quit_Button_Submit():
	singleton.Common_Submited()
	get_tree().quit()
#-------------------------------------------------------------------------------
func Title_Menu_Any_Button_Cancel():
	singleton.Move_to_Button(title_menu_button_quit)
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region OPTION MENU
#-------------------------------------------------------------------------------
func Option_Menu_Back_Button_Submit():
	Option_Menu_Back_Button_Common()
	singleton.Move_to_Button(title_menu_button_options)
	singleton.Common_Submited()
#-------------------------------------------------------------------------------
func Option_Menu_Back_Button_Cancel():
	Option_Menu_Back_Button_Common()
	singleton.Move_to_Button(title_menu_button_options)
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
func Option_Menu_Back_Button_Common() -> void:
	singleton.option_menu.Save_OptionSaveData_Json()
	singleton.option_menu.hide()
	Set_Idiome()
	title_menu.show()
#-------------------------------------------------------------------------------
func Set_Idiome():
	#-------------------------------------------------------------------------------
	title_menu_label.text = "  "+tr("title_menu_title")+"  "
	#-------------------------------------------------------------------------------
	title_menu_button_start.text = "  "+tr("title_menu_start_button")+"  "
	title_menu_button_options.text = "  "+tr("options_button")+"  "
	#-------------------------------------------------------------------------------
	var _credits: String = tr("title_menu_credits_button")
	title_menu_button_credits.text = "  "+_credits+"  "
	credits_menu_button_0.text = "  "+_credits+"  "
	#credits_menu_richtext.text = tr("credits_menu_richtext")
	#-------------------------------------------------------------------------------
	title_menu_button_quit.text = "  "+tr("title_menu_quit_button")+"  "
	#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region CREDITS MENU
#-------------------------------------------------------------------------------
func credits_menu_Back_Button_Cancel():
	credits_menu.hide()
	title_menu.show()
	singleton.Move_to_Button(title_menu_button_credits)
	singleton.Common_Canceled()
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
#region MISC
#-------------------------------------------------------------------------------
func _richtextlabel_on_meta_clicked(_meta:Variant):
	# `meta` is not guaranteed to be a String, so convert it to a String
	# to avoid script errors at runtime.
	OS.shell_open(str(_meta))
#-------------------------------------------------------------------------------
#endregion
#-------------------------------------------------------------------------------
