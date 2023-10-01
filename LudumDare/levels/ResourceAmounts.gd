extends Control



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.connect("resource_updated", self, "_on_resource_updated")

func _on_resource_updated():
	$ResourceAmounts.text = "STAR: " + String(Singleton.player_resource_dust)
	$ResourceTitle2.text = "MOON♥: " + String(Singleton.player_resource_dirt)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
