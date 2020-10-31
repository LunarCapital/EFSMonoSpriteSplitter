extends Resource

static func create_sprite_from_image(path : String):
	var img = Image.new();
	img.load(path);
	var texture = ImageTexture.new();
	texture.create_from_image(img);
	var sprite = Sprite.new();
	sprite.texture = texture;
	return sprite;
