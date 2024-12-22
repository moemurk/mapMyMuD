extends Node
class_name CodriverMessage

enum Direction {Left, Right}
enum Conjunction {None, Immediately, Into, Thirty, Fifty, OneHundred, TwoHundred, Long}
enum RoadFlag {Crest, Bump, DontCut, Open, Tighten, Slippy}

@export var direction: Direction = Direction.Left
@export var curve: int = 1
@export var conjunction: Conjunction = Conjunction.None
@export var flags: Array[RoadFlag] = []

func clear():
	direction = Direction.Left
	curve = 1
	conjunction = Conjunction.None
	flags = []
