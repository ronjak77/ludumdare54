extends Button
var text_array = ["FOOL", "MAGICIAN", "HIGH PRIESTESS", "EMPRESS", "EMPEROR", "HIEROPHANT", "LOVERS", "CHARIOT", "STRENGTH", "THE HERMIT", "WHEEL OF FORTUNE", "JUSTICE", "HANGED MAN", "DEATH", "TEMPERANCE", "DEVIL", "TOWER", "STAR", "MOON", "SUN", "JUDGEMENT", "THE WORLD"]
var index = -1

func _ready():
	set_text(text)
	Singleton.connect("redo_buttons", self, "_redo_button")

func _on_autoclicker_button_pressed():
	if Singleton.player_resource_dust >= Singleton.autoclicker_cost:
		Singleton.reduce_player_resource_dust(Singleton.autoclicker_cost)
		Singleton.increase_autoclicker()
		index = index + 1
		if index < text_array.size():
			set_text(text_array[index])

func set_text(_text):
	text = _text + " " + String(Singleton.autoclicker_cost) + " ♥S"

func _redo_button():
	if index < text_array.size():
		set_text(text_array[index])
	else:		
		set_text(text_array[-1])
