extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.connect("resource_updated", self, "_on_resource_updated")
	pass # Replace with function body.

func _on_resource_updated():
	var text = "You can buy upgrades --> \nHopefully it will make the journey easier."
	Singleton.show_popup(text)
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
