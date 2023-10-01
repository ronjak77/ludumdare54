extends Node2D

onready var timer = get_node("Timer")
onready var pb = get_node("ProgressBar")


func _ready():
	pb.value = 100
	visible = false
	Singleton.connect("autoclicker_speed_updated", self, "_on_cost_update")
	

func _process(_delta):
	if timer.time_left > 0 and Singleton.available_space_in_grid:
		visible = true
	var percent = timer.time_left / timer.wait_time
	pb.value = percent*100


func _on_Timer_timeout():
	Singleton.add_new_item()
	visible = false

func start(time):
	visible = true
	timer.start(time)

func set_autoclicker_true():
	timer.one_shot = false
	timer.start(Singleton.autoclicker_speed)
	
	
func _on_cost_update(new_speed):
	timer.one_shot = true
	timer.connect("timeout", self, "new_timeout")
	timer.start(new_speed)

func new_timeout():
	timer.start(Singleton.autoclicker_current_speed)
	timer.one_shot = false
