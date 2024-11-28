extends Control

@onready var player_name_edit = $VBoxContainer/TextEdit
@onready var driver_button = $VBoxContainer/DriverButton
@onready var observer_button = $VBoxContainer/ObserverButton

func _ready():
	player_name_edit.text = Network.player_name
	driver_button.button_pressed = true

func _on_driver_button_pressed():
	Network.play_roll = Client.PlayRoll.Driver
	observer_button.set_pressed_no_signal(false)

func _on_observer_button_pressed():
	Network.play_roll = Client.PlayRoll.Observer
	driver_button.set_pressed_no_signal(false)


func _on_join_lobby_button_pressed():
	Network.connect_to_server()


func _on_text_edit_text_changed():
	Network.player_name = player_name_edit.text
