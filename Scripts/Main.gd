extends Node2D

const ui_handler = preload("res://Scripts/UI/UIHandler.gd");
const sprite_loader = preload("res://Scripts/UI/SpriteLoader.gd");
const appender = preload("res://Scripts/Processing/Appender.gd");

var export_sheet : Image = Image.new();
var export_rows : int = 0;
var export_dict : Dictionary = {};


var anim_name_to_frames : Dictionary = {};

var camera_node : Camera2D;
var control_node : Control;
var draw_node : Node2D;

var view_sprite_path : String;
var view_sprite : Sprite;
var filedialog_open : FileDialog;
var append_btn : Button;
var add_btn : Button;
var export_btn : Button;
var anim_name_txt : TextEdit;
var anim_frame_txt : TextEdit;
var scroll_container : ScrollContainer;
var div_selection_box : VBoxContainer;

func _ready():
	export_sheet.create(1, 1, false, Image.FORMAT_RGBA8);
	
	camera_node = self.find_node("Camera2D", false, true);
	camera_node.position = self.get_viewport_rect().position;
	control_node = self.find_node("Control", true, true);
	self.get_tree().connect("screen_resized", self, "_on_window_resized");
	
	draw_node = self.find_node("DrawNode", false, true);
	ui_handler.find_all_UI_elements(self);
	ui_handler.hideUI(self);
	
	filedialog_open.get_cancel().connect("pressed", self, "_file_dialog_cancelled");
	filedialog_open.connect("file_selected", self, "_file_selected");
	filedialog_open.show();
	self._on_window_resized();

func _file_dialog_cancelled():
	if (self.export_dict.size() == 0):
		self.get_tree().quit();

func _file_selected(path : String):
	var first_file_open : bool = true if (view_sprite == null) else false;
	
	view_sprite_path = path.get_file().trim_suffix(".png"); #makes me wonder if i'll ever use anything that isn't a png
	print(view_sprite_path);
	view_sprite = sprite_loader.create_sprite_from_image(path);
	view_sprite.position = camera_node.get_viewport_rect().position;
	self.add_child(view_sprite);
	ui_handler.showUI(self);
	if (first_file_open):
		draw_node.draw_dividers(view_sprite, camera_node);
		div_selection_box.init(view_sprite);
	else:
		div_selection_box.lock();
		
	self._on_window_resized();
	on_anim_name_txt_changed();
	self.append_btn.disabled = false;
	self.anim_name_txt.readonly = false;
	
func _recentre_pressed():
	if (view_sprite):
		view_sprite.position = camera_node.get_viewport_rect().position;

func _on_window_resized():
	if (filedialog_open):
		if (filedialog_open.visible):
			filedialog_open.rect_size = camera_node.get_viewport_rect().size * camera_node.zoom;
			filedialog_open.rect_position = camera_node.get_viewport_rect().position - camera_node.get_viewport_rect().size/2 * camera_node.zoom;
	
	control_node.rect_position = camera_node.get_viewport_rect().position - camera_node.get_viewport_rect().size/2 * camera_node.zoom;
	control_node.rect_size = camera_node.get_viewport_rect().size * camera_node.zoom;
	scroll_container.div_vbox.rect_size = Vector2(scroll_container.div_vbox.rect_size.x, camera_node.get_viewport_rect().size.y/2);
	scroll_container.rect_size = scroll_container.div_vbox.rect_size;
	scroll_container.rect_size.y = camera_node.get_viewport_rect().size.y/2;
	scroll_container.margin_right = 140; #scroll_container.rect_size.x/3 + 40;
	scroll_container.margin_left = scroll_container.margin_right - scroll_container.rect_size.x;

	self._recentre_pressed();

func on_append_called():
	_create_directory();	
	self.export_sheet = appender.append_divs(self.export_sheet, self.export_rows, self.view_sprite, scroll_container.div_vbox.check_btns);
	var info_dict : Dictionary = appender.append_div_info(self.export_dict, self.view_sprite, scroll_container.div_vbox.check_btns, scroll_container.div_vbox.z_index_txtboxes, self.export_rows, self.anim_name_txt.text, self.anim_frame_txt.text);
	self.export_rows = export_rows + 1;
	self.anim_name_to_frames[self.anim_name_txt.text] = int(self.anim_frame_txt.text) + 1;
	self.append_btn.disabled = true;
	self.anim_name_txt.readonly = true;
	
func on_add_called():
	filedialog_open.show();
	
func on_export_called():
	print(self.export_sheet.save_png(Globals.SAVE_PATH + "/" + view_sprite_path + "/" + view_sprite_path + "_sheet.png"));
	self._save_info_dict(export_dict);

func _create_directory():
	var dir : Directory = Directory.new();
	dir.open(Globals.SAVE_PATH);
	dir.make_dir(view_sprite_path);

func _save_info_dict(info_dict : Dictionary):
	var info_dict_file : File = File.new();
	print(info_dict_file.open(Globals.SAVE_PATH + "/" + view_sprite_path + "/" + view_sprite_path + "_info.json", File.WRITE));
	
	var info_array = [];
	for key in info_dict.keys():
		info_array.append(info_dict[key]);	
	
	info_dict_file.store_line(to_json(info_array));
	info_dict_file.close();

func on_anim_name_txt_changed():
	if self.anim_name_to_frames.has(self.anim_name_txt.text):
		self.anim_frame_txt.text = str(anim_name_to_frames[self.anim_name_txt.text]);
	else:
		self.anim_frame_txt.text = "0";
