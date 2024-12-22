extends Node3D

@onready var saved_pacenote: Dictionary = {}
@onready var curve: MenuButton = $CanvasLayer/PaceNotes/VBoxContainer/HBoxContainer/Curve
@onready var conjunction: MenuButton = $CanvasLayer/PaceNotes/VBoxContainer/HBoxContainer/Conjunction
@onready var road_condition: GridContainer = $CanvasLayer/PaceNotes/VBoxContainer/HBoxContainer3/RoadCondition
@onready var popup_curve = curve.get_popup()
@onready var popup_conjunction = conjunction.get_popup() #save as instance variables

func _ready():
	saved_pacenote.clear()
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
	print("Conjunction:",item_text, ", id:",id)
	saved_pacenote["Conjunction"] = item_text

func _on_button_pressed(button:Button):
	print("Button pressed:", button.name)
	if saved_pacenote[button.name] == null:
		saved_pacenote[button.name] = str(button.name)
	else:
		saved_pacenote[button.name] = null


func _on_send_pressed():
	var to_send_pacenote = build_codriver_message(saved_pacenote)
	send_message(to_send_pacenote)
	for key in saved_pacenote.keys():
		if key != "Direction":
			saved_pacenote[key] = null
	saved_pacenote["Curve"] = "6"
	saved_pacenote["Conjunction"] = "None"
	
func build_codriver_message(_saved_pacenote: Dictionary) -> CodriverMessage:
	print("build_codriver_message")
	print(_saved_pacenote)
	var message = CodriverMessage.new()
	for key in saved_pacenote.keys():
		match key:
			"Direction":
				if _saved_pacenote["Direction"] == "left":
					message.direction = CodriverMessage.Direction.Left
				else:
					message.direction = CodriverMessage.Direction.Right
			"Curve":
				message.curve = int(_saved_pacenote["Curve"])
			"Conjunction":
				match _saved_pacenote["Conjunction"]:
					"None":
						message.conjunction = CodriverMessage.Conjunction.None
					"immediately":
						message.conjunction = CodriverMessage.Conjunction.Immediately
					"Into":
						message.conjunction = CodriverMessage.Conjunction.Into
					"30":
						message.conjunction = CodriverMessage.Conjunction.Thirty
					"50":
						message.conjunction = CodriverMessage.Conjunction.Fifty
					"100":
						message.conjunction = CodriverMessage.Conjunction.OneHundred
					"200":
						message.conjunction = CodriverMessage.Conjunction.TwoHundred
					"Long":
						message.conjunction = CodriverMessage.Conjunction.Long
			"Crest":
				if _saved_pacenote["Crest"] != null:
					message.flags.append(CodriverMessage.RoadFlag.Crest)
			"Bump":
				if _saved_pacenote["Bump"] != null:
					message.flags.append(CodriverMessage.RoadFlag.Bump)
			"DontCut":
				if _saved_pacenote["DontCut"] != null:
					message.flags.append(CodriverMessage.RoadFlag.DontCut)
			"Open":
				if _saved_pacenote["Open"] != null:
					message.flags.append(CodriverMessage.RoadFlag.Open)
			"Tighten":
				if _saved_pacenote["Tighten"] != null:
					message.flags.append(CodriverMessage.RoadFlag.Tighten)
			"Slippy":
				if _saved_pacenote["Slippy"] != null:
					message.flags.append(CodriverMessage.RoadFlag.Slippy)
	return message

func send_message(to_send_pacenote: CodriverMessage):
	print("send_message")
	print(to_send_pacenote)
	Network.direct.rpc_id(Network.team_mate_id, var_to_str(to_send_pacenote))
	
