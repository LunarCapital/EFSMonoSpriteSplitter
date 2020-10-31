extends Resource

static func find_all_UI_elements(main : Node2D):
	main.filedialog_open = main.find_node("FileDialog", true, true);
	main.append_btn = main.find_node("AppendBtn", true, true);
	main.add_btn = main.find_node("AddBtn", true, true);
	main.export_btn = main.find_node("ExportBtn", true, true);
	main.anim_name_txt = main.find_node("AnimNameTxt", true, true);
	main.anim_frame_txt = main.find_node("AnimFrameTxt", true, true);
	main.scroll_container = main.find_node("ScrollContainer", true, true);
	main.div_selection_box = main.find_node("DivSelectionBox", true, true);
	_connect_UI_signals(main);
	
static func _connect_UI_signals(main : Node2D):
	main.div_selection_box.connect("selected_division", main.draw_node, "on_div_selected");
	main.append_btn.connect("pressed", main, "on_append_called");
	main.add_btn.connect("pressed", main, "on_add_called");
	main.export_btn.connect("pressed", main, "on_export_called");
	main.anim_name_txt.connect("text_changed", main, "on_anim_name_txt_changed");

static func hideUI(main : Node2D):
	main.append_btn.hide();
	main.add_btn.hide();
	main.export_btn.hide();
	main.anim_name_txt.hide();
	main.anim_frame_txt.hide();
	main.scroll_container.hide();

static func showUI(main : Node2D):
	main.append_btn.show();
	main.add_btn.show();
	main.export_btn.show();
	main.anim_name_txt.show();
	main.anim_frame_txt.show();
	main.scroll_container.show();
