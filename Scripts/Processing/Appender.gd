extends Resource

static func append_divs(old_sheet : Image, export_rows : int, sprite : Sprite, check_btns : Array):
	var new_sheet : Image = Image.new();
	
	var divs : int = 0;
	for i in range(check_btns.size()):
		if (check_btns[i].pressed):
			divs = divs + 1;
	
	new_sheet.create(divs * Globals.div_size, (export_rows + 1) * Globals.div_size, false, Image.FORMAT_RGBA8);
	_copy_old_into_new_sheet(old_sheet, new_sheet);
	
	var add_index : int = 0;
	for div_index in range(check_btns.size()):
		if (!check_btns[div_index].pressed):
			continue;
		_add_div_to_sheet(new_sheet, sprite, div_index, add_index, export_rows);
		add_index = add_index + 1;
	return new_sheet;
	
static func _copy_old_into_new_sheet(old_sheet : Image, new_sheet : Image):
	old_sheet.lock();
	new_sheet.lock();
	for x in range(old_sheet.get_width()):
		for y in range(old_sheet.get_height()):
			new_sheet.set_pixel(x, y, old_sheet.get_pixel(x, y));
	old_sheet.unlock();
	new_sheet.unlock();

static func _add_div_to_sheet(sprite_sheet : Image, sprite : Sprite, div_index : int, add_index : int, export_rows : int):
	var x1 : int = (div_index * Globals.div_interval) % (sprite.texture.get_width() - Globals.div_size + Globals.div_interval);
	var x2 : int = x1 + Globals.div_size - 1;
	var y1 : int = (div_index * Globals.div_interval) / (sprite.texture.get_width() - Globals.div_size + Globals.div_interval) * Globals.div_interval;
	var y2 : int = y1 + Globals.div_size - 1;
	var sprite_img : Image = sprite.texture.get_data();
	
	var div_image : Image = Image.new();
	div_image.create(Globals.div_size, Globals.div_size, false, Image.FORMAT_RGBA8);
	for x in range(x1, x2):
		for y in range(y1, y2):
			div_image.lock();
			sprite_img.lock();
			div_image.set_pixel(x - x1, y - y1, sprite_img.get_pixel(x, y));
			sprite_img.unlock();
			div_image.unlock();
	div_image =  _cut_sprite_bot_corners(div_image);
	
	sprite_sheet.lock();
	div_image.lock();
	for x in range(Globals.div_size):
		for y in range(Globals.div_size):
			sprite_sheet.set_pixel(x + Globals.div_size * add_index, y + Globals.div_size * export_rows, div_image.get_pixel(x, y));
	sprite_sheet.unlock();
	div_image.unlock();
	
static func _cut_sprite_bot_corners(image : Image):
	image.lock();
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			if (x < image.get_width()/2):
				if (x % 2 == 0 and y > x/2 + 48):
					image.set_pixel(x, y, Color.transparent);
				elif (x % 2 != 0 and y > (x - 1)/2 + 48):
					image.set_pixel(x, y, Color.transparent);
			else:
				if (x % 2 == 0 and y > 79 - x/2):
					image.set_pixel(x, y, Color.transparent);
				elif (x % 2 != 0 and y > 79 - (x - 1)/2):
					image.set_pixel(x, y, Color.transparent);
	image.unlock();
	return image;
	
static func append_div_info(old_info_dict : Dictionary, sprite : Sprite, check_btns : Array, z_index_txtboxes : Array, export_rows : int, anim_name : String, anim_frame : String):
	var divs_added : int = 0;
	for div_index in range(check_btns.size()):
		if (!check_btns[div_index].pressed):
			continue;
		var sheet_position : Vector2 = Vector2(Globals.div_size * divs_added, Globals.div_size * export_rows);
		var size : Vector2 = Vector2(Globals.div_size, Globals.div_size);
		var split_index : int = div_index;
		var split_position : Vector2 = Vector2((div_index * Globals.div_interval) % (sprite.texture.get_width() - Globals.div_size + Globals.div_interval), (div_index * Globals.div_interval) / (sprite.texture.get_width() - Globals.div_size + Globals.div_interval) * Globals.div_interval) - sprite.texture.get_size()/2;
		var z_index : int = int(z_index_txtboxes[div_index].text);
		old_info_dict[old_info_dict.size()] = {"sheet_position" : sheet_position, "size" : size, "split_index" : split_index, "split_position" : split_position, "z_index" : z_index, "anim_name" : anim_name, "anim_frame" : int(anim_frame)};
		divs_added = divs_added + 1;
	return old_info_dict;
	
	
