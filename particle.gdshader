shader_type canvas_item;
uniform sampler2D bottle_mask;
uniform sampler2D mask_tex;

void fragment() {
	vec2 uv = (UV-vec2(.5))*2.0+vec2(.5)+vec2(.03,-.3);

	// Sample the liquid texture
	vec4 liquid = texture(TEXTURE, UV);

	// Mask clip: white = visible, black = hidden
	float mask1 = texture(mask_tex, uv).r;
	float mask2 = texture(bottle_mask,UV).r;
	float mask = mask1*mask2;
	COLOR = vec4(liquid.rgb, liquid.a * mask);

}
