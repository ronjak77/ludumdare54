extends Button

var first_press = true
var popup_text = "Or when you get enough of the same type, consume them. \nYou need as many items in the center at the same time as the number says."

func _on_giving_button_pressed():
	if first_press:
		Singleton.show_popup(popup_text)
		first_press = false
	Singleton.give_new_item()
	disabled = true

func enable_button():
	disabled = false

