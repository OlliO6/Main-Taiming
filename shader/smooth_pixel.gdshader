shader_type canvas_item;

#include "smooth_pixel_filtering.gdshaderinc"

void fragment()
{
	COLOR = texturePointSmooth(TEXTURE, UV, TEXTURE_PIXEL_SIZE);
}