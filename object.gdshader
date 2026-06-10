shader_type canvas_item;
uniform sampler2D mask_tex;
uniform float fill_level = 0.6;   // 0 = top, 1 = bottom
uniform float slosh = 0.0;         // update this from script
uniform float wave_amp = 0.0;
uniform float wave_freq = 10.0;
uniform float edge_softness = 0.02;

void fragment() {
	vec2 uv = UV;

	// Wavy surface line
	float wave = sin(uv.x * wave_freq + slosh) * wave_amp;
	float top = fill_level + wave;

	// Sample the liquid texture
	vec4 liquid = texture(TEXTURE, uv);

	// Mask clip: white = visible, black = hidden
	float mask = texture(mask_tex, uv).r;

	// Hide pixels above the wavy surface
	float inside = step(top, uv.y);

	COLOR = vec4(liquid.rgb, liquid.a * mask * inside);
}
