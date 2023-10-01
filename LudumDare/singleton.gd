extends Node

# parts
var timer
var giving_timer
var giving_button
var expandable_area

# difficulty related
var timer_basic_time = 15
var timer_interval_block_spawn = 5
var clicks_needed_to_remove = 5
var bonus_per_block = 2
var upgrade_required_count = []

var autoplacement = false

var increased_click_radius = 32
var click_radius_increase = 5

# cheapest 2
var grid_expansion_cost = 1
var grid_expansion_cost_increase = 3
var grid_expansion_max_times = 5


var ascension_cost = 5
var ascension_cost_increase = 5
var current_ascension = 0
var max_ascension = 8
var ascension_needed_for_autoplace = 7


var autoclicker_threshold = 2
var autoclicker_cost = 1
var autoclicker_cost_increase = 1


var autoclicker_speed = 10
var autoclicker_current_speed = 20
var autoclicker_speed_increase = 3

# state
var items_in_area_count = 0
var items_in_area = []
var area_loaded = false
var updates_done = 1
var already_dragging_one = false
var player_resource_dust = 0
var player_resource_dirt = 0
var updates_done_by_group = []
var has_autoclicker = false
var current_expansion = 0
var available_space_in_grid = true

signal cost_updated
signal resource_updated
signal autoclicker_speed_updated
signal redo_buttons


var color_array_1 = ["#F1E3D3", "#FF8551", "#FFE247", "#C46868"]
var color_array_2 = ["#9BCDD2", "#393939", "#FFE247"]
var color_array_3 = ["#C98BB9", "#9E5062", "#E3A49A", "#716A7D"];
var color_array_4 = ["#72B2A7", "#566573", "#9FA8B0"];
var color_array_5 = ["#E9C77B", "#EE8D68", "#D6619E", "#505D75"];
var color_array_6 = ["#A3876A", "#4B4E6D", "#C1A29E"];
var color_array_7 = ["#83AFA1", "#E87461", "#E8A562", "#6B818C"];
var color_array_8 = ["#6084A3", "#2E4057", "#8CB5A8"];
var active_palette = color_array_1

var colors = [color_array_1, color_array_2, color_array_3, color_array_4, color_array_5, color_array_6, color_array_7, color_array_8]

var is_not_colliding_in_mouse = true


func _ready():
	pass


func on_level_change():
	area_loaded = true


func _process(_delta):
	try_loading_area()
	

func try_loading_area():
	if area_loaded:
		var area = get_node("/root/Node2D/GoalArea")
		if area:
			area_loaded = false
			expandable_area = area
			area.connect("goal_entered", self, "area_added_one")
			area.connect("goal_exited", self, "area_removed_one")	
			giving_timer = get_node("/root/Node2D/maintimer")
			giving_button = get_node("/root/Node2D/giving_button")


func area_added_one(body):	
	items_in_area_count = items_in_area_count + 1
	items_in_area.append(body)


func area_removed_one(body):	
	items_in_area_count = items_in_area_count - 1
	items_in_area.erase(body)	
	
	
func count_items_in_area(type):
	var count = 0
	for i in items_in_area.size():
		if items_in_area[i].item_type == type:
			count = count + 1
	return count
	
	
func remove_items_by_type(type, count):
	var removed_count = 0
	var items = get_tree().get_nodes_in_group(String(type))
	
#	Go through all the items everywhere
	for i in items.size():
		if items_in_area.find(items[i]) >= 0 :
	#		found the item in the array of items that are touching the goal area
#			items[i].queue_free();
			items[i].queue_delete_with_anim();
			items_in_area.erase(items[i])
			removed_count = removed_count + 1
			if removed_count == count:
				break
	
	
func add_new_item():
	var spawner = get_node("/root/Node2D/AreaSpawn")
	giving_button.enable_button()
	spawner.add_new_item()


func add_new_timer():
	timer = load("res://timer_spawnable.tscn")
	var new_timer = timer.instance()
	get_node("/root/Node2D/TimerContainer").add_child(new_timer)
	new_timer.start_timer(timer_basic_time - bonus_per_block)


func request_location():
	var spawner = get_node("/root/Node2D/AreaSpawn")
	return spawner.request_location()
	
