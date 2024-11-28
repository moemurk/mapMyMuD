extends Node3D

@onready var saved_pacenote: Dictionary = {}
@onready var to_send_pacenote: Array = []
@onready var curve: MenuButton = $CanvasLayer/PaceNotes/VBoxContainer/HBoxContainer/Curve
@onready var conjunction: MenuButton = $CanvasLayer/PaceNotes/VBoxContainer/HBoxContainer/Conjunction
@onready var road_condition: GridContainer = $CanvasLayer/PaceNotes/VBoxContainer/HBoxContainer3/RoadCondition
@onready var popup_curve = curve.get_popup()
@onready var popup_conjunction = conjunction.get_popup() #save as instance variables

func _ready():
	saved_pacenote.clear()
	to_send_pacenote.clear()
	popup_curve.id_pressed.connect(_on_menu_curve) #pass the reference, not calling immediately
	popup_conjunction.id_pressed.connect(_on_menu_conjunction)
	_initiate()
	print(saved_pacenote)

func _initiate():
	saved_pacenote["Direction"] = "left"
	saved_pacenote["Curve"] = "6"
	saved_pacenote["Conjunction"] = "None"
	for child in road_condition.get_children():
		if child is Button:
			saved_pacenote[child.name] = null
			child.pressed.connect(_on_button_pressed.bind(child))

func _on_check_button_LR_pressed():
	if saved_pacenote["Direction"] == "left":
		saved_pacenote["Direction"] = "right"
	else:
		saved_pacenote["Direction"] = "left"
	print("Direction:",saved_pacenote["Direction"])

func _on_menu_curve(id):
	var item_text = popup_curve.get_item_text(id)
	print("Curve:",item_text, ", id:",id)
	saved_pacenote["Curve"] = item_text
	
func _on_menu_conjunction(id):
	var item_text = popup_conjunction.get_item_text(id)
	print("Conjuction:",item_text, ", id:",id)
	saved_pacenote["Conjunction"] = item_text

func _on_button_pressed(button:Button):
	print("Button pressed:", button.name)
	if saved_pacenote[button.name] == null:
		saved_pacenote[button.name] = str(button.name)
	else:
		saved_pacenote[button.name] = null


func _on_send_pressed():
	for key in saved_pacenote.keys():
		var value = saved_pacenote[key]
		if value != null:
			to_send_pacenote.append(value)
	CodriverMessage.codriver_message = to_send_pacenote
	print(CodriverMessage.codriver_message)
	for key in saved_pacenote.keys():
		if key != "Direction":
			saved_pacenote[key] = null
	saved_pacenote["Curve"] = "6"
	saved_pacenote["Conjunction"] = "None"
	to_send_pacenote.clear()
	CodriverMessage.codriver_message.clear()
