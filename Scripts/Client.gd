extends Node
class_name Client

var _network_id: int
var _player_name: String
var _roll: PlayRoll

enum PlayRoll {
	Driver,
	Observer,
}

static func create(network_id: int, player_name: String, roll: PlayRoll) -> Client:
	var instance = Client.new()
	instance._player_name = player_name
	instance._network_id = network_id
	instance._roll = roll
	return instance
