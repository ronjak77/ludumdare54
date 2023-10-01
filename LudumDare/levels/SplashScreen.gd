extends Node2D

func _input(event):
	if event is InputEventMouseButton:
		get_tree().change_scene("res://levels/lv1.tscn")
		Singleton.on_level_change()
