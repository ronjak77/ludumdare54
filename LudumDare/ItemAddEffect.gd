extends Node2D


func _ready():
	$AnimationPlayer.connect("animation_finished", self, "remove")
	$AnimationPlayer.play("resize_large")
	
func remove(_params):
	queue_free()

