extends Camera2D

var zoom_power = 1.05
var new_zoom = 1

func _unhandled_input(event):
	pass
#	if event.is_action_pressed("zoom_out"):
##		new_zoom = zoom.x * zoom_power
#		position.x = position.x + 100
#
#	if event.is_action_pressed("zoom_in"):
##		new_zoom = zoom.x / zoom_power
#		position.x = position.x - 100
#
##	new_zoom = clamp(new_zoom, 1.0, 3.0);
##	zoom = Vector2(new_zoom, new_zoom)		
#	Singleton.zoom_level = new_zoom
