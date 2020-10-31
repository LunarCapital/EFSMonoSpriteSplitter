extends Node2D

var camera_node : Camera2D;
var view_sprite : Sprite;

var div_selected : bool = false;
var div_x1 : int;
var div_x2 : int;
var div_y1 : int;
var div_y2 : int;

func _draw():
	if (view_sprite == null || camera_node == null):
		return;
		
	var left_border : int = view_sprite.position.x - view_sprite.texture.get_width()/2;
	var right_border : int = view_sprite.position.x + view_sprite.texture.get_width()/2;
	var bot_border : int = view_sprite.position.y + view_sprite.texture.get_height()/2;
	var top_border : int = view_sprite.position.y - view_sprite.texture.get_height()/2;
	
	for w in range(left_border, view_sprite.texture.get_width() + 1 + left_border - Globals.div_size, Globals.div_interval):
		self._draw_division(w, w, bot_border, top_border, Color.black);
		self._draw_division(w + Globals.div_size, w + Globals.div_size, bot_border, top_border, Color.black);
	for h in range(top_border, view_sprite.texture.get_height() + 1 + top_border - Globals.div_size, Globals.div_interval):
		self._draw_division(left_border, right_border, h, h, Color.black);
		self._draw_division(left_border, right_border, h + Globals.div_size, h + Globals.div_size, Color.black);
		
	if (div_selected):
		self._draw_division(div_x1, div_x1, div_y1, div_y2, Color.aliceblue);
		self._draw_division(div_x2, div_x2, div_y1, div_y2, Color.aliceblue);
		self._draw_division(div_x1, div_x2, div_y1, div_y1, Color.aliceblue);
		self._draw_division(div_x1, div_x2, div_y2, div_y2, Color.aliceblue);
		
func _draw_division(x1 : int, x2 : int, y1: int, y2: int, color: Color):
	draw_line(Vector2(x1, y1), Vector2(x2, y2), color);

func draw_dividers(sprite : Sprite, camera_node : Camera2D):
	self.view_sprite = sprite;
	self.camera_node = camera_node;
	self.update();
	
func on_div_selected(x1 : int, x2 : int, y1 : int, y2: int):
	div_selected = true;
	var left_border : int = view_sprite.position.x - view_sprite.texture.get_width()/2;
	var top_border : int = view_sprite.position.y - view_sprite.texture.get_height()/2;
	self.div_x1 = x1 + left_border;
	self.div_x2 = x2 + left_border + 1;
	self.div_y1 = y1 + top_border;
	self.div_y2 = y2 + top_border + 1;
	self.update();

