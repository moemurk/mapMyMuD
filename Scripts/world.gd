extends Node3D

@onready var velocity_label = $CanvasLayer/Velocity_Label
@onready var nissan_gtr = $"Nissan GTR"


func _process(delta):
	if nissan_gtr and nissan_gtr is VehicleBody3D:
		var speed = nissan_gtr.linear_velocity.length() #speed in m/s
		velocity_label.text = "Speed: " + str(round(speed * 10) / 10) + "m/s"
