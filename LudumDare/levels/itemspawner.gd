extends Node2D

var grid_lines = 4
var grid_column_length = 6
#var imgs = "res://level items/1/"
var img_array = []
var scene = preload("res://item.tscn")
var location_array = []
var total_images_to_add = 19
var filled_positions = []
var color_array = Singleton.active_palette

func _ready():
	add_to_group("Area")

	var images = ["res://level items/1/Intersect.png", "res://level items/1/Rectangle 34.png", "res://level items/1/Polygon 4.png","res://level items/1/Ellipse 16.png", "res://level items/1/Rectangle 37(2).png", "res://level items/1/Rectangle 35.png","res://level items/1/Group 3.png", "res://level items/1/Rectangle 37(2).png" ]
	for i in images.size():
		img_array.append(load(images[i]))
	create_upgrade_buttons()
	create_upgrade_limits()
	

	var startx = 50
	var starty = 230

	for i in grid_lines:
		for j in grid_column_length:	
			location_array.append(Vector2(startx + i*50, starty + j*50))
	
	filled_positions.resize(24)
	for i in 24:
		filled_positions[i] = false	
	
	for y in total_images_to_add:
		add_new_item()

func next_available_index():
	var index_of_empty = filled_positions.find(false)
	if index_of_empty  == -1:
		return null
	else:		
		return index_of_empty

func get_is_space():
	var index_of_empty = filled_positions.find(false)
	if index_of_empty  == -1:
#		no empty spaces, no space
		return false
		Singleton.available_space_in_grid = false
	else:
		Singleton.available_space_in_grid = true
		return true
	
func request_location():
	if get_is_space():
		var changing_location = next_available_index()
		filled_positions[changing_location] = true
		return location_array[changing_location]
	else:
		return null
		
func free_location(instance):
	filled_positions[instance.index_in_list] = false
	
func create_upgrade_buttons():
	var button_template = load("res://upgrade_button.tscn")
	var button_parent = $"../UpgradeList"
	for i in img_array.size():
		Singleton.updates_done_by_group.append(0)
		var new_button = button_template.instance()
		button_parent.add_child(new_button)
		new_button.icon = img_array[i]
		new_button.item_type = i
		new_button.group_number = i
		

func create_upgrade_limits():
	var starting_amount = 2
	Singleton.upgrade_required_count.resize(img_array.size())
	for i in img_array.size():
		Singleton.upgrade_required_count[i] = starting_amount

func get_group_name(text):
	return img_array[int(text)]

func add_new_item():
	if get_is_space():
		var instance = scene.instance()
		add_child(instance)
		var random_value = randi() % img_array.size()
		var random_image =  img_array[random_value]
		var random_color = Singleton.active_palette[randi() % Singleton.active_palette.size()]
		instance.item_type = random_value
		instance.add_to_group(String(random_value))
		instance.add_to_group("box")
		
		add_polygon_colliders(random_image, instance)
#
		instance.get_node("Icon").texture = random_image
		instance.get_node("Icon").modulate = Color(random_color)
		
		var next_index = next_available_index()

		instance.position = location_array[next_index]
		filled_positions[next_index] = true
		instance.index_in_list = next_index
		Singleton.play_effect_at(instance.position)
		
		return instance
		
func _input(event):
	if Singleton.autoplacement:
		if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
#			todo: First check that there's space below mouse. Couldn't get to work :( So adding a star.
			Singleton.play_effect_at(get_global_mouse_position())
			
			if Singleton.is_not_colliding_in_mouse:
				var index = filled_positions.find(true)
				var items = get_tree().get_nodes_in_group("box")
				for i in items.size():
					if items[i].position == location_array[index]:
						items[i].position = get_global_mouse_position()
						free_location(items[i])
						break


func add_polygon_colliders(random_image, instance):
	# this function adapted from https://shaggydev.com/2022/04/13/sprite-collision-polygons/
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(random_image.get_data())
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, random_image.get_size()))

	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		instance.add_child(collision_polygon)
		collision_polygon.position -= bitmap.get_size()/2





