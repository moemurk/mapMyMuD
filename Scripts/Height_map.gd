extends Node2D

const MAP_WIDTH = 32
const MAP_HEIGHT = 32

var height_map: PackedFloat64Array = []

func _ready():
	initialize_height_map()
	apply_noise_to_height_map()
	var start = Vector2i(0, 0)
	var end = Vector2i(MAP_WIDTH - 1, MAP_HEIGHT - 1)
	var path = dfs_find_path(start, end)
	if path.size() > 0:
		decrease_path_height(path, 3)
		average_path_height(path)
	print(height_map)

func _draw():
	var cell_size = 8
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			var h = get_height(x, y)
			# Example: color from black (height=0) to white (height=20+)
			var brightness = clamp(h / 20.0, 0, 1)
			var color = Color(brightness, brightness, brightness)
			draw_rect(Rect2(x * cell_size, y * cell_size, cell_size, cell_size), color)

func initialize_height_map():
	height_map.resize(MAP_WIDTH * MAP_HEIGHT)
	for i in range(MAP_WIDTH * MAP_HEIGHT):
		height_map[i] = 0.0

func get_height_index(x: int, y: int) -> int:
	return y * MAP_WIDTH + x

func get_height(x: int, y: int) -> float:
	return height_map[get_height_index(x, y)]

func set_height(x: int, y: int, value: float):
	height_map[get_height_index(x, y)] = value

func apply_noise_to_height_map():
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.05
	noise.fractal_gain = 0.8
	noise.fractal_octaves = 4
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			var n = noise.get_noise_2d(float(x), float(y))
			var height_value = (n + 1.0) * 10.0
			set_height(x, y, height_value)

func dfs_find_path(start:Vector2i, end:Vector2i):
	var visited = {}
	var stack = [ [start] ]
	while stack.size() > 0:
		var path = stack.pop_back()
		var current = path[path.size() - 1]
		if current == end:
			return path
		if current in visited:
			continue
		visited[current] = true
		for neighbor in get_neighbors(current):
			if neighbor.x >= 0 and neighbor.y >= 0 and neighbor.x < MAP_WIDTH and neighbor.y < MAP_HEIGHT:
				if neighbor not in visited:
					var new_path = path.duplicate()
					new_path.append(neighbor)
					stack.append(new_path)
	return [] #path not found

func get_neighbors(pos: Vector2i) -> Array:
	return [
		Vector2i(pos.x + 1, pos.y),
		Vector2i(pos.x - 1, pos.y),
		Vector2i(pos.x, pos.y + 1),
		Vector2i(pos.x, pos.y - 1)
	]
	
func decrease_path_height(path:Array, amount:float):
	for point in path:
		var old_height = get_height(point.x, point.y)
		set_height(point.x, point.y, old_height - amount)

func average_path_height(path: Array):
	if path.size() == 0:
		return
	var total_height: float = 0.0
	for point in path:
		total_height += get_height(point.x, point.y)
	var avg_height: float = total_height / float(path.size())
	for point in path:
		set_height(point.x, point.y, avg_height)
	
	
	
