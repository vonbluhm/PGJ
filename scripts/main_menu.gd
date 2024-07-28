extends Control

@onready var start_button = $VBoxContainer/StartButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var options_menu = $"../OptionsMenu"
@onready var quit_button = $VBoxContainer/QuitButton
@onready var quitting_dialog = $"../QuittingDialog"
@onready var start_scene = preload("res://scenes/stage.tscn")\
 as PackedScene

func _ready():
	start_button.grab_focus()


func _process(_delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(start_scene)


func _on_options_button_pressed():
	options_menu.set_deferred("visible", true)


func _on_quit_button_button_down():
	quitting_dialog.set_deferred("visible", true)


func _on_quitting_dialog_confirmed():
	get_tree().quit()