func free_location(instance):
	var spawner = get_node("/root/Node2D/AreaSpawn")
	spawner.free_location(instance)

func get_cost_of_upgrade(item_type):	
	return updates_done_by_group[item_type] + 2


func upgrade_type(item_type, group_number):
#	print(item_type)
	if count_items_in_area(item_type) >= get_cost_of_upgrade(item_type):
		remove_items_by_type(group_number, get_cost_of_upgrade(item_type))
#		updates_done = updates_done + 1 
		player_resource_dirt = player_resource_dirt + get_cost_of_upgrade(item_type)
		updates_done_by_group[group_number] = updates_done_by_group[group_number] + 1
		emit_signal("resource_updated")
		emit_signal("redo_buttons")
		emit_signal("cost_updated", item_type, get_cost_of_upgrade(item_type))
	
func give_new_item():	
	giving_timer.start(timer_interval_block_spawn)	
		
	
func add_dust():
	player_resource_dust = player_resource_dust + 1
	emit_signal("resource_updated")
	if player_resource_dust > autoclicker_threshold:
		var button = get_node("/root/Node2D/autoclicker_button")
		button.visible = true

func expand_grid():
	if current_expansion < grid_expansion_max_times:
		expandable_area.scale = expandable_area.scale * Vector2(1.2, 1.2)
		current_expansion = current_expansion + 1
		grid_expansion_cost = grid_expansion_cost + grid_expansion_cost_increase
	emit_signal("redo_buttons")

func increase_autoclicker():
	if !has_autoclicker:
		giving_timer.set_autoclicker_true()
		has_autoclicker = true
#		giving_button.queue_free()
	else:
#		autoclicker dfault speed 10 seconds, increase 2 seconds. new speed 10 - 2. new speed 8 
		autoclicker_current_speed = autoclicker_current_speed - autoclicker_speed_increase
		autoclicker_cost = autoclicker_cost + autoclicker_cost_increase
		emit_signal("autoclicker_speed_updated", autoclicker_current_speed)
		
	emit_signal("redo_buttons")

func reduce_player_resource_dust(amount):	
	player_resource_dust = player_resource_dust - amount
	emit_signal("resource_updated")

func reduce_player_resource_dirt(amount):	
	player_resource_dirt = player_resource_dirt - amount
	emit_signal("resource_updated")

func give_points():
	print("Good job")



func play_effect_at(position):
	var effect_thing = load("res://ItemAddEffect.tscn")
	var effect_instance = effect_thing.instance()
	var node_parent = get_node("/root/Node2D")
	node_parent.call_deferred("add_child", effect_instance)
	effect_instance.position = position

func ascend():
	if ascension_cost <= player_resource_dirt:
		if current_ascension < max_ascension:
			change_colors()
			
			current_ascension = current_ascension + 1
			reduce_player_resource_dirt(ascension_cost)
			emit_signal("resource_updated")
			
			
			ascension_cost = ascension_cost + ascension_cost_increase
			if(current_ascension == 2):
				show_popup("Huh, looks like now you don't need to click so many times..")
				if clicks_needed_to_remove > 2:
					clicks_needed_to_remove = clicks_needed_to_remove - 1
			if(current_ascension == 3):
				show_popup("Nice! You can now click in a larger radius.")
				increased_click_radius = increased_click_radius + click_radius_increase
			
			if(current_ascension == 4):
				show_popup("Clicking is sure fast now!")
				clicks_needed_to_remove = 2
			
			
			
			if current_ascension == ascension_needed_for_autoplace:
				show_popup("Oh wow! Looks like the boxies now go automatically where your mouse pointer is, if possible.")
				autoplacement = true
			
			emit_signal("redo_buttons")
		else:
			show_popup("Congratulations! Thanks for playing! You win! <3")

func change_colors():
	active_palette = colors[current_ascension]			
	var items = get_tree().get_nodes_in_group("box")
	for i in items.size():
		var random_color = active_palette[randi() % active_palette.size()]
		items[i].swap_color(random_color)

func show_popup(text):
	var popup = load("res://popup.tscn")
	var instance = popup.instance()
	get_node("/root/Node2D").add_child(instance)
	instance.set_text(text)
	instance.visible = true
	
	

