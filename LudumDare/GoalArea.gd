extends Area2D

signal goal_entered
signal goal_exited

func _ready():
	pass # Replace with function body.


func _on_GoalArea_body_entered(body):
	emit_signal("goal_entered", body)
	

func _on_GoalArea_body_exited(body):
	emit_signal("goal_exited", body)
