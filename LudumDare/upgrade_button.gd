extends Button

var item_type
var group_number

func _ready():
	Singleton.connect("cost_updated", self, "_on_cost_update")

func _on_Button_button_down():
	Singleton.upgrade_type(item_type, group_number)
#	if Singleton.count_items_in_area(item_type) >= Singleton.upgrade_required_count(item_type):
#		Singleton.remove_items_by_type(group_number, Singleton.upgrade_required_count(item_type))

func _on_cost_update(signal_item_type, new_cost):
	if signal_item_type == item_type:
		text = String(new_cost)
