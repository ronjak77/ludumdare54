extends Button


var text_array =  ["ANDROMEDA", "AQUARIUS", "ARIES", "CANCER", "CAPRICORNUS", "CASSIOPEIA", "CYGNUS", "DRACO", "GEMINI", "LEO", "LIBRA", "LYRA", "ORION", "PEGASUS", "PISCES", "SAGITTARIUS", "SCORPIUS", "TAURUS", "URSA MAJOR", "URSA MINOR", "VIRGO"]
var index = -1

func _ready():
	set_text("")
	Singleton.connect("redo_buttons", self, "_redo_button")


func set_text(_text):
	text = _text + " " + String(Singleton.ascension_cost) + " ♥S"

func _redo_button():
	if index < text_array.size():
		set_text(text_array[index])
	else:		
		set_text(text_array[-1])


func _on_ascension_button_pressed():
	if Singleton.player_resource_dirt >= Singleton.ascension_cost:
		Singleton.ascend()
		index = index + 1
		if index < text_array.size():
			set_text(text_array[index])
		
