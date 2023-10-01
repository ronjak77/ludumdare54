extends TextureProgress
var time_for_delete = 4.0
var timer
var player
var running = false


func start_remove_timer():
	timer = $"../Timer"
	player = $"../AnimationPlayer"
	visible = true
	timer.one_shot = true
	timer.connect("timeout", self, "queue_me_free")
	player.connect("animation_finished", self, "remove")
	timer.start(time_for_delete)	
	running = true

func _process(_delta):
	if running:
		var percent = float(timer.time_left) / float(timer.wait_time)
		value = percent*100

func queue_me_free():
	visible = false
	player.play("scale_up")	

func remove(_argument):
	get_parent().queue_free()

