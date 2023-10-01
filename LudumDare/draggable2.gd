extends KinematicBody2D


var dragging = false
var draggable = true
var click_radius = 32 # Size of the sprite.
export var underneath = false
var inside_allowed_area = false
var initial_position
var not_initialized = true
var index_in_list
var item_type
var times_clicked_this = 0
var clicking_border
var has_added_border = false

func _ready():
	if underneath:
		layers = pow(2, 3)
		set_collision_layer_bit(1, false)
	
	var area = get_node("/root/Node2D/GoalArea")		
	area.connect("goal_entered", self, "_on_goal_entered")
	area.connect("goal_exited", self, "_on_goal_exited")

func _process(_delta):
	if not_initialized:
		initial_position = position
		not_initialized = false

func _input(event):
	if draggable:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if (event.position - global_position).length() < click_radius:
				if not dragging and event.pressed and not Singleton.already_dragging_one:
					set_dragging()

			if dragging and not event.pressed:
				set_not_dragging()
				
				# If item is inside area, ok
				# if not inside area, or if collides with existing items, move it back to start pos
				var pos = event.position - global_position
				var collisions = move_and_collide(pos)
				if collisions:
					move_back()
				elif inside_allowed_area:
					Singleton.free_location(self)
					set_not_draggable()
					inside_allowed_area = false
				else:
					move_back() 
			

		if event is InputEventMouseMotion and dragging:
			var pos = event.position - global_position
			var collisions = move_and_collide(pos)
			if collisions:
				move_back()
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if (event.position - global_position).length() < Singleton.increased_click_radius:
			if not has_added_border:
				add_clicking_border()
			else:
				increment_border()
				times_clicked_this = times_clicked_this + 1
				if times_clicked_this == Singleton.clicks_needed_to_remove - 1:
					Singleton.play_effect_at(position)
					Singleton.add_dust()
					queue_free()
					

func add_clicking_border():	
	var item = load("res://item_clicking_border.tscn")
	clicking_border = item.instance()
	increment_border()
	add_child(clicking_border)
	has_added_border = true
	
func increment_border():
	clicking_border.value = clicking_border.value + 100/Singleton.clicks_needed_to_remove

func _on_goal_entered(body):
	if body == self:
		inside_allowed_area = true

func _on_goal_exited(body):
	if body == self:
		inside_allowed_area = false
	
func move_back():
	position = initial_position

func set_not_draggable():
	draggable = false
	
func set_dragging():
#	Layer 5 for drag and move. 3 for underneath. 1 for normal. area collides with everything
	dragging = true
	z_index = 1
	if !underneath:
		layers = pow(2, 5)
	Singleton.already_dragging_one = true

func set_not_dragging():
	dragging = false
	if !underneath:
		layers = pow(2, 1)
	z_index = 0
	Singleton.already_dragging_one = false
	
func queue_delete_with_anim():
	var remove_timer = $remove_timer
#	add_child(remove_timer_instance)
	remove_timer.time_for_delete = 2.0
	remove_timer.start_remove_timer()

func swap_color(new_color):
	get_node("Icon").modulate = Color(new_color)
