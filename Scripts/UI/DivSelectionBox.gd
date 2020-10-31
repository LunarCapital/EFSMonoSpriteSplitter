extends VBoxContainer

signal selected_division(x1, x2, y1, y2);

var selection_checkboxes : Array = [];
var check_btns : Array = [];
var z_index_txtboxes : Array = [];

func init(sprite : Sprite):
	var num_divisions : int = (((sprite.texture.get_width() - Globals.div_size) / Globals.div_interval) + 1) * (((sprite.texture.get_height() - Globals.div_size) / Globals.div_interval) + 1);
	print("num div: " + str(num_divisions));
	var div_button_group : ButtonGroup = ButtonGroup.new();
	for i in range(num_divisions):
		var hbox_container : HBoxContainer = self._create_div_hbox(i, div_button_group);
		self.add_child(hbox_container);
	self._connect_radio_btn_signals(sprite);
	

func _create_div_hbox(index : int, div_button_group : ButtonGroup):
	var hbox_container : HBoxContainer = HBoxContainer.new();
	var check_box : CheckBox = CheckBox.new();
	check_box.text = "div " + str(index);
	check_box.group = div_button_group;
	hbox_container.add_child(check_box);
	selection_checkboxes.append(check_box);
	
	var check_btn : CheckButton = CheckButton.new();
	check_btn.text = "enabled";
	hbox_container.add_child(check_btn);
	check_btns.append(check_btn);

	var z_index_txtbox : TextEdit = TextEdit.new();
	z_index_txtbox.text = "0";
	z_index_txtbox.rect_min_size = Vector2(50, 20);
	z_index_txtbox.connect("text_changed", self, "_on_z_index_txtbox_changed", [z_index_txtbox]);
	hbox_container.add_child(z_index_txtbox);
	z_index_txtboxes.append(z_index_txtbox);

	return hbox_container;

func _connect_radio_btn_signals(sprite : Sprite):
	for i in range(selection_checkboxes.size()):
		var check_box : CheckBox = selection_checkboxes[i];
		check_box.connect("pressed", self, "_connect_singular_radio_btn", [sprite, i]);

func _connect_singular_radio_btn(sprite : Sprite, var index : int):
	var x1 : int = (index * Globals.div_interval) % (sprite.texture.get_width() - Globals.div_size + Globals.div_interval);
	var x2 : int = x1 + Globals.div_size - 1;
	var y1 : int = (index * Globals.div_interval) / (sprite.texture.get_width() - Globals.div_size + Globals.div_interval) * Globals.div_interval;
	var y2 : int = y1 + Globals.div_size - 1;
	emit_signal("selected_division", x1, x2, y1, y2);

func _on_z_index_txtbox_changed(z_index_txtbox : TextEdit):
	var input : String = z_index_txtbox.text;
	if not input.is_valid_integer():
		z_index_txtbox.text = "0";
	elif (int(input) > 999):
		z_index_txtbox.text = "999";
		
func lock():
	for btn in self.check_btns:
		btn.disabled = true;
	for txt in self.z_index_txtboxes:
		txt.readonly = true;
