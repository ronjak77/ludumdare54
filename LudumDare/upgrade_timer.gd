extends Node

onready var timer = get_node("Timer")
onready var pb = get_node("ProgressBar")


func _ready():
	pb.value = 100
	timer.wait_time = Singleton.timer_basic_time
	

func _process(delta):
	var percent = timer.time_left / timer.wait_time
	pb.value = percent*100

func start_timer(time):
	timer.wait_time = time
	timer.start()


func _on_Timer_timeout():
	Singleton.give_points()
