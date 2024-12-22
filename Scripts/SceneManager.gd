extends Node

@export
var scene_map = {
	"lobby": preload("res://Scenes/lobby.tscn"),
	"map1": preload("res://Scenes/world.tscn"),
	"codriver": preload("res://Scenes/codriver.tscn"),
}

var current_scene = null

func change_scene(map_name: String) -> void:
	var map = scene_map.get(map_name)
	if map == null:
		return
	var scene_instance = map
	current_scene = scene_instance
	get_tree().change_scene_to_packed(map)
