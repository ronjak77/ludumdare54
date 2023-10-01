extends Panel

func _ready():
#	visible = true
	pass

func _on_Button_pressed():
	queue_free()

func set_text(new_text):
	$TutorialPanel/RichTextLabel.text = new_text
