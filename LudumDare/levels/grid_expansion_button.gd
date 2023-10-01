extends Button
var text_array = ["LUSTRITE", "ECLIPSIUM", "DIVINITUM", "ARCANITE", "SERAPHINE", "ETHERITE", "MYSTIQUA", "LUMINIQUE", "CELESTIUM", "VERTEXIUM", "SYMMETRA"]
var index = -1

func _ready():
	set_text(text)

func _on_grid_button_pressed():
	if Singleton.player_resource_dust >= Singleton.grid_expansion_cost:
		Singleton.reduce_player_resource_dust(Singleton.grid_expansion_cost)
		Singleton.expand_grid()
		index = index + 1
		if index < text_array.size():
			set_text(text_array[index])
		
func set_text(_text):
	text = _text + " " + String(Singleton.grid_expansion_cost) + " S"
